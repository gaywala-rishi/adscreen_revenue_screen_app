import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final Battery _battery = Battery();
  final Random _random = Random();

  static Map<String, dynamic>? _cachedVitals;
  static DateTime? _lastFetchTime;

  Future<String> getSerialNumber() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
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

  Future<String> getSystemUUID() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        // Using fingerprint + hardware for a more unique-looking simulated UUID
        return '${androidInfo.brand}-${androidInfo.hardware}-${androidInfo.id}';
      }
      return 'SIM-UUID-${_random.nextInt(99999)}';
    } catch (e) {
      return 'ERR-UUID';
    }
  }

  Future<Map<String, dynamic>> getVitals() async {
    final now = DateTime.now();
    if (_cachedVitals != null && _lastFetchTime != null && now.difference(_lastFetchTime!).inMilliseconds < 1500) {
      return _cachedVitals!;
    }

    final batteryLevel = await _battery.batteryLevel;
    
    // Improved simulation for realistic movement
    final double timeSeconds = now.millisecondsSinceEpoch / 1000.0;
    const double cpuBase = 0.10;
    final double cpuVariation = 0.05 * sin(timeSeconds / 5.0) + (_random.nextDouble() * 0.02);
    final double cpuLoad = (cpuBase + cpuVariation).clamp(0.02, 0.95);
    
    const double tempBase = 36.0;
    final double tempVariation = 2.0 * sin(timeSeconds / 10.0) + (_random.nextDouble() * 0.5);
    final double temp = (tempBase + tempVariation).clamp(30.0, 45.0);
    
    _cachedVitals = {
      'platform': Platform.isAndroid ? 'Android ${Platform.operatingSystemVersion}' : Platform.operatingSystem,
      'os_version': Platform.operatingSystemVersion,
      'battery_level': batteryLevel,
      'cpu_load': cpuLoad,
      'temperature': temp,
      'ram_usage': 0.48 + (0.02 * cos(timeSeconds / 7.0)) + (_random.nextDouble() * 0.01),
      'timestamp': now.toIso8601String(),
    };
    _lastFetchTime = now;
    return _cachedVitals!;
  }
}
