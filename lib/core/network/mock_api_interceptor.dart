import 'package:dio/dio.dart';

class MockApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final path = options.path;

    if (path.contains('/android/screens/init')) {
      final requestData = options.data;
      if (requestData is Map && requestData.containsKey('provisionToken')) {
        final String token = requestData['provisionToken'] ?? '';
        final String venueId = requestData['venueId'] ?? '';

        // If manual token flow is triggered, simulate validations
        if (token.isEmpty || venueId.isEmpty) {
          return handler.reject(
            DioException(
              requestOptions: options,
              response: Response(
                requestOptions: options,
                statusCode: 400,
                data: {
                  'success': false,
                  'message': 'Both Provisioning Token and Venue ID are required.',
                },
              ),
              type: DioExceptionType.badResponse,
            ),
          );
        }

        // Simulate invalid/expired token behavior for developer tests
        if (token.toUpperCase() == 'EXPIRED') {
          return handler.reject(
            DioException(
              requestOptions: options,
              response: Response(
                requestOptions: options,
                statusCode: 403,
                data: {
                  'success': false,
                  'message': 'Provisioning token has expired.',
                },
              ),
              type: DioExceptionType.badResponse,
            ),
          );
        } else if (token.toUpperCase() == 'INVALID') {
          return handler.reject(
            DioException(
              requestOptions: options,
              response: Response(
                requestOptions: options,
                statusCode: 403,
                data: {
                  'success': false,
                  'message': 'Invalid provisioning token.',
                },
              ),
              type: DioExceptionType.badResponse,
            ),
          );
        }

        // Successful manual pairing response
        return handler.resolve(
          Response(
            requestOptions: options,
            data: {
              'success': true,
              'screenId': 'SCREEN-MANUAL-999',
              'screenToken': 'mock-jwt-manual-token-abc-123',
              'pairingCode': 'MANUAL',
            },
            statusCode: 200,
          ),
        );
      }

      // Default automatic pairing PIN code response (original behavior)
      return handler.resolve(
        Response(
          requestOptions: options,
          data: {
            'screenId': 'SCREEN-12345',
            'screenToken': 'mock-jwt-token-xyz-789',
            'pairingCode': 'A794CZ',
          },
          statusCode: 200,
        ),
      );
    }

    if (path.contains('/android/screens/') && path.contains('/content')) {
      return handler.resolve(
        Response(
          requestOptions: options,
          data: {
            'layout': {
              'id': 'L-001',
              'name': 'Standard 5-Zone Landscape',
              'regions': [
                {
                  'id': 'AD_1',
                  'x': 0.2, 'y': 0.15, 'width': 0.6, 'height': 0.7,
                  'type': 'main'
                },
                {
                  'id': 'AD_2',
                  'x': 0.0, 'y': 0.0, 'width': 0.2, 'height': 1.0,
                  'type': 'sidebar'
                },
                {
                  'id': 'AD_3',
                  'x': 0.2, 'y': 0.0, 'width': 0.6, 'height': 0.15,
                  'type': 'header'
                },
                {
                  'id': 'AD_4',
                  'x': 0.2, 'y': 0.85, 'width': 0.6, 'height': 0.15,
                  'type': 'footer'
                },
                {
                  'id': 'AD_5',
                  'x': 0.8, 'y': 0.0, 'width': 0.2, 'height': 1.0,
                  'type': 'sidebar'
                }
              ]
            },
            'playlists': {
              'AD_1': [
                {'id': 'C-101', 'url': 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4', 'type': 'video', 'duration': 15},
                {'id': 'C-102', 'url': 'https://picsum.photos/800/600', 'type': 'image', 'duration': 10}
              ],
              'AD_2': [
                {'id': 'C-201', 'url': 'https://picsum.photos/200/1000', 'type': 'image', 'duration': 30}
              ]
            }
          },
          statusCode: 200,
        ),
      );
    }

    if (path.contains('/heartbeat') || path.contains('/metrics')) {
      return handler.resolve(
        Response(
          requestOptions: options,
          data: {'status': 'success'},
          statusCode: 200,
        ),
      );
    }

    // Default to error for unhandled mock routes
    return handler.reject(
      DioException(
        requestOptions: options,
        error: 'Mock route not implemented: ${options.path}',
        type: DioExceptionType.badResponse,
      ),
    );
  }
}
