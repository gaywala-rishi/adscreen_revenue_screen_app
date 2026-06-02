import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const String _keyScreenId = 'screen_id';
  static const String _keyScreenToken = 'screen_token';

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
  }

  Future<bool> hasCredentials() async {
    final id = await getScreenId();
    final token = await getScreenToken();
    return id != null && token != null;
  }
}
