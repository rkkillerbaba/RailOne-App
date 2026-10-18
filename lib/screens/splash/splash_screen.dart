import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../../core/app_state.dart';
import '../auth/mpin_login_screen.dart';
import '../auth/new_user_registration_screen.dart';

/// Screen 8: Animated Splash Screen
///
/// Features a smooth zoom-out scale animation from 1.85 down to 1.0,
/// settling on the crisp RailOne logo before transitioning to [MainNavScreen].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    // 1. Setup zoom-in to zoom-out animation (1.85 -> 1.0 over 1200ms)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 1.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // 2. Start the scale animation immediately
    _controller.forward();

    // 3. Schedule auto-navigation to MainNavScreen after 2200ms
    _navigationTimer = Timer(const Duration(milliseconds: 2200), _navigateToHome);
  }

  void _navigateToHome() {
    if (!mounted) return;

    final isRegistered = AppState.instance.isUserRegistered;
    final Widget destination = isRegistered
        ? const MpinLoginScreen()
        : const NewUserRegistrationScreen();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
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
        body: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: AppAssets.safeImage(
              AppAssets.splashLogo,
              width: 175,
              fit: BoxFit.contain,
              fallbackIcon: Icons.train_rounded,
              fallbackIconSize: 64,
              fallbackIconColor: AppColors.primaryBlue,
              errorBuilder: (context, error, stackTrace) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.train_rounded,
                    size: 68,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: const TextSpan(
                      text: 'Rail',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBlue,
                      ),
                      children: [
                        TextSpan(
                          text: 'One',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFF16522),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
