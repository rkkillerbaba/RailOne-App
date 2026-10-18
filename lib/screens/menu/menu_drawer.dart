import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_state.dart';

/// Helper function to open the Menu Drawer from the right side over the entire screen.
Future<void> showRailOneMenuDrawer(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Menu',
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.72,
            height: double.infinity,
            child: const MenuDrawer(),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim, secondaryAnim, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: anim,
            curve: Curves.easeOutCubic,
          ),
        ),
        child: child,
      );
    },
  );
}

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          bottomLeft: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 16,
            offset: Offset(-4, 0),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. Top Profile Header Section (Soft Lavender Card)
            _buildProfileHeader(context),

            // 2. R-Wallet Pill Card
            _buildRWalletCard(context),

            // 3. Menu Items List
            _buildMenuItemsList(context),

            // 4. Divider & Log Out Section
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              child: Divider(
                color: AppColors.menuDivider,
                height: 1,
                thickness: 1.2,
              ),
            ),
            const SizedBox(height: 18),
            _buildLogOutRow(context),

            // 5. Version Text
            const SizedBox(height: 24),
            const Text(
              'V-2.1.66-237',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF94A3B8),
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  },
);
  }

  /// 1. Top Profile Header Section
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.menuHeaderBg,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20.0,
        bottom: 20.0,
      ),
      child: Column(
        children: [
          // Centered Circular Avatar (76x76, bg #4AA9DF)
          Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              color: AppColors.profileAvatarBg,
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Head circle (lavender)
                Positioned(
                  top: 15,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDDD6FE),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Shoulders arc (light blue)
                Positioned(
                  bottom: 11,
                  child: Container(
                    width: 44,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF93C5FD),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Name: Strictly First Name
          Text(
            AppState.instance.firstName,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  /// 2. R-Wallet Pill Card
  Widget _buildRWalletCard(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 18.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppColors.menuHeaderBg,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Row(
        children: [
          // Wallet Icon (Purple-Blue)
          const Icon(
            Icons.account_balance_wallet_rounded,
            color: AppColors.menuWalletIcon,
            size: 32,
          ),
          const SizedBox(width: 10),

          // Column: 'R-Wallet' & '₹ 3.50'
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'R-Wallet',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF475569),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '₹ ${AppState.instance.rWalletBalance.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 15.5,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Solid Blue Pill Button: 'Add Money'
          InkWell(
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add Money to R-Wallet...'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            borderRadius: BorderRadius.circular(24),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.languageBlue,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                'Add Money',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Menu Items List
  Widget _buildMenuItemsList(BuildContext context) {
    final List<_MenuItemData> items = const [
      _MenuItemData(
        icon: Icons.receipt_long_rounded,
        title: 'Show/Hide Services',
      ),
      _MenuItemData(
        icon: Icons.question_answer_rounded,
        title: 'FAQs',
      ),
      _MenuItemData(
        icon: Icons.support_agent_rounded,
        title: 'Help & Support',
      ),
      _MenuItemData(
        icon: Icons.local_activity_rounded,
        title: 'Reserved Services - Counter',
      ),
      _MenuItemData(
        icon: Icons.info_rounded,
        title: 'About',
      ),
      _MenuItemData(
        icon: Icons.thumb_up_alt_rounded,
        title: 'Rate Us',
      ),
      _MenuItemData(
        icon: Icons.share_rounded,
        title: 'Share',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 22.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.title} tapped'),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    color: AppColors.menuIconColor,
                    size: 22,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.menuTextDark,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 4. Log Out Row
  Widget _buildLogOutRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logging out...'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: const Row(
          children: [
            Icon(
              Icons.logout_rounded,
              color: AppColors.menuIconColor,
              size: 22,
            ),
            SizedBox(width: 16),
            Text(
              'Log Out',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.menuTextDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String title;

  const _MenuItemData({
    required this.icon,
    required this.title,
  });
}
