import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/services/device_info_service.dart';
import '../../core/services/secure_storage_service.dart';
import '../../data/local/isar_database_manager.dart';
import '../../data/local/metrics_buffer_manager.dart';
import '../../core/services/playlist_update_notifier.dart';
import '../../domain/models/content_play_log.dart';
import '../../domain/models/playlist_content.dart';
import '../screens/provisioning_screen.dart';
import '../../core/network/dio_client.dart';
import '../../core/services/socket_service.dart';
import '../../data/remote/asset_download_manager.dart';

class DiagnosticsHUD extends StatefulWidget {
  final VoidCallback onClose;
  final bool isEmbedded;
  const DiagnosticsHUD({super.key, required this.onClose, this.isEmbedded = false});

  @override
  State<DiagnosticsHUD> createState() => _DiagnosticsHUDState();
}

class _DiagnosticsHUDState extends State<DiagnosticsHUD> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _deviceInfo = DeviceInfoService();
  Timer? _vitalsTimer;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  
  String _serial = 'Loading...';
  String _uuid = 'Loading...';
  String _os = 'Loading...';

  Map<String, dynamic>? _vitals;
  int _bufferedOffline = 0;
  int _syncedCloud = 0;
  int _cachedSchedules = 0;
  List<PlaylistContent> _cachedPlaylists = [];
  List<ContentPlayLog> _pendingLogs = [];

  String _screenName = 'Loading...';
  String _venueName = 'Loading...';
  String _venueAddress = 'Loading...';

  bool _isSyncing = false;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  double? _streamDiffSeconds;
  bool _isSyncingDiff = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadStaticInfo();
    _startVitalsLoop();
    _initConnectivity();
  }

  Future<void> _loadStaticInfo() async {
    final serial = await _deviceInfo.getSerialNumber();
    final secureStorage = SecureStorageService();
    final screenId = await secureStorage.getScreenId() ?? 'Unregistered';
    final vitals = await _deviceInfo.getVitals();
    final pending = await IsarDatabaseManager.getPendingLogs(1000);
    final allContents = await IsarDatabaseManager.getAllContents();
    
    final synced = await secureStorage.getSyncedLogsCount();
    
    String screenName = 'Unregistered';
    String venueName = 'Unknown Venue';
    String venueAddress = 'Unknown Address';

    final isPaired = await secureStorage.hasCredentials();
    if (isPaired && screenId != 'Unregistered') {
      try {
        final response = await DioClient().dio.get('/android/screens/$screenId/config');
        if (response.statusCode == 200) {
          final data = response.data['data'];
          if (data != null) {
            screenName = data['screenName'] ?? screenName;
            final venue = data['venue'];
            if (venue != null) {
              venueName = venue['name'] ?? venueName;
              final city = venue['city'] ?? '';
              final address = venue['address'] ?? '';
              venueAddress = '$address, $city'.trim();
              if (venueAddress == ',') venueAddress = 'Unknown Address';
            }
          }
        }
      } catch (e) {
        debugPrint('Failed to fetch screen details: $e');
      }
    }
    
    if (mounted) {
      setState(() {
        _serial = serial;
        _uuid = screenId;
        _os = vitals['platform'];
        _bufferedOffline = pending.length;
        _pendingLogs = pending.take(20).toList();
        _syncedCloud = synced;
        _cachedSchedules = allContents.length;
        _cachedPlaylists = allContents;
        _vitals = vitals;
        _screenName = screenName;
        _venueName = venueName;
        _venueAddress = venueAddress;
      });
    }
  }

  void _startVitalsLoop() {
    _vitalsTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      final vitals = await _deviceInfo.getVitals();
      final pending = await IsarDatabaseManager.getPendingLogs(1000);
      final allContents = await IsarDatabaseManager.getAllContents();
      final secureStorage = SecureStorageService();
      final synced = await secureStorage.getSyncedLogsCount();
      if (mounted) {
        setState(() {
          _vitals = vitals;
          _os = vitals['platform'];
          _bufferedOffline = pending.length;
          _pendingLogs = pending.take(20).toList();
          _syncedCloud = synced;
          _cachedSchedules = allContents.length;
          _cachedPlaylists = allContents;
        });
      }
    });
  }

  Future<void> _initConnectivity() async {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (mounted) {
        final wasOffline = _connectivityResult == ConnectivityResult.none;
        setState(() {
          _connectivityResult = result;
        });
        if (wasOffline && result != ConnectivityResult.none) {
          debugPrint('[DiagnosticsHUD] Connectivity restored to $result. Syncing buffered data.');
          _syncAllData();
        }
      }
    });

    try {
      final result = await Connectivity().checkConnectivity();
      if (mounted) {
        setState(() {
          _connectivityResult = result;
        });
      }
    } catch (e) {
      debugPrint('[DiagnosticsHUD] Connectivity check failed: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _vitalsTimer?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _syncAllData() async {
    if (_isSyncing) return;
    if (_connectivityResult == ConnectivityResult.none) {
      debugPrint('[DiagnosticsHUD] Sync skipped: Network is offline');
      return;
    }

    setState(() {
      _isSyncing = true;
    });

    try {
      // 1. Sync pending metrics to backend
      final metricsManager = MetricsBufferManager();
      await metricsManager.syncMetrics();

      // 2. Fetch campaign metadata from backend
      final secureStorage = SecureStorageService();
      final isPaired = await secureStorage.hasCredentials();
      if (isPaired) {
        final screenId = await secureStorage.getScreenId() ?? 'MOCK-ID';
        final response = await DioClient().dio.get('/android/screens/$screenId/content');
        if (response.statusCode == 200) {
          final responseData = response.data;
          if (responseData is Map<String, dynamic>) {
            await secureStorage.saveCachedLayout(responseData);

            // Extract schedule data
            Map<String, dynamic>? schedule;
            if (responseData.containsKey('data') && responseData['data'] is Map<String, dynamic> && responseData['data'].containsKey('schedule')) {
              schedule = responseData['data']['schedule'] as Map<String, dynamic>?;
            } else if (responseData.containsKey('schedule')) {
              schedule = responseData['schedule'] as Map<String, dynamic>?;
            } else if (responseData.containsKey('layout')) {
              schedule = responseData;
            }

            if (schedule != null) {
              // 3. Save layout configuration & playlists
              final existingContents = await IsarDatabaseManager.getAllContents();
              final existingMap = {for (var c in existingContents) c.contentId: c};

              List<PlaylistContent> allContents = [];
              final regionsData = schedule['regionsData'] as Map<String, dynamic>? ?? {};

              regionsData.forEach((regionId, regionObj) {
                if (regionObj is Map<String, dynamic> && regionObj.containsKey('items')) {
                  final list = regionObj['items'] as List? ?? [];
                  int order = 0;
                  for (var item in list) {
                    final contentId = item['contentId']?.toString() ?? '';
                    final existing = existingMap[contentId];

                    final isYoutube = item['contentType']?.toString() == 'youtube_url';
                    final isDownloaded = isYoutube ? false : (existing?.isDownloaded ?? false);
                    final localPath = isYoutube ? null : existing?.localPath;

                    allContents.add(PlaylistContent(
                      contentId: contentId,
                      url: item['url']?.toString() ?? '',
                      type: item['contentType']?.toString() ?? 'image',
                      durationSeconds: (item['durationSeconds'] as num?)?.toInt() ?? 30,
                      regionId: regionId,
                      order: order++,
                      isDownloaded: isDownloaded,
                      localPath: localPath,
                    ));
                  }
                }
              });

              // Write to Isar
              await IsarDatabaseManager.updatePlaylist(allContents);
              PlaylistUpdateNotifier.notify();

              // Trigger actual asset downloading in the background
              AssetDownloadManager().syncAssets();
            }
          }
        }
      }
    } catch (e) {
      debugPrint('[DiagnosticsHUD] Sync error: $e');
    } finally {
      await _loadStaticInfo(); // Reload display lists and counts
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  Future<void> _triggerCampaignDiff() async {
    if (_isSyncingDiff) return;
    setState(() {
      _isSyncingDiff = true;
    });

    try {
      final start = DateTime.now();
      final healthUrl = DioClient.activeBaseUrl.replaceAll('/api/v1', '/health');
      final response = await DioClient().dio.get(healthUrl);
      final end = DateTime.now();

      if (response.statusCode == 200) {
        final serverTimeStr = response.data['timestamp']?.toString();
        if (serverTimeStr != null) {
          final serverTime = DateTime.parse(serverTimeStr);
          final localMid = start.add(end.difference(start) ~/ 2);
          final drift = serverTime.difference(localMid);
          final driftSeconds = drift.inMilliseconds / 1000.0;
          
          setState(() {
            _streamDiffSeconds = driftSeconds;
          });
          debugPrint('[DiagnosticsHUD] Campaign streaming synced. Difference: ${driftSeconds.toStringAsFixed(3)}s');
        }
      }
    } catch (e) {
      debugPrint('[DiagnosticsHUD] Failed to sync campaign streaming difference: $e');
    } finally {
      setState(() {
        _isSyncingDiff = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEmbedded) {
      return _buildMainHUDContent();
    }

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: const Color(0xFF020810).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 40, spreadRadius: 10),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildMainHUDContent(),
      ),
    );
  }

  Widget _buildMainHUDContent() {
    return Column(
      children: [
        _buildHeader(),
        _buildTabBar(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildRegistrationTab(),
              _buildSyncTab(),
              _buildHealthTab(),
              _buildPlayoutLogsTab(),
            ],
          ),
        ),
        if (!widget.isEmbedded) _buildFooter(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AdScreen DOOH Control Console',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Uptime: 24/7 Simulator Supervisor Engine',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                tooltip: 'Sync Offline Data',
                onPressed: _isSyncing ? null : _syncAllData,
                icon: _isSyncing 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.cyanAccent),
                      )
                    : const Icon(Icons.sync, color: Colors.cyanAccent),
              ),
              if (!widget.isEmbedded) ...[
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Close Diagnostics',
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close, color: Colors.white54),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.cyanAccent,
        unselectedLabelColor: Colors.white54,
        indicatorColor: Colors.cyanAccent,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Registration'),
          Tab(text: 'Sync & DB'),
          Tab(text: 'Health Logs'),
          Tab(text: 'Playout Logs'),
        ],
      ),
    );
  }

  Widget _buildRegistrationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Device Association',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () async {
                  final secureStorage = SecureStorageService();
                  
                  // Show loading indicator
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(color: Colors.cyanAccent),
                    ),
                  );

                  try {
                    final dioClient = DioClient();
                    final screenId = await secureStorage.getScreenId() ?? 'MOCK-ID';
                    await dioClient.dio.post('/android/screens/$screenId/reset');
                  } catch (e) {
                    debugPrint('Failed to notify backend on screen reset: $e');
                  }

                  // Disconnect WebSocket
                  SocketService().dispose();

                  // Delete all cached videos/assets
                  await AssetDownloadManager.clearAllCachedAssets();

                  // Clear local database tables
                  await IsarDatabaseManager.clearDatabase();

                  await secureStorage.clearCredentials();

                  if (mounted) {
                    // Dismiss loading dialog
                    Navigator.of(context).pop();

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const ProvisioningScreen()),
                      (route) => false,
                    );
                  }
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Disconnect',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoCard('PROVISIONED DETAILS', [
            _buildInfoRow('Screen Name', _screenName),
            _buildInfoRow('Venue Name', _venueName),
            _buildInfoRow('Venue Address', _venueAddress),
          ]),
          const SizedBox(height: 24),
          _buildInfoCard('HARDWARE METADATA', [
            _buildInfoRow('Hardware Serial', _serial),
            _buildInfoRow('System UUID', _uuid),
            _buildInfoRow('OS Platform', _os),
          ]),
        ],
      ),
    );
  }

  Widget _buildSyncTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Offline-First Sync Engine', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildCampaignDiffButton(),
              const SizedBox(width: 16),
              _buildConnectionStatusCard(),
            ],
          ),
          const SizedBox(height: 32),
          Text('ROOM DATABASE CACHED CAMPAIGN CONTENT ($_cachedSchedules ITEMS)', style: TextStyle(color: Colors.blueAccent.withValues(alpha: 0.7), fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (_cachedPlaylists.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Text(
                  'No cached offline playlist content in Isar.',
                  style: TextStyle(color: Colors.white30, fontSize: 13),
                ),
              ),
            )
          else
            ..._cachedPlaylists.map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildScheduleItem(
                c.contentId == 'MOCK-CAMPAIGN-AD' ? '🔥 Campaign Diff: Special Promo' : 'Playout Ad Content ${c.contentId}',
                c.type.toUpperCase(),
                '${c.durationSeconds}s',
                regionId: c.regionId,
                localPath: c.localPath,
                isDownloaded: c.isDownloaded,
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildCampaignDiffButton() {
    final color = _streamDiffSeconds != null ? Colors.greenAccent : Colors.cyanAccent;
    String text;
    if (_isSyncingDiff) {
      text = 'Syncing Diff...';
    } else if (_streamDiffSeconds != null) {
      text = 'Diff: ${_streamDiffSeconds! >= 0 ? '+' : ''}${_streamDiffSeconds!.toStringAsFixed(3)}s';
    } else {
      text = 'Sync Campaign Diff';
    }

    return Expanded(
      child: InkWell(
        onTap: _isSyncingDiff ? null : _triggerCampaignDiff,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_isSyncingDiff ? Icons.hourglass_empty : Icons.timelapse, color: color, size: 20),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionStatusCard() {
    IconData icon;
    String text;
    Color color;

    switch (_connectivityResult) {
      case ConnectivityResult.wifi:
        icon = Icons.wifi;
        text = 'WiFi Connected';
        color = Colors.greenAccent;
        break;
      case ConnectivityResult.ethernet:
        icon = Icons.lan;
        text = 'Ethernet Connected';
        color = Colors.greenAccent;
        break;
      case ConnectivityResult.none:
      default:
        icon = Icons.signal_wifi_off;
        text = 'Network Disconnected';
        color = Colors.redAccent;
        break;
    }

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                text,
                style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthTab() {
    final double cpu = _vitals?['cpu_load'] ?? 0.05;
    final double ram = _vitals?['ram_usage'] ?? 0.45;
    final double temp = _vitals?['temperature'] ?? 36.0;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Diagnostics & Autonomous Self-Healing', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Real-time metrics sent dynamically to central system via heartbeats.', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 32),
          _buildInfoCard('HARDWARE TELEMETRY SPARKBARS', [
            _buildProgressRow('CPU Load', cpu, '${(cpu * 100).toStringAsFixed(1)}%', Colors.blue),
            const SizedBox(height: 20),
            _buildProgressRow('RAM Usage', ram, '${(ram * 100).toStringAsFixed(1)}%', Colors.green),
            const SizedBox(height: 20),
            _buildProgressRow('Temperature', temp / 100.0, '${temp.toStringAsFixed(1)}°C', Colors.pinkAccent),
          ]),
        ],
      ),
    );
  }

  Widget _buildPlayoutLogsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ad Performance Playout Audit Logs', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Verify secure local storage logging representing real ad impressions.', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: _buildStatBox('BUFFERED OFFLINE', _bufferedOffline.toString())),
              const SizedBox(width: 24),
              Expanded(child: _buildStatBox('SYNCED CLOUD-SAFE', _syncedCloud.toString())),
            ],
          ),
          const SizedBox(height: 24),
          Text('ROOM DATABASE PLAY TRACKS Log: \'ad_impressions\'', style: TextStyle(color: Colors.blueAccent.withValues(alpha: 0.7), fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (_pendingLogs.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Text(
                  'No pending offline play logs in Isar.',
                  style: TextStyle(color: Colors.white30, fontSize: 13),
                ),
              ),
            )
          else
            ..._pendingLogs.map((log) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Content ID: ${log.contentId}',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Region: ${log.layoutRegionId} | Played At: ${log.playedAt.toLocal().toString().split('.').first}',
                            style: const TextStyle(color: Colors.white38, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    const Text('BUFFERED', style: TextStyle(color: Colors.orangeAccent, fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.blueAccent.withValues(alpha: 0.7), fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'monospace',
            ),
            softWrap: true,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String label, double progress, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(color: Colors.orangeAccent, fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(
    String title,
    String category,
    String duration, {
    required String regionId,
    String? localPath,
    required bool isDownloaded,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDownloaded ? Colors.cyanAccent.withValues(alpha: 0.15) : Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  'Region: $regionId | Type: $category | Duration: $duration', 
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
                if (localPath != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Local: $localPath',
                    style: const TextStyle(color: Colors.white30, fontSize: 9, fontFamily: 'monospace'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDownloaded ? Colors.green.withValues(alpha: 0.2) : Colors.orange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: isDownloaded ? Colors.green : Colors.orange, width: 0.5),
            ),
            child: Text(
              isDownloaded ? 'CACHED' : 'PENDING',
              style: TextStyle(
                color: isDownloaded ? Colors.greenAccent : Colors.orangeAccent,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final double cpu = _vitals?['cpu_load'] ?? 0.05;
    final double temp = _vitals?['temperature'] ?? 32.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.circle, color: Colors.green, size: 10),
              SizedBox(width: 8),
              Text('SERVER LINK ACTIVE', style: TextStyle(color: Colors.cyanAccent, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              _buildFooterMiniStat('CPU LOAD', '${(cpu * 100).toStringAsFixed(1)}%'),
              const SizedBox(width: 20),
              _buildFooterMiniStat('TEMPERATURE', '${temp.toStringAsFixed(1)}°C', valueColor: Colors.pinkAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterMiniStat(String label, String value, {Color valueColor = Colors.blueAccent}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 8, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(color: valueColor, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
