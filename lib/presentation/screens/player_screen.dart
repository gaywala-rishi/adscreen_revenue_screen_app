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

  @override
  void initState() {
    super.initState();
    _fetchContent();
  }

  Future<void> _fetchContent() async {
    try {
      final secureStorage = SecureStorageService();
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
        final data = response.data;
        
        // 1. Parse Layout
        final layout = LayoutConfig.fromJson(data['layout']);
        
        // 2. Parse and Save Playlists to Isar
        List<PlaylistContent> allContents = [];
        final playlists = data['playlists'] as Map<String, dynamic>;
        
        playlists.forEach((regionId, list) {
          int order = 0;
          for (var item in (list as List)) {
            allContents.add(PlaylistContent(
              contentId: item['id'],
              url: item['url'],
              type: item['type'],
              durationSeconds: item['duration'],
              regionId: regionId,
              order: order++,
            ));
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
          _isLoading = false;
        });
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403 || e.response?.statusCode == 404) {
        final secureStorage = SecureStorageService();
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
                    : MultiZonePresenter(layout: _layout!),
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
