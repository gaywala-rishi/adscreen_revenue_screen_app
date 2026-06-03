import 'package:flutter/foundation.dart' show debugPrint;
import 'package:dio/dio.dart';
import 'mock_api_interceptor.dart';
import '../services/secure_storage_service.dart';

class DioClient {
  late Dio _dio;

  // Environment-based toggle to switch between mock and live backend APIs (defaulting to false to prevent silent mock pairings)
  static const bool useMock = bool.fromEnvironment('USE_MOCK', defaultValue: false);

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

    debugPrint('----------------------------------------------------');
    debugPrint('[DioClient] Initializing...');
    debugPrint('[DioClient] BACKEND_URL: $activeBaseUrl');
    debugPrint('[DioClient] USE_MOCK: $useMock');
    debugPrint('----------------------------------------------------');

    // Conditionally load mock interceptor for offline developer workflows
    if (useMock) {
      debugPrint('[DioClient] WARNING: Mock API Interceptor is ENABLED. Requests will not hit the real backend.');
      _dio.interceptors.add(MockApiInterceptor());
    } else {
      debugPrint('[DioClient] Mock API Interceptor is DISABLED. Contacting real backend.');
    }
    
    // Log interceptor for debugging API cycles
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) => debugPrint('[DioClient Network Log] $object'),
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

      debugPrint('[AuthInterceptor] Request: ${options.method} ${options.baseUrl}${options.path}');

      if (token != null) {
        options.headers['x-screen-token'] = token;
        options.headers['Authorization'] = 'Bearer $token';
        final displayToken = token.length > 8 ? '...${token.substring(token.length - 8)}' : token;
        debugPrint('[AuthInterceptor] Injected authorization headers: token ending in $displayToken');
      } else {
        debugPrint('[AuthInterceptor] No screen token found in secure storage.');
      }

      if (screenId != null && options.path.contains('MOCK-ID')) {
        options.path = options.path.replaceAll('MOCK-ID', screenId);
        debugPrint('[AuthInterceptor] Rewrote request path: replaced MOCK-ID with actual screenId: $screenId');
      }
    } catch (e) {
      debugPrint('[AuthInterceptor] Error in intercepting request: $e');
    }

    super.onRequest(options, handler);
  }
}
