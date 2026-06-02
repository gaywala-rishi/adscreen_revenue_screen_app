import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_background_service/flutter_background_service.dart';
import 'device_info_service.dart';
import '../network/dio_client.dart';

class BackgroundServiceManager {
  static Future<void> initializeService() async {
    if (kIsWeb) {
      print('Background Service is not supported on Web. Skipping initialization.');
      return;
    }

    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: 'adscreen_player_service',
        initialNotificationTitle: 'AdScreen Player',
        initialNotificationContent: 'Running background sync...',
        foregroundServiceNotificationId: 888,
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

    final dioClient = DioClient();
    final deviceInfo = DeviceInfoService();

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

    // Heartbeat Loop
    Timer.periodic(const Duration(seconds: 60), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          final vitals = await deviceInfo.getVitals();
          
          try {
            await dioClient.dio.post(
              '/android/screens/MOCK-ID/heartbeat',
              data: vitals,
            );
            
            service.setForegroundNotificationInfo(
              title: "AdScreen Player [Online]",
              content: "Last Heartbeat: ${DateTime.now().hour}:${DateTime.now().minute}",
            );
          } catch (e) {
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
