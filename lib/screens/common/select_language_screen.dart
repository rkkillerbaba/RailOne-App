import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_colors.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({super.key});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  String _selectedLang = 'English';

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'native': 'English'},
    {'name': 'Hindi', 'native': 'हिन्दी'},
    {'name': 'Bengali', 'native': 'বাংলা'},
    {'name': 'Telugu', 'native': 'తెలుగు'},
    {'name': 'Marathi', 'native': 'मराठी'},
    {'name': 'Tamil', 'native': 'தமிழ்'},
    {'name': 'Gujarati', 'native': 'ગુજરાતી'},
    {'name': 'Kannada', 'native': 'ಕನ್ನಡ'},
    {'name': 'Malayalam', 'native': 'മലയാളം'},
    {'name': 'Punjabi', 'native': 'ਪੰਜਾਬੀ'},
    {'name': 'Odia', 'native': 'ଓଡ଼ିଆ'},
  ];

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
      appBar: AppBar(
        title: const Text(
          'Select Language',
          style: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF142459),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF142459)),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _languages.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final lang = _languages[index];
                  final isSelected = _selectedLang == lang['name'];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    title: Text(
                      lang['name']!,
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.primaryBlue : const Color(0xFF1E2F65),
                      ),
                    ),
                    subtitle: Text(
                      lang['native']!,
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppColors.primaryBlue)
                        : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
                    onTap: () {
                      setState(() {
                        _selectedLang = lang['name']!;
                      });
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Language set to $_selectedLang'),
                        backgroundColor: AppColors.primaryBlue,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Apply / जारी रखें',
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
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
}
