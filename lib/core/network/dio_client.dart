import 'package:dio/dio.dart';
import 'mock_api_interceptor.dart';

class DioClient {
  late Dio _dio;

  // Static toggle to easily switch between mock environment and live backend APIs
  static bool useMock = true;

  // Custom base URL configuration (points to Nest/Express backend versioned endpoints)
  static String activeBaseUrl = 'https://api.adscreen.in/api/v1';

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
