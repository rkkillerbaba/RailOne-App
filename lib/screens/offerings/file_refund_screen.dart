import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Screen 14: Tickets Eligible For Refund (File Refund) Screen
///
/// Clean screen displaying tickets eligible for refund or an empty state message.
class FileRefundScreen extends StatelessWidget {
  const FileRefundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        body: Column(
          children: [
            // 1. Top Custom Solid Blue AppBar
            _buildCustomAppBar(context),

            // 2. Center Empty State Text
            const Expanded(
              child: Center(
                child: Text(
                  'No Tickets Eligible For Refund',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF2B2B2B),
                    letterSpacing: -0.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Top Custom AppBar (Height 64, Solid Blue #0066FF)
  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      color: const Color(0xFF0066FF),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Circular Outlined Back Button
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(19),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 1.2,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Left-aligned Title
              const Expanded(
                child: Text(
                  'Tickets Eligible For Refund',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
