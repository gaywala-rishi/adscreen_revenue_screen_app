import 'package:dio/dio.dart';
import 'mock_api_interceptor.dart';

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
