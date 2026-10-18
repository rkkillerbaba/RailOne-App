import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import 'bookings/my_bookings_screen.dart';
import 'home/home_screen.dart';
import 'menu/menu_drawer.dart';
import 'profile/profile_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    const HomeScreen(),
    MyBookingsScreen(
      onBackToHome: () {
        setState(() {
          _currentIndex = 0;
        });
      },
    ),
    const ProfileScreen(),
    const _PlaceholderScreen(title: 'Menu'),
  ];

  @override
  Widget build(BuildContext context) {
    // Hide blue main bottom nav when MyBookings is selected, since MyBookings has its own bottom filter bar
    final bool hideBottomNav = _currentIndex == 1;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF0066FF),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: hideBottomNav ? null : _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryBlue,
        boxShadow: [
          BoxShadow(
            color: Color(0x1F000000),
            offset: Offset(0, -2),
            blurRadius: 6,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 65,
          child: Row(
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_rounded,
                label: 'Home',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.confirmation_number_outlined,
                label: 'My Bookings',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyBookingsScreen(),
                    ),
                  );
                },
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.person_outline_rounded,
                label: 'You',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.menu_rounded,
                label: 'Menu',
                onTap: () {
                  showRailOneMenuDrawer(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    final bool isSelected = _currentIndex == index;
    final Color itemColor = isSelected ? Colors.white : Colors.white70;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ??
              () {
                setState(() {
                  _currentIndex = index;
                });
              },
          splashColor: Colors.white24,
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: itemColor,
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: itemColor,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: -0.1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.headingNavy,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.train_rounded,
              size: 64,
              color: AppColors.primaryBlue.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              '$title Screen',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.headingNavy,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coming soon in the next module',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.labelMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
