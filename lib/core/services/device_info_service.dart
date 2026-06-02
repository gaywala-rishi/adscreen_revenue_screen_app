import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<String> getSerialNumber() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        // serialNumber is often restricted in newer Android versions.
        // Falling back to hardware or model + id as a stable identifier.
        return androidInfo.id; 
      } else if (Platform.isWindows) {
        WindowsDeviceInfo windowsInfo = await _deviceInfo.windowsInfo;
        return windowsInfo.deviceId;
      }
      return 'UNKNOWN_SERIAL';
    } catch (e) {
      return 'ERROR_SERIAL';
    }
  }

  Future<Map<String, dynamic>> getVitals() async {
    // Basic vitals for now, will be expanded in Phase 4
    return {
      'platform': Platform.operatingSystem,
      'os_version': Platform.operatingSystemVersion,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
