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

    // Using default configuration to ensure maximum compatibility
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        initialNotificationTitle: 'AdScreen Player',
        initialNotificationContent: 'Monitoring device health...',
        foregroundServiceNotificationId: 888,
        foregroundServiceTypes: [AndroidForegroundType.dataSync],
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

    // Heartbeat Loop using WebSockets
    Timer.periodic(const Duration(seconds: 60), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
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
              
              service.setForegroundNotificationInfo(
                title: "AdScreen Player [Online]",
                content: "Last Socket Heartbeat: ${DateTime.now().hour}:${DateTime.now().minute}",
              );
            } else {
              debugPrint('[BackgroundService] No token found in background service. Telemetry skipped.');
              service.setForegroundNotificationInfo(
                title: "AdScreen Player [Offline]",
                content: "Unpaired display - waiting for pairing PIN",
              );
            }
          } catch (e) {
            debugPrint('[BackgroundService] Telemetry loop error: $e');
            service.setForegroundNotificationInfo(
              title: "AdScreen Player [Offline]",
              content: "Sync Error: ${e.toString().split('\n').first}",
            );
          }
        }
      }
    });
  }
}
