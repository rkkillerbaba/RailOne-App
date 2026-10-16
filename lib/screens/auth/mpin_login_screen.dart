import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_assets.dart';
import '../../core/app_state.dart';
import '../../core/widgets/railone_loader_overlay.dart';
import '../main_nav_screen.dart';

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

  bool _isLoading = true; // Initial 1.5s loading effect matching screenshot
  Timer? _initialLoadTimer;
  Timer? _loginTimer;

  @override
  void initState() {
    super.initState();

    // Initial slow-internet / biometric verification loading state for 1.5 seconds
    _initialLoadTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _isLoading = false);
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

  void _handleLogin() {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    _loginTimer = Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
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
    });
  }

  void _onPinChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // 6th digit entered
        _focusNodes[index].unfocus();
        _handleLogin();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
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
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Opening Reset mPIN...'),
                                duration: Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
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
                              onTap: _handleLogin,
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
                              onTap: _handleLogin,
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Switching user account...'),
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
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
    return RichText(
      text: const TextSpan(
        text: 'Rail',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w400,
          color: Color(0xFF4A4A4A),
          letterSpacing: -0.5,
        ),
        children: [
          TextSpan(
            text: 'One',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color(0xFF4A4A4A),
            ),
          ),
        ],
      ),
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
