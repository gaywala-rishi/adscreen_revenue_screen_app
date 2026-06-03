import 'dart:async';
import 'package:flutter/material.dart';
import 'control_console_screen.dart';
import '../../core/services/secure_storage_service.dart';
import '../../core/services/device_info_service.dart';
import '../../core/network/dio_client.dart';
import '../../core/services/socket_service.dart';

class ProvisioningScreen extends StatefulWidget {
  const ProvisioningScreen({super.key});

  @override
  State<ProvisioningScreen> createState() => _ProvisioningScreenState();
}

class _ProvisioningScreenState extends State<ProvisioningScreen> {
  final _dioClient = DioClient();
  final _secureStorage = SecureStorageService();
  final _deviceInfo = DeviceInfoService();
  final _socketService = SocketService();

  String? _pairingCode;
  String? _serialNumber;
  bool _isLoading = true;
  String? _error;
  DateTime? _expiresAt;
  Duration _timeRemaining = Duration.zero;
  Timer? _countdownTimer;

  // Enterprise manual provisioning state parameters
  bool _isManualMode = false;
  final _tokenController = TextEditingController();
  final _venueIdController = TextEditingController();

  // Background PIN pairing timer
  Timer? _pairingTimer;

  @override
  void initState() {
    super.initState();
    _initProvisioning();
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _venueIdController.dispose();
    _pairingTimer?.cancel();
    _countdownTimer?.cancel();
    _socketService.dispose();
    super.dispose();
  }

