import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/app_colors.dart';
import 'core/app_state.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.instance.initPrefs();

  // Set system UI overlay style to match the clean white status bar design
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFF0066FF),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const RailOneApp());
}

class RailOneApp extends StatelessWidget {
  const RailOneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RailOne',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'NotoSans',
        scaffoldBackgroundColor: AppColors.screenBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          primary: AppColors.primaryBlue,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.headingNavy,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Color(0xFF0066FF),
            systemNavigationBarIconBrightness: Brightness.light,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
