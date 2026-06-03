import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/services/device_info_service.dart';
import '../../core/services/secure_storage_service.dart';
import '../../data/local/isar_database_manager.dart';
import '../screens/provisioning_screen.dart';
import '../../core/network/dio_client.dart';
import '../../core/services/socket_service.dart';

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
  
  String _serial = 'Loading...';
  String _uuid = 'Loading...';
  String _os = 'Loading...';

  Map<String, dynamic>? _vitals;
  int _bufferedOffline = 0;
  final int _syncedCloud = 0;
  int _cachedSchedules = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadStaticInfo();
    _startVitalsLoop();
  }

  Future<void> _loadStaticInfo() async {
    final serial = await _deviceInfo.getSerialNumber();
    final uuid = await _deviceInfo.getSystemUUID();
    final vitals = await _deviceInfo.getVitals();
    final pending = await IsarDatabaseManager.getPendingLogs(1000);
    final allContents = await IsarDatabaseManager.getAllContents();
    
    if (mounted) {
      setState(() {
        _serial = serial;
        _uuid = uuid;
        _os = vitals['platform'];
        _bufferedOffline = pending.length;
        _cachedSchedules = allContents.length;
        _vitals = vitals;
      });
    }
  }

  void _startVitalsLoop() {
    _vitalsTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      final vitals = await _deviceInfo.getVitals();
      if (mounted) {
        setState(() {
          _vitals = vitals;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _vitalsTimer?.cancel();
    super.dispose();
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
          IconButton(
            onPressed: widget.onClose,
            icon: const Icon(Icons.refresh, color: Colors.white54),
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
          const Text('Device Association & Security', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Register with the central DOOH panel to verify server authentication.', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 32),
          _buildInfoCard('HARDWARE METADATA', [
            _buildInfoRow('Hardware Serial', _serial),
            _buildInfoRow('System UUID', _uuid),
            _buildInfoRow('OS Platform', _os),
          ]),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton.icon(
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
                  await dioClient.dio.post('/android/screens/MOCK-ID/reset');
                } catch (e) {
                  debugPrint('Failed to notify backend on screen reset: $e');
                }

                // Disconnect WebSocket
                SocketService().dispose();

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
              icon: const Icon(Icons.link_off, color: Colors.black),
              label: const Text('DISCONNECT & RESET DEVICE', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
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
              _buildActionButton(Icons.sync, 'Trigger Campaign Diff'),
              const SizedBox(width: 16),
              _buildActionButton(Icons.wifi, 'Simulate WiFi Restored', color: Colors.pinkAccent),
            ],
          ),
          const SizedBox(height: 32),
          Text('SQLITE ROOM CACHED SCHEDULES ($_cachedSchedules ACTIVE)', style: TextStyle(color: Colors.blueAccent.withValues(alpha: 0.7), fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildScheduleItem('Premium Roast Latte Promo', 'Cafe Venue', '6s', isPlaying: true),
        ],
      ),
    );
  }

  Widget _buildHealthTab() {
    final double cpu = _vitals?['cpu_load'] ?? 0.05;
    final double ram = _vitals?['ram_usage'] ?? 0.45;
    
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
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
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

  Widget _buildActionButton(IconData icon, String label, {Color color = Colors.white10}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color == Colors.white10 ? color : color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color == Colors.white10 ? Colors.white10 : color.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color == Colors.white10 ? Colors.white54 : color, size: 16),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: color == Colors.white10 ? Colors.white54 : color, fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String title, String category, String duration, {bool isPlaying = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isPlaying ? Colors.cyanAccent.withValues(alpha: 0.5) : Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Category: $category | Duration: $duration', style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          if (isPlaying)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.cyanAccent, borderRadius: BorderRadius.circular(4)),
              child: const Text('PLAYING NOW', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          const SizedBox(width: 12),
          const Text('CACHED', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
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