  Future<void> _initProvisioning() async {
    debugPrint('[ProvisioningScreen] Starting screen registration init...');
    setState(() {
      _isLoading = true;
      _error = null;
    });

    _pairingTimer?.cancel();
    _countdownTimer?.cancel();

    try {
      _serialNumber = await _deviceInfo.getSerialNumber();
      debugPrint('[ProvisioningScreen] Device serial number: $_serialNumber');
      
      final response = await _dioClient.dio.post(
        '/android/screens/init',
        data: {'serialNumber': _serialNumber},
      );

      debugPrint('[ProvisioningScreen] init response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final Map<String, dynamic> bodyData = responseData.containsKey('data') 
            ? (responseData['data'] as Map<String, dynamic>? ?? {}) 
            : responseData;

        final bool isPaired = bodyData['paired'] == true || 
            (bodyData.containsKey('screenToken') && bodyData['screenToken'] != null && bodyData['screenToken'].toString().isNotEmpty);

        debugPrint('[ProvisioningScreen] Screen pairing status from backend: isPaired=$isPaired');

        if (isPaired) {
          final screenId = bodyData['screenId'].toString();
          final screenToken = bodyData['screenToken'].toString();
          debugPrint('[ProvisioningScreen] Screen is ALREADY paired. Saving credentials - ID: $screenId');
          
          setState(() {
            _isLoading = false;
          });
          
          await _secureStorage.saveScreenCredentials(screenId, screenToken);

          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ControlConsoleScreen()),
            );
          }
        } else {
          final pCode = bodyData['pairingCode']?.toString() ?? '--- ---';
          final expiresAtStr = bodyData['pairingCodeExpiresAt']?.toString();
          final expiresAt = expiresAtStr != null ? DateTime.tryParse(expiresAtStr) : null;

          debugPrint('[ProvisioningScreen] Screen is not paired. Setting PIN: $pCode (expires: $expiresAtStr) and starting polling loop.');
          setState(() {
            _pairingCode = pCode;
            _expiresAt = expiresAt;
            _isLoading = false;
            _updateTimeRemaining();
          });
          
          _startCountdownTimer();
          _startPairingPoll();
        }
      } else {
        debugPrint('[ProvisioningScreen] Registration failed: non-200 status code');
        setState(() {
          _error = 'Failed to initialize screen registration';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[ProvisioningScreen] Registration error: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    if (_expiresAt == null) return;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      _updateTimeRemaining();
    });
  }

  void _updateTimeRemaining() {
    if (_expiresAt == null) {
      setState(() {
        _timeRemaining = Duration.zero;
      });
      return;
    }

    final now = DateTime.now();
    final difference = _expiresAt!.difference(now);

    if (difference.isNegative || difference == Duration.zero) {
      _countdownTimer?.cancel();
      setState(() {
        _timeRemaining = Duration.zero;
        _pairingCode = null; // Mark code as expired
      });
      // Automatically refresh the code
      debugPrint('[ProvisioningScreen] Pairing PIN expired. Refreshing code...');
      _initProvisioning();
    } else {
      setState(() {
        _timeRemaining = difference;
      });
    }
  }

  void _startPairingPoll() {
    debugPrint('[ProvisioningScreen] Subscribing to pairing WebSocket instead of HTTP polling...');
    if (_serialNumber == null) return;

    _socketService.initPairingSocket(
      serialNumber: _serialNumber!,
      onPaired: (screenId, token) async {
        debugPrint('[ProvisioningScreen] Success! Pairing completed via WebSocket.');
        await _secureStorage.saveScreenCredentials(screenId, token);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Screen successfully paired and activated!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const ControlConsoleScreen()),
          );
        }
      },
    );
  }

  Future<void> _registerManually() async {
    final token = _tokenController.text.trim();
    final venueId = _venueIdController.text.trim();

    if (token.isEmpty || venueId.isEmpty) {
      setState(() {
        _error = 'Both Provisioning Token and Venue ID are required.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      _serialNumber = await _deviceInfo.getSerialNumber();
      
      final response = await _dioClient.dio.post(
        '/android/screens/init',
        data: {
          'serialNumber': _serialNumber,
          'provisionToken': token,
          'venueId': venueId,
          'resolution': '1920x1080',
          'appVersion': '1.0.0'
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        await _secureStorage.saveScreenCredentials(
          data['screenId'] ?? 'SCREEN-MANUAL-999',
          data['screenToken'] ?? 'mock-jwt-manual-token-abc-123',
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Screen successfully registered and authorized!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const ControlConsoleScreen()),
          );
        }
      } else {
        setState(() {
          _error = 'Registration rejected by backend server.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString().contains('403') 
            ? 'Access Denied: Invalid or expired provisioning credentials.'
            : 'Network Error: ${e.toString().split('\n').first}';
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
              : (_error != null && !_isManualMode)
                  ? _buildErrorView()
                  : _buildUnregisteredView(),
        ),
      ),
    );
  }

  Widget _buildUnregisteredView() {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.size.width > mediaQuery.size.height;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: isLandscape ? _buildLandscapeLayout() : _buildPortraitLayout(),
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Column: Branding, info, and action buttons
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _isManualMode ? Icons.vpn_key_outlined : Icons.lock_outline, 
                    color: _isManualMode ? Colors.cyanAccent : Colors.blueAccent, 
                    size: 36,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _isManualMode ? 'Enterprise Association' : 'AdScreen Unregistered',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _isManualMode
                    ? 'Input the verification tokens provided from your administrative dashboard to register this device.'
                    : 'Pair this display to your AdScreen administrative cloud to start fullscreen broadcasting.',
                style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 20),
              // Action buttons column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_isManualMode) ...[
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isManualMode = true;
                          _error = null;
                        });
                      },
                      icon: const Icon(Icons.settings, color: Colors.cyanAccent, size: 14),
                      label: const Text(
                        'Switch to Enterprise Provisioning',
                        style: TextStyle(color: Colors.cyanAccent, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.cyanAccent.withValues(alpha: 0.05),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  TextButton.icon(
                    onPressed: () {
                       Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const ControlConsoleScreen()),
                      );
                    },
                    icon: const Icon(Icons.close, color: Colors.white54, size: 14),
                    label: const Text(
                      'Exit to Dashboard',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black26,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 32),
        // Right Column: Form or PIN Box
        Expanded(
          flex: 6,
          child: Center(
            child: _isManualMode ? _buildManualForm() : _buildPinBox(),
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          _isManualMode ? Icons.vpn_key_outlined : Icons.lock_outline, 
          color: _isManualMode ? Colors.cyanAccent : Colors.blueAccent, 
          size: 40,
        ),
        const SizedBox(height: 12),
        Text(
          _isManualMode ? 'Enterprise Association' : 'AdScreen Board Unregistered',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            _isManualMode
                ? 'Input the verification tokens provided from your administrative dashboard to register this device.'
                : 'Pair this display to your AdScreen administrative cloud to start fullscreen broadcasting.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.3),
          ),
        ),
        const SizedBox(height: 16),
        _isManualMode ? _buildManualForm() : _buildPinBox(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isManualMode) ...[
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _isManualMode = true;
                    _error = null;
                  });
                },
                icon: const Icon(Icons.settings, color: Colors.cyanAccent, size: 14),
                label: const Text(
                  'Switch to Enterprise Provisioning',
                  style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.w600, fontSize: 12),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.cyanAccent.withValues(alpha: 0.05),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
              const SizedBox(width: 12),
            ],
            TextButton.icon(
              onPressed: () {
                 Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ControlConsoleScreen()),
                );
              },
              icon: const Icon(Icons.close, color: Colors.white54, size: 14),
              label: const Text(
                'Exit to Dashboard',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.black26,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildManualForm() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withValues(alpha: 0.05),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              Icon(Icons.vpn_key_outlined, color: Colors.cyanAccent, size: 16),
              SizedBox(width: 8),
              Text(
                'ENTERPRISE PROVISIONING',
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: _tokenController,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace'),
            decoration: InputDecoration(
              labelText: 'Provisioning Token',
              labelStyle: const TextStyle(color: Colors.cyanAccent, fontSize: 11),
              hintText: 'Enter token...',
              hintStyle: const TextStyle(color: Colors.white30, fontSize: 11),
              filled: true,
              fillColor: Colors.black26,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.cyanAccent, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _venueIdController,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace'),
            decoration: InputDecoration(
              labelText: 'Target Venue ID',
              labelStyle: const TextStyle(color: Colors.cyanAccent, fontSize: 11),
              hintText: 'Enter Venue UUID...',
              hintStyle: const TextStyle(color: Colors.white30, fontSize: 11),
              filled: true,
              fillColor: Colors.black26,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.cyanAccent, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _isManualMode = false;
                      _error = null;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Back', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: _registerManually,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 3,
                    shadowColor: Colors.cyanAccent.withValues(alpha: 0.2),
                  ),
                  child: const Text('REGISTER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPinBox() {
    final minutes = _timeRemaining.inMinutes.toString().padLeft(2, '0');
    final seconds = (_timeRemaining.inSeconds % 60).toString().padLeft(2, '0');
    final bool hasExpired = _timeRemaining.isNegative || _timeRemaining == Duration.zero;

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasExpired 
              ? Colors.redAccent.withValues(alpha: 0.5) 
              : Colors.blueAccent.withValues(alpha: 0.3)
        ),
        boxShadow: [
          BoxShadow(
            color: hasExpired
                ? Colors.redAccent.withValues(alpha: 0.05)
                : Colors.blueAccent.withValues(alpha: 0.05),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                hasExpired ? Icons.warning_amber_rounded : Icons.monitor,
                color: hasExpired ? Colors.redAccent : Colors.blueAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                hasExpired ? 'PAIRING PIN EXPIRED' : 'PAIRING PIN CODE',
                style: TextStyle(
                  color: hasExpired ? Colors.redAccent : Colors.blueAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _pairingCode ?? '--- ---',
            style: TextStyle(
              color: hasExpired ? Colors.white30 : Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 12),
          if (!hasExpired && _pairingCode != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_outlined, color: Colors.grey, size: 12),
                  const SizedBox(width: 6),
                  Text(
                    'Expires in $minutes:$seconds',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  'Generating fresh code...',
                  style: TextStyle(color: Colors.redAccent, fontSize: 11),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 48),
        const SizedBox(height: 16),
        Text(
          'Error: $_error',
          style: const TextStyle(color: Colors.white, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _initProvisioning,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Retry'),
        ),
      ],
    );
  }
}
