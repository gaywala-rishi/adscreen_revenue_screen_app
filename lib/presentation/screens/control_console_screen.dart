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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AdScreen Playout Port',
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Simulated Android TV physical display output',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const PlayerScreen()),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('TV Fullscreen'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Mock "Unregistered" preview box inside port
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF020810),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lock_outline, color: Colors.blueAccent, size: 60),
                            SizedBox(height: 16),
                            Text(
                              'AdScreen Board Unregistered',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Pair this display to your cloud to start',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: Colors.pinkAccent, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          const Text('FALLBACK OFFLINE PLAYBACK ACTIVE', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
          const Spacer(),
          _footerStat('CPU LOAD', '2.7%', Colors.blueAccent),
          const SizedBox(width: 24),
          _footerStat('TEMPERATURE', '36.4°C', Colors.pinkAccent),
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
