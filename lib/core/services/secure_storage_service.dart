import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const String _keyScreenId = 'screen_id';
  static const String _keyScreenToken = 'screen_token';
  static const String _keyCachedLayout = 'cached_layout';

  Future<void> saveScreenCredentials(String screenId, String token) async {
    await _storage.write(key: _keyScreenId, value: screenId);
    await _storage.write(key: _keyScreenToken, value: token);
  }

  Future<String?> getScreenId() async {
    return await _storage.read(key: _keyScreenId);
  }

  Future<String?> getScreenToken() async {
    return await _storage.read(key: _keyScreenToken);
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: _keyScreenId);
    await _storage.delete(key: _keyScreenToken);
    await _storage.delete(key: _keyCachedLayout);
  }

  Future<bool> hasCredentials() async {
    final id = await getScreenId();
    final token = await getScreenToken();
    return id != null && token != null;
  }

  Future<void> saveCachedLayout(Map<String, dynamic> layoutJson) async {
    final jsonStr = jsonEncode(layoutJson);
    await _storage.write(key: _keyCachedLayout, value: jsonStr);
  }

  Future<Map<String, dynamic>?> getCachedLayout() async {
    final jsonStr = await _storage.read(key: _keyCachedLayout);
    if (jsonStr == null) return null;
    try {
      return jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}
