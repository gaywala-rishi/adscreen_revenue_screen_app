import 'dart:async';
import 'package:flutter/material.dart';
import 'player_screen.dart';
import '../widgets/diagnostics_hud.dart';
import '../../core/services/device_info_service.dart';

class ControlConsoleScreen extends StatefulWidget {
  const ControlConsoleScreen({super.key});

  @override
  State<ControlConsoleScreen> createState() => _ControlConsoleScreenState();
}

class _ControlConsoleScreenState extends State<ControlConsoleScreen> {
  final _deviceInfo = DeviceInfoService();
  Timer? _vitalsTimer;
  Map<String, dynamic>? _vitals;

  @override
  void initState() {
    super.initState();
    _startVitalsLoop();
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
    _vitalsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          // Left Side: Playout Port (Simulated Preview - Matched to Image 2)
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AdScreen Playout Port',
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Simulated Android TV physical display output',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const PlayerScreen()),
                          );
                        },
                        icon: const Icon(Icons.play_arrow, size: 16),
                        label: const Text('TV Fullscreen', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF020810),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: const PlayerScreen(isMuted: true),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFooterMiniStats(),
                ],
              ),
            ),
          ),
          // Right Side: Control Console HUD (Embedded)
          Expanded(
            flex: 5,
            child: DiagnosticsHUD(
              onClose: () {}, // Refresh logic or no-op when embedded
              isEmbedded: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterMiniStats() {
    final double cpu = _vitals?['cpu_load'] ?? 0.05;
    final double ram = _vitals?['ram_usage'] ?? 0.45;
    final double temp = _vitals?['temperature'] ?? 36.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: Colors.pinkAccent, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'FALLBACK OFFLINE PLAYBACK ACTIVE', 
              style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 12),
          _footerStat('CPU', '${(cpu * 100).toStringAsFixed(1)}%', Colors.blueAccent),
          const SizedBox(width: 12),
          _footerStat('RAM', '${(ram * 100).toStringAsFixed(1)}%', Colors.greenAccent),
          const SizedBox(width: 12),
          _footerStat('TEMP', '${temp.toStringAsFixed(1)}°C', Colors.pinkAccent),
        ],
      ),
    );
  }

  Widget _footerStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8)),
        Text(value, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
