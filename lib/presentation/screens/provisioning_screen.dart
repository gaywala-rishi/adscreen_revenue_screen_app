import 'package:flutter/material.dart';
import 'control_console_screen.dart';
import '../../core/services/secure_storage_service.dart';
import '../../core/services/device_info_service.dart';
import '../../core/network/dio_client.dart';

class ProvisioningScreen extends StatefulWidget {
  const ProvisioningScreen({super.key});

  @override
  State<ProvisioningScreen> createState() => _ProvisioningScreenState();
}

class _ProvisioningScreenState extends State<ProvisioningScreen> {
  final _dioClient = DioClient();
  final _secureStorage = SecureStorageService();
  final _deviceInfo = DeviceInfoService();

  String? _pairingCode;
  String? _serialNumber;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initProvisioning();
  }

  Future<void> _initProvisioning() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      _serialNumber = await _deviceInfo.getSerialNumber();
      
      final response = await _dioClient.dio.post(
        '/android/screens/init',
        data: {'serialNumber': _serialNumber},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          _pairingCode = data['pairingCode'] ?? '482-991'; // Mock fallback to match design
          _isLoading = false;
        });

        await _secureStorage.saveScreenCredentials(
          data['screenId'],
          data['screenToken'],
        );
      } else {
        setState(() {
          _error = 'Failed to get pairing code';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020810),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [Color(0xFF0A192F), Color(0xFF020810)],
          ),
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.blueAccent)
              : _error != null
                  ? _buildErrorView()
                  : _buildUnregisteredView(),
        ),
      ),
    );
  }

  Widget _buildUnregisteredView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock_outline, color: Colors.blueAccent, size: 80),
        const SizedBox(height: 24),
        const Text(
          'AdScreen Board Unregistered',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Pair this display to your AdScreen administrative cloud to start fullscreen broadcasting.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16, height: 1.5),
          ),
        ),
        const SizedBox(height: 48),
        _buildPinBox(),
        const SizedBox(height: 60),
        TextButton.icon(
          onPressed: () {
             Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ControlConsoleScreen()),
            );
          },
          icon: const Icon(Icons.close, color: Colors.white54, size: 18),
          label: const Text(
            'Exit Immersive Playout (Back to Dashboard)',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.black26,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildPinBox() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monitor, color: Colors.white, size: 60),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MANUAL REGISTRATION PIN',
                style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                _pairingCode ?? '--- ---',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 60),
        const SizedBox(height: 20),
        Text(
          'Error: $_error',
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _initProvisioning,
          child: const Text('Retry'),
        ),
      ],
    );
  }
}
