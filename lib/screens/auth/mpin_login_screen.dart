import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import '../../core/app_assets.dart';
import '../../core/app_state.dart';
import '../../core/widgets/railone_loader_overlay.dart';
import '../main_nav_screen.dart';
import 'new_user_registration_screen.dart';

/// Screen 16: Login using mPIN & Biometric Screen
///
/// Features 6-digit mPIN boxes with auto-shift, biometric login (Face ID & Fingerprint),
/// reset options, and full-screen rotating loader overlay.
class MpinLoginScreen extends StatefulWidget {
  const MpinLoginScreen({super.key});

  @override
  State<MpinLoginScreen> createState() => _MpinLoginScreenState();
}

class _MpinLoginScreenState extends State<MpinLoginScreen> {
  final List<TextEditingController> _pinControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _isLoading = true;
  String? _errorMessage;
  Timer? _initialLoadTimer;
  Timer? _loginTimer;

  @override
  void initState() {
    super.initState();
    // Show brief loader then auto-trigger biometric if enabled
    _initialLoadTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => _isLoading = false);
        if (AppState.instance.isBiometricEnabled) {
          _handleBiometricAuth();
        }
      }
    });
  }

  @override
  void dispose() {
    _initialLoadTimer?.cancel();
    _loginTimer?.cancel();
    for (final c in _pinControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  /// Authenticate using device biometric (fingerprint / face)
  Future<void> _handleBiometricAuth() async {
    if (_isLoading) return;
    try {
      final bool canCheck = await _localAuth.canCheckBiometrics;
      if (!canCheck) {
        if (mounted) {
          setState(() => _errorMessage = 'Biometric not available on this device.');
        }
        return;
      }
      final bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to login to RailOne',
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
      if (authenticated && mounted) {
        _navigateToHome();
      }
    } catch (_) {
      // Biometric failed or cancelled — let user enter MPIN manually
    }
  }

  /// Verify MPIN and navigate on success
  void _handleLogin() {
    if (_isLoading) return;
    final pin = _pinControllers.map((c) => c.text).join();
    if (pin.length < 6) {
      setState(() => _errorMessage = 'Please enter all 6 digits.');
      return;
    }
    if (!AppState.instance.verifyMpin(pin)) {
      setState(() {
        _errorMessage = 'Incorrect mPIN. Please try again.';
        for (final c in _pinControllers) {
          c.clear();
        }
      });
      _focusNodes[0].requestFocus();
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    _loginTimer = Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      _navigateToHome();
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainNavScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _onPinChanged(int index, String value) {
    setState(() => _errorMessage = null);
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _handleLogin();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  void _showResetMpinModal(BuildContext context) {
    final pinController = TextEditingController();
    final confirmPinController = TextEditingController();
    String? modalError;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Set / Reset mPIN',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF142459),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(modalContext),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter a 4-digit or 6-digit MPIN to secure your RailOne app.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: pinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      labelText: 'New mPIN',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: confirmPinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      labelText: 'Confirm mPIN',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  if (modalError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      modalError!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () {
                      final p1 = pinController.text.trim();
                      final p2 = confirmPinController.text.trim();
                      if (p1.length < 4) {
                        setModalState(() => modalError = 'mPIN must be at least 4 digits.');
                        return;
                      }
                      if (p1 != p2) {
                        setModalState(() => modalError = 'mPINs do not match.');
                        return;
                      }
                      AppState.instance.setMpin(p1);
                      Navigator.pop(modalContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('mPIN updated successfully!'),
                          backgroundColor: Color(0xFF0066FF),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Save mPIN', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF0066FF),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RailOneLoaderOverlay(
          isLoading: _isLoading,
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 28),

                  // 1. Top Logo: RailOne
                  _buildRailOneLogo(),

                  const SizedBox(height: 65),

                  // 2. Heading & Subtitles
                  const Text(
                    'Login using mPIN',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2B2B2B),
                      letterSpacing: -0.2,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Welcome ${AppState.instance.firstName}!',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF78909C),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Enter mPIN below',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF78909C),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 3. 6-Digit mPIN Boxes Row
                  _buildMpinBoxesRow(),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  const SizedBox(height: 16),

                  // 4. Forgot Password & Reset mPIN Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Opening Forgot Password...'),
                                duration: Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0052CC),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => _showResetMpinModal(context),
                          child: const Text(
                            'Reset mPIN?',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0052CC),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 85),

                  // 5. "Or login using biometric" Dashed Divider
                  _buildBiometricDivider(),

                  const SizedBox(height: 38),

                  // 6. Biometric Icons & Outlined "Login" Button Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left Biometric Icons
                        Row(
                          children: [
                            // Face Scan Icon
                            InkWell(
                              onTap: _handleBiometricAuth,
                              borderRadius: BorderRadius.circular(8),
                              child: AppAssets.safeImage(
                                AppAssets.faceIdIcon,
                                width: 38,
                                height: 38,
                                color: const Color(0xFF64748B),
                                fallbackIcon: Icons.face_rounded,
                                fallbackIconSize: 38,
                                fallbackIconColor: const Color(0xFF64748B),
                              ),
                            ),

                            const SizedBox(width: 14),

                            // Fingerprint Icon
                            InkWell(
                              onTap: _handleBiometricAuth,
                              borderRadius: BorderRadius.circular(8),
                              child: AppAssets.safeImage(
                                AppAssets.fingerprintIcon,
                                width: 42,
                                height: 42,
                                color: const Color(0xFF64748B),
                                fallbackIcon: Icons.fingerprint,
                                fallbackIconSize: 42,
                                fallbackIconColor: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),

                        // Right Outlined "Login" Pill Button
                        InkWell(
                          onTap: _handleLogin,
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            width: 125,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xFF0066FF),
                                width: 1.2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0066FF),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 55),

                  // 7. Bottom "Different User?" Link
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const NewUserRegistrationScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Different User?',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0052CC),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 1. Centered RailOne Logo
  Widget _buildRailOneLogo() {
    return Image.asset(
      AppAssets.railOneLogoTitle,
      height: 38,
      fit: BoxFit.contain,
    );
  }

  /// 3. 6-Digit mPIN Boxes Row
  Widget _buildMpinBoxesRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (index) {
          return Container(
            width: 48,
            height: 50,
            margin: EdgeInsets.only(
              left: index == 0 ? 0 : 4,
              right: index == 5 ? 0 : 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF90CAF9),
                width: 1.2,
              ),
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: _pinControllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              obscureText: true,
              obscuringCharacter: '•',
              maxLength: 1,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0D234A),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (val) => _onPinChanged(index, val),
            ),
          );
        }),
      ),
    );
  }

  /// 5. Biometric Dashed Divider
  Widget _buildBiometricDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          Expanded(
            child: CustomPaint(
              painter: _DashedLinePainter(),
              size: const Size(double.infinity, 1),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Or login using biometric',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF78909C),
              ),
            ),
          ),
          Expanded(
            child: CustomPaint(
              painter: _DashedLinePainter(),
              size: const Size(double.infinity, 1),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for horizontal dashed divider line
class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1.0;

    const dashWidth = 3.0;
    const dashSpace = 3.0;
    double startX = 0;
    final y = size.height / 2;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + dashWidth, y),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
