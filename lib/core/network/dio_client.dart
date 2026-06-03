import 'package:flutter/foundation.dart' show debugPrint;
import 'package:dio/dio.dart';
import 'mock_api_interceptor.dart';
import '../services/secure_storage_service.dart';

class DioClient {
  late Dio _dio;

  // Environment-based toggle to switch between mock and live backend APIs
  static const bool useMock = bool.fromEnvironment('USE_MOCK', defaultValue: true);

  // Environment-based backend URL configuration (configured dynamically via env.json)
  static const String activeBaseUrl = String.fromEnvironment('BACKEND_URL', defaultValue: 'https://api.adscreen.in/api/v1');

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: activeBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    // Dynamic authorization and screen ID interceptor
    _dio.interceptors.add(AuthInterceptor());

    // Conditionally load mock interceptor for offline developer workflows
    if (useMock) {
      _dio.interceptors.add(MockApiInterceptor());
    }
    
    // Log interceptor for debugging API cycles
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Dio get dio => _dio;
}

class AuthInterceptor extends Interceptor {
  final _secureStorage = SecureStorageService();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await _secureStorage.getScreenToken();
      final screenId = await _secureStorage.getScreenId();

      if (token != null) {
        options.headers['x-screen-token'] = token;
        options.headers['Authorization'] = 'Bearer $token';
      }

      if (screenId != null && options.path.contains('MOCK-ID')) {
        options.path = options.path.replaceAll('MOCK-ID', screenId);
      }
    } catch (e) {
      // Log error internally but do not block request
      debugPrint('AuthInterceptor error: $e');
    }

    super.onRequest(options, handler);
  }
}
