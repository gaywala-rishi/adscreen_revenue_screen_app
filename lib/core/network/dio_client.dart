import 'package:dio/dio.dart';
import 'mock_api_interceptor.dart';

class DioClient {
  late Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.adscreen.in', // Real base URL
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    // Use MockInterceptor for development
    _dio.interceptors.add(MockApiInterceptor());
    
    // Log interceptor for debugging (optional)
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Dio get dio => _dio;
}
