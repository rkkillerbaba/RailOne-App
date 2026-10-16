import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Screen 10: PNR Status Screen
///
/// Minimal clean screen with a PNR number input field and "Show Status" button.
class PnrStatusScreen extends StatefulWidget {
  const PnrStatusScreen({super.key});

  @override
  State<PnrStatusScreen> createState() => _PnrStatusScreenState();
}

class _PnrStatusScreenState extends State<PnrStatusScreen> {
  final TextEditingController _pnrController = TextEditingController();

  @override
  void dispose() {
    _pnrController.dispose();
    super.dispose();
  }

  void _onShowStatus() {
    final pnr = _pnrController.text.trim();
    if (pnr.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit PNR number'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    // TODO: Fetch PNR status
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fetching status for PNR: $pnr'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Header Bar ──────────────────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    // Left spacer keeps title centered
                    const SizedBox(width: 40, height: 40),

                    // Center Title
                    const Expanded(
                      child: Text(
                        'PNR Status',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0D234A),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),

                    // Right Close Button
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFBCE0FD),
                            width: 1.5,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            color: Color(0xFF0066FF),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ── PNR Input Row ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // PNR TextField Container
                    Expanded(
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF90CAF9),
                            width: 1.2,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          controller: _pnrController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0D234A),
                          ),
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                            hintText: 'Enter PNR Number',
                            hintStyle: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF8A94A6),
                            ),
                          ),
                          onSubmitted: (_) => _onShowStatus(),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // "Show Status" Button
                    InkWell(
                      onTap: _onShowStatus,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 125,
                        height: 54,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0066FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Show Status',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
