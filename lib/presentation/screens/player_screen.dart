import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'provisioning_screen.dart';
import '../../core/services/secure_storage_service.dart';
import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../domain/models/layout_config.dart';
import '../../domain/models/playlist_content.dart';
import '../../data/local/isar_database_manager.dart';
import '../widgets/multi_zone_presenter.dart';
import '../widgets/diagnostics_hud.dart';
import '../../core/services/socket_service.dart';
import '../../core/services/playlist_update_notifier.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final _dioClient = DioClient();
  LayoutConfig? _layout;
  bool _isLoading = true;
  String? _error;
  bool _showHUD = false;
  bool _isRebooting = false;

  int _playlistVersion = 0;

  @override
  void initState() {
    super.initState();
    _fetchContent();
    PlaylistUpdateNotifier.notifier.addListener(_onPlaylistUpdated);
  }

  void _onPlaylistUpdated() {
    if (mounted) {
      setState(() {
        _playlistVersion++;
      });
    }
  }

  Future<void> _fetchContent() async {
    final secureStorage = SecureStorageService();
    try {
      final isPaired = await secureStorage.hasCredentials();

      if (!isPaired) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const ProvisioningScreen()),
          );
        }
        return;
      }

      final response = await _dioClient.dio.get('/android/screens/MOCK-ID/content');
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          await secureStorage.saveCachedLayout(responseData);
          await _parseAndDisplaySchedule(responseData, secureStorage);
        }
      }
    } on DioException catch (e) {
      // Offline fallback: try loading from cache
      final cachedJson = await secureStorage.getCachedLayout();
      if (cachedJson != null) {
        debugPrint('[PlayerScreen] Offline mode: loading cached layout configuration');
        await _parseAndDisplaySchedule(cachedJson, secureStorage);
        return;
      }

      if (e.response?.statusCode == 401 || e.response?.statusCode == 403 || e.response?.statusCode == 404) {
        await secureStorage.clearCredentials();
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const ProvisioningScreen()),
          );
        }
        return;
      }
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _parseAndDisplaySchedule(Map<String, dynamic> responseData, SecureStorageService secureStorage) async {
    Map<String, dynamic>? schedule;
    if (responseData.containsKey('data') && responseData['data'] is Map<String, dynamic> && responseData['data'].containsKey('schedule')) {
      schedule = responseData['data']['schedule'] as Map<String, dynamic>?;
    } else if (responseData.containsKey('schedule')) {
      schedule = responseData['schedule'] as Map<String, dynamic>?;
    } else if (responseData.containsKey('layout')) {
      schedule = responseData;
    }

    if (schedule == null) {
      setState(() {
        _error = "No content scheduled";
        _isLoading = false;
      });
      return;
    }

    // 1. Parse Layout
    final layout = LayoutConfig.fromJson(schedule['layout'] as Map<String, dynamic>);
    
    // 2. Parse and Save Playlists to Isar, preserving cached flags
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
          allContents.add(PlaylistContent(
            contentId: contentId,
            url: item['url']?.toString() ?? '',
            type: item['contentType']?.toString() ?? 'image',
            durationSeconds: (item['durationSeconds'] as num?)?.toInt() ?? 30,
            regionId: regionId,
            order: order++,
            isDownloaded: existing?.isDownloaded ?? false,
            localPath: existing?.localPath,
          ));
        }
      }
    });

    await IsarDatabaseManager.updatePlaylist(allContents);

    // Initialize authenticated WebSocket to listen for incoming admin commands (Ping, Sync, Reboot)
    final token = await secureStorage.getScreenToken();
    if (token != null) {
      SocketService().initAuthenticatedSocket(
        token: token,
        onSyncCommand: () {
          debugPrint('[PlayerScreen] WebSocket command: SYNC content');
          _fetchContent();
        },
        onRebootCommand: () {
          debugPrint('[PlayerScreen] WebSocket command: REBOOT device');
          _simulateReboot();
        },
      );
    }

    setState(() {
      _layout = layout;
      _playlistVersion++;
      _isLoading = false;
      _error = null;
    });
  }

  void _simulateReboot() {
    setState(() {
      _isRebooting = true;
      _isLoading = true;
      _error = null;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isRebooting = false;
        });
        _fetchContent();
      }
    });
  }

  @override
  void dispose() {
    PlaylistUpdateNotifier.notifier.removeListener(_onPlaylistUpdated);
    SocketService().dispose();
    super.dispose();
  }

  void _toggleHUD() {
    setState(() {
      _showHUD = !_showHUD;
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.keyD) {
            _toggleHUD();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: Colors.cyanAccent),
                        if (_isRebooting) ...[
                          const SizedBox(height: 24),
                          const Text(
                            'SYSTEM REBOOTING...',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ]
                      ],
                    ),
                  )
                : _error != null
                    ? Center(child: Text('Error: $_error', style: const TextStyle(color: Colors.white)))
                    : MultiZonePresenter(key: ValueKey(_playlistVersion), layout: _layout!),
            if (_showHUD)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black45,
                  child: DiagnosticsHUD(onClose: _toggleHUD),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
