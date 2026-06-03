import 'package:flutter/material.dart';
import 'control_console_screen.dart';
import 'provisioning_screen.dart';
import '../../core/services/secure_storage_service.dart';
import '../../core/services/device_info_service.dart';
import '../../core/network/dio_client.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;

    final secureStorage = SecureStorageService();
    final deviceInfo = DeviceInfoService();
    final dioClient = DioClient();

    bool isPaired = false;

    try {
      final serialNumber = await deviceInfo.getSerialNumber();
      final response = await dioClient.dio.post(
        '/android/screens/init',
        data: {'serialNumber': serialNumber},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final Map<String, dynamic> bodyData = responseData.containsKey('data') 
            ? (responseData['data'] as Map<String, dynamic>? ?? {}) 
            : responseData;

        final bool paired = bodyData['paired'] == true || 
            (bodyData.containsKey('screenToken') && bodyData['screenToken'] != null && bodyData['screenToken'].toString().isNotEmpty);

        if (paired) {
          await secureStorage.saveScreenCredentials(
            bodyData['screenId'].toString(),
            bodyData['screenToken'].toString(),
          );
          isPaired = true;
        } else {
          await secureStorage.clearCredentials();
          isPaired = false;
        }
      } else {
        isPaired = await secureStorage.hasCredentials();
      }
    } catch (e) {
      debugPrint('Startup init screen check failed: $e. Falling back to local credentials.');
      isPaired = await secureStorage.hasCredentials();
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => isPaired ? const ControlConsoleScreen() : const ProvisioningScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020810),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Splash Logo (Matched to Image 10)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white10),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.monitor, color: Colors.cyanAccent, size: 60),
                  Positioned(
                    child: Icon(Icons.play_arrow, color: Colors.greenAccent.withValues(alpha: 0.8), size: 30),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
            ),
          ],
        ),
      ),
    );
  }
}
