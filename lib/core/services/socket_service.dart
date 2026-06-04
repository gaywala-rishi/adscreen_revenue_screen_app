import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../network/dio_client.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  io.Socket? _socket;

  // Check if socket client is connected
  bool get isConnected => _socket?.connected ?? false;

  // Dynamic listeners for quick action callbacks
  Function()? _onSyncCommand;
  Function()? _onRebootCommand;

  // Initialize pairing WebSocket (unauthenticated session)
  void initPairingSocket({
    required String serialNumber,
    required Function(String screenId, String token) onPaired,
  }) {
    _cleanup();

    // Derive WebSocket URL from REST base URL (e.g. http://192.168.1.79:3000/api/v1 -> http://192.168.1.79:3000)
    final String baseUrl = DioClient.activeBaseUrl.replaceAll('/api/v1', '');
    debugPrint('[SocketService] Connecting pairing socket to $baseUrl...');

    final options = io.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build();
    options['forceNew'] = true;

    _socket = io.io(baseUrl, options);

    _socket!.onConnect((_) {
      debugPrint('[SocketService] Connected. Emitting join:pairing for device $serialNumber');
      _socket!.emit('join:pairing', {'serialNumber': serialNumber});
    });

    _socket!.on('screen:paired', (data) {
      debugPrint('[SocketService] Received screen:paired event: $data');
      if (data is Map) {
        final screenId = data['screenId']?.toString();
        final token = data['screenToken']?.toString();
        if (screenId != null && token != null) {
          onPaired(screenId, token);
        }
      }
    });

    _socket!.onDisconnect((_) {
      debugPrint('[SocketService] Pairing socket disconnected');
    });

    _socket!.connect();
  }

  // Initialize telemetry & command WebSocket (authenticated session)
  void initAuthenticatedSocket({
    required String token,
    Function()? onSyncCommand,
    Function()? onRebootCommand,
  }) {
    _cleanup();

    _onSyncCommand = onSyncCommand;
    _onRebootCommand = onRebootCommand;

    final String baseUrl = DioClient.activeBaseUrl.replaceAll('/api/v1', '');
    debugPrint('[SocketService] Connecting authenticated socket to $baseUrl...');

    final options = io.OptionBuilder()
        .setTransports(['websocket'])
        .setAuth({'token': token})
        .setQuery({'token': token}) // Query fallback to ensure compatibility
        .disableAutoConnect()
        .build();
    options['forceNew'] = true;

    _socket = io.io(baseUrl, options);

    _socket!.onConnect((_) {
      debugPrint('[SocketService] Authenticated socket connected.');
    });

    // Handle Quick Action: Ping
    _socket!.on('action:ping', (data) {
      debugPrint('[SocketService] Received action:ping command: $data');
      if (data is Map) {
        final timestampStr = data['timestamp']?.toString();
        if (timestampStr != null) {
          final reqTime = DateTime.tryParse(timestampStr);
          final latencyMs = reqTime != null 
              ? DateTime.now().difference(reqTime).inMilliseconds 
              : 0;

          // Respond back instantly with latency and diagnostics stats
          _socket!.emit('action:ping:response', {
            'timestamp': timestampStr,
            'latency': latencyMs,
            'diagnostics': {
              'platform': 'android',
              'timestamp': DateTime.now().toIso8601String(),
            }
          });
          debugPrint('[SocketService] Dispatched action:ping:response to server.');
        }
      }
    });

    // Handle Quick Action: Sync Content
    _socket!.on('action:sync', (_) {
      debugPrint('[SocketService] Received action:sync command');
      if (_onSyncCommand != null) {
        _onSyncCommand!();
      }
    });

    // Handle Quick Action: Reboot
    _socket!.on('action:reboot', (_) {
      debugPrint('[SocketService] Received action:reboot command');
      if (_onRebootCommand != null) {
        _onRebootCommand!();
      }
    });

    _socket!.onDisconnect((_) {
      debugPrint('[SocketService] Authenticated socket disconnected');
    });

    _socket!.connect();
  }

  // Stream telemetry logs over WebSocket
  void emitTelemetry(Map<String, dynamic> vitals) {
    if (_socket != null && _socket!.connected) {
      debugPrint('[SocketService] Streaming telemetry: $vitals');
      _socket!.emit('screen:telemetry', vitals);
    } else {
      debugPrint('[SocketService] Telemetry skipped: socket client is disconnected');
    }
  }

  // Close and cleanup socket connections
  void dispose() {
    _cleanup();
  }

  void _cleanup() {
    if (_socket != null) {
      _socket!.clearListeners();
      _socket!.disconnect();
      _socket!.close();
      _socket = null;
      _onSyncCommand = null;
      _onRebootCommand = null;
      debugPrint('[SocketService] Disconnected and cleaned up.');
    }
  }
}
