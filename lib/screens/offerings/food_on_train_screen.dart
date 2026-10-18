import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_assets.dart';

/// Screen 13: Food On Train Screen
///
/// Features a solid blue header with Orders button, hero food banner image,
/// floating PNR search card, and clean aesthetic layout.
class FoodOnTrainScreen extends StatefulWidget {
  const FoodOnTrainScreen({super.key});

  @override
  State<FoodOnTrainScreen> createState() => _FoodOnTrainScreenState();
}

class _FoodOnTrainScreenState extends State<FoodOnTrainScreen> {
  final TextEditingController _pnrController = TextEditingController();

  @override
  void dispose() {
    _pnrController.dispose();
    super.dispose();
  }

  void _onSearch() {
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Searching meals for PNR: $pnr'),
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
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF0066FF),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Column(
          children: [
            // 1. Custom Solid Blue AppBar
            _buildCustomAppBar(context),

            // 2. Main Content Area (Banner with Floating PNR Card + Clean Bottom)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildHeroBannerWithFloatingCard(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Top Custom AppBar (Height 64, Solid Blue #0066FF)
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
                      color: Colors.white.withValues(alpha: 0.7),
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

              const SizedBox(width: 16),

              // Title
              const Expanded(
                child: Text(
                  'Food On Train',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
              ),

              // Right Outlined "Orders" Pill Button
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No previous food orders found'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white,
                      width: 1.2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Orders',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 2. Hero Image Banner with Soft Gradient & Floating PNR Card
  Widget _buildHeroBannerWithFloatingCard() {
    return SizedBox(
      height: 440,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // A. Hero Banner Image
          AppAssets.safeImage(
            AppAssets.foodBackgroundImage,
            fit: BoxFit.cover,
            fallbackIcon: Icons.restaurant,
            fallbackIconSize: 64,
            fallbackIconColor: Colors.grey.shade400,
          ),

          // B. Soft Gradient Overlay to blend with bottom background
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 140,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFFF8F9FA).withValues(alpha: 0.5),
                    const Color(0xFFF8F9FA),
                  ],
                  stops: const [0.0, 0.65, 1.0],
                ),
              ),
            ),
          ),

          // C. Floating PNR Number Input Card
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              height: 56,
              padding: const EdgeInsets.only(left: 16, right: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // PNR TextField
                  Expanded(
                    child: TextField(
                      controller: _pnrController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D234A),
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'PNR Number',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF8A94A6),
                        ),
                      ),
                      onSubmitted: (_) => _onSearch(),
                    ),
                  ),

                  // Blue Search Action Button
                  InkWell(
                    onTap: _onSearch,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 44,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0066FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
