import 'dart:async';
import 'dart:ui';
// Added for Colors
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_background_service/flutter_background_service.dart';
import 'device_info_service.dart';
import 'secure_storage_service.dart';
import 'socket_service.dart';

@pragma('vm:entry-point')
class BackgroundServiceManager {
  static Future<void> initializeService() async {
    if (kIsWeb) {
      debugPrint('Background Service is not supported on Web. Skipping initialization.');
      return;
    }

    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: false,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    final deviceInfo = DeviceInfoService();
    final socketService = SocketService();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    // Heartbeat Loop using WebSockets - fixed 4-second interval
    Timer.periodic(const Duration(seconds: 4), (timer) async {
      final vitals = await deviceInfo.getVitals();
      
      try {
        final secureStorage = SecureStorageService();
        final token = await secureStorage.getScreenToken();
        
        if (token != null) {
          if (!socketService.isConnected) {
            debugPrint('[BackgroundService] Socket disconnected. Connecting authenticated socket...');
            socketService.initAuthenticatedSocket(token: token);
          }
          socketService.emitTelemetry(vitals);
        } else {
          debugPrint('[BackgroundService] No token found in background service. Telemetry skipped.');
        }
      } catch (e) {
        debugPrint('[BackgroundService] Telemetry loop error: $e');
      }
    });
  }
}
