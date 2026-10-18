import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_assets.dart';
import '../../core/app_state.dart';
import '../common/select_language_screen.dart';
import '../main_nav_screen.dart';
import 'mpin_login_screen.dart';

/// Screen: New User Registration Screen
/// Matches the exact official design with RailOne header logo, login pill,
/// mobile number input capsule, social auth circles, terms, guest login,
/// and bottom rail info banner with carousel indicators.
class NewUserRegistrationScreen extends StatefulWidget {
  const NewUserRegistrationScreen({super.key});

  @override
  State<NewUserRegistrationScreen> createState() =>
      _NewUserRegistrationScreenState();
}

class _NewUserRegistrationScreenState extends State<NewUserRegistrationScreen> {
  final TextEditingController _mobileController = TextEditingController();
  bool _isPhoneValid = false;

  late final PageController _bannerController;
  int _currentBannerIndex = 0;
  Timer? _bannerTimer;

  final List<String> _bannerImages = const [
    AppAssets.firstAdd,
    AppAssets.add2,
    AppAssets.add3,
    AppAssets.add4,
    AppAssets.add5,
  ];

  @override
  void initState() {
    super.initState();
    _mobileController.addListener(_onPhoneChanged);
    _bannerController = PageController();
    _startBannerAutoScroll();
  }

  void _startBannerAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted || !_bannerController.hasClients) return;
      final nextIndex = (_currentBannerIndex + 1) % _bannerImages.length;
      _bannerController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPhoneChanged() {
    final text = _mobileController.text.trim();
    final isValid = text.length == 10;
    if (isValid != _isPhoneValid) {
      setState(() {
        _isPhoneValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _mobileController.removeListener(_onPhoneChanged);
    _mobileController.dispose();
    super.dispose();
  }

  void _handleRegisterClick() {
    final phone = _mobileController.text.trim();
    if (phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    _showRegistrationDetailsSheet(phone);
  }

  void _showRegistrationDetailsSheet(String mobileNumber) {
    final nameController = TextEditingController();
    final ageController = TextEditingController(text: '25');
    final idNumberController = TextEditingController(text: 'ZMT1234567');
    final mpinController = TextEditingController(text: '1234');
    final confirmMpinController = TextEditingController(text: '1234');
    String idType = 'Voter ID';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Complete Registration',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF142459),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Mobile Number (Readonly)
                    TextField(
                      controller: TextEditingController(text: '+91 $mobileNumber'),
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.phone),
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Full Name (Required)
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Full Name *',
                        hintText: 'Enter your name (e.g. Rishi Kumar)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Age
                    TextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Age *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // ID Type Dropdown
                    DropdownButtonFormField<String>(
                      value: idType,
                      decoration: InputDecoration(
                        labelText: 'ID Proof Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.badge_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Voter ID', child: Text('Voter ID')),
                        DropdownMenuItem(value: 'Aadhaar Card', child: Text('Aadhaar Card')),
                        DropdownMenuItem(value: 'PAN Card', child: Text('PAN Card')),
                        DropdownMenuItem(value: 'Driving Licence', child: Text('Driving Licence')),
                        DropdownMenuItem(value: 'Passport', child: Text('Passport')),
                      ],
                      onChanged: (val) => setModalState(() => idType = val ?? 'Voter ID'),
                    ),
                    const SizedBox(height: 12),
                    // ID Number
                    TextField(
                      controller: idNumberController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        labelText: 'ID Proof Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.credit_card_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Set 4-Digit MPIN
                    TextField(
                      controller: mpinController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Create 4-Digit MPIN *',
                        hintText: 'e.g. 1234',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Confirm 4-Digit MPIN
                    TextField(
                      controller: confirmMpinController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Confirm 4-Digit MPIN *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.lock_reset),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0066FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () {
                          final name = nameController.text.trim();
                          final age = ageController.text.trim();
                          final idNumber = idNumberController.text.trim();
                          final mpin = mpinController.text.trim();
                          final confirmMpin = confirmMpinController.text.trim();

                          if (name.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter your full name'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }
                          if (mpin.length != 4) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('MPIN must be 4 digits'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }
                          if (mpin != confirmMpin) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('MPIN does not match'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }

                          // Register strictly into local SharedPreferences
                          AppState.instance.registerUser(
                            fullName: name,
                            mobileNumber: mobileNumber,
                            age: age.isEmpty ? '25' : age,
                            idType: idType,
                            idNumber: idNumber.isEmpty ? 'ZMT1234567' : idNumber,
                            mpin: mpin,
                          );

                          Navigator.pop(ctx);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Welcome, ${AppState.instance.firstName}! Registration successful.'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: const Color(0xFF16A34A),
                            ),
                          );

                          // Navigate directly to MainNavScreen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainNavScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Register & Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MpinLoginScreen()),
    );
  }

  void _loginAsGuest() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFF4FAFD),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFEBF5FB),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE8F4FC),
                Color(0xFFF3F8FC),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // 1. Top Bar: Language circle button (left) + RailOne Logo (center)
                  _buildHeader(context),

                  const SizedBox(height: 18),

                  // 2. "Registered user Login Here ->" Pill Card
                  _buildRegisteredUserPill(),

                  const SizedBox(height: 16),

                  // 3. Main New User Registration Card
                  _buildRegistrationCard(),

                  const SizedBox(height: 14),

                  // 4. Terms Of Use & Privacy Policy
                  _buildTermsDisclaimer(),

                  const SizedBox(height: 14),

                  // 5. Login as Guest
                  _buildGuestLogin(),

                  const SizedBox(height: 8),

                  // 6. Version Info
                  const Text(
                    'V-1.2.12-1-Dev',
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                      letterSpacing: 0.4,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 7. Bottom Advertisement Slider (5 images + 5 indicator dots)
                  _buildAdvertisementSlider(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 1. Top Header with Language button (enlarged) & RailOne Title Logo
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: Language icon circle button (enlarged size)
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SelectLanguageScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFD0E3F3),
                width: 1.2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 5,
                  offset: Offset(0, 1.5),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                AppAssets.languageHeaderLogo,
                width: 36,
                height: 36,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Center: RailOne Logo image
        Image.asset(
          AppAssets.railOneLogoTitle,
          height: 36,
          fit: BoxFit.contain,
        ),

        // Right spacer for center alignment
        const SizedBox(width: 48),
      ],
    );
  }

  /// 2. Top White Pill: "Registered user Login Here ->"
  Widget _buildRegisteredUserPill() {
    return InkWell(
      onTap: _navigateToLogin,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: RichText(
            text: const TextSpan(
              text: 'Registered user ',
              style: TextStyle(
                fontFamily: 'NotoSans',
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF334155),
              ),
              children: [
                TextSpan(
                  text: 'Login Here  \u2192',
                  style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0066FF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 3. Main New User Registration Card
  Widget _buildRegistrationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE2F0FD),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD4E7F7),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          // Title
          const Text(
            'New User Registration',
            style: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),

          const SizedBox(height: 18),

          // Mobile Number Input Pill
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFFCCE4F7),
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 14),
                const Icon(
                  Icons.phone_outlined,
                  color: Color(0xFF64748B),
                  size: 19,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                      fontWeight: FontWeight.w500,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: const InputDecoration(
                      hintText: 'Mobile Number',
                      hintStyle: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 13.5,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                      isDense: true,
                    ),
                  ),
                ),

                // Register button inside the capsule
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: _handleRegisterClick,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _isPhoneValid
                            ? const Color(0xFF0066FF)
                            : const Color(0xFFE1F3FD),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontFamily: 'NotoSans',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _isPhoneValid
                              ? Colors.white
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // "Or Register with"
          const Text(
            'Or Register with',
            style: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 12.5,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 14),

          // Social Circle Buttons: Rail Connect & UTS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(
                assetPath: AppAssets.irctc,
                title: 'Rail Connect',
                onTap: () {
                  _mobileController.text = '9876543210';
                  _showRegistrationDetailsSheet('9876543210');
                },
              ),
              const SizedBox(width: 38),
              _buildSocialButton(
                assetPath: AppAssets.utsLogo,
                title: 'UTS',
                onTap: () {
                  _mobileController.text = '9876543210';
                  _showRegistrationDetailsSheet('9876543210');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required String assetPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFCBD5E1),
                width: 1.0,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.account_circle_outlined,
                    color: Color(0xFF0066FF),
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  /// 4. Terms and Privacy Policy
  Widget _buildTermsDisclaimer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'By continuing, you agree to our ',
          style: const TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 10.5,
            color: Color(0xFF64748B),
          ),
          children: [
            TextSpan(
              text: 'Terms Of Use',
              style: const TextStyle(
                fontFamily: 'NotoSans',
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0066FF),
              ),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
            const TextSpan(text: ' & '),
            TextSpan(
              text: 'Privacy Policy',
              style: const TextStyle(
                fontFamily: 'NotoSans',
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0066FF),
              ),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
          ],
        ),
      ),
    );
  }

  /// 5. Login as Guest
  Widget _buildGuestLogin() {
    return InkWell(
      onTap: _loginAsGuest,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        child: RichText(
          text: const TextSpan(
            text: 'Login as ',
            style: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
            children: [
              TextSpan(
                text: 'Guest',
                style: TextStyle(
                  fontFamily: 'NotoSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0066FF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 7. Bottom Advertisement Slider (firstAdd.png, add2.png, add3.png, add4.png, add5.png)
  Widget _buildAdvertisementSlider() {
    return Column(
      children: [
        SizedBox(
          height: 106,
          width: double.infinity,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: _bannerImages.length,
            onPageChanged: (index) {
              setState(() => _currentBannerIndex = index);
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    _bannerImages[index],
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // 5 Carousel Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_bannerImages.length, (index) {
            final isFilled = _currentBannerIndex == index;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3.5),
              width: 7.5,
              height: 7.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFilled ? const Color(0xFF0066FF) : Colors.white,
                border: Border.all(
                  color: const Color(0xFF0066FF),
                  width: 1.2,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
