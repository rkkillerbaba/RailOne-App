import 'package:flutter/material.dart';
import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../../core/app_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Biometric toggle state
  bool isBiometricOn = true;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // 1. Top Light-Blue Header Container (Curved Bottom)
                _buildTopHeader(context),

                // 2. Profile Complete Progress Card
                _buildProfileCompleteCard(),

                // 3. Saved Passengers Card
                _buildSavedPassengersCard(context),

                // 4. Bottom 6 Action Grid Cards (3x2 Grid)
                _buildActionGrid(context),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 1. Top Light-Blue Header Container (Curved Bottom)
  Widget _buildTopHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.profileHeaderBg,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.0,
        left: 16.0,
        right: 16.0,
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
          const SizedBox(height: 10),

          // Name: Strictly First Name
          Text(
            AppState.instance.firstName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),

          // View & Edit Details Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // View Details
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Profile: ${AppState.instance.fullName}, Mobile: ${AppState.instance.mobileNumber}, ID: ${AppState.instance.idType} (${AppState.instance.idNumber})'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      color: AppColors.languageBlue,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.languageBlue,
                      ),
                    ),
                  ],
                ),
              ),

              // Vertical Divider
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  '|',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),

              // Edit Details
              InkWell(
                onTap: () => _showEditProfileDialog(context),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit,
                      color: AppColors.languageBlue,
                      size: 15,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Edit Details',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.languageBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // R-Wallet White Pill Card (Height 66, borderRadius: 35)
          Container(
            height: 66,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Left: Green Wallet Icon
                AppAssets.safeImage(
                  AppAssets.rWallet,
                  width: 34,
                  height: 34,
                  fallbackIcon: Icons.account_balance_wallet,
                  fallbackIconColor: const Color(0xFF2ECC71),
                  fallbackIconSize: 32,
                ),
                const SizedBox(width: 12),

                // Amount Column
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
                        fontSize: 16,
                        color: AppColors.rWalletAmountText,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Blue sync/refresh icon
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Refreshing wallet balance...'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.sync,
                      color: AppColors.languageBlue,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Solid Blue Pill Button: 'Add'
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Add money to R-Wallet...'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.languageBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
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
    );
  }

  /// 2. Profile Complete Progress Card
  Widget _buildProfileCompleteCard() {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 14.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.progressBorder,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile Complete',
            style: TextStyle(
              fontSize: 13.5,
              color: Color(0xFF334155),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: const LinearProgressIndicator(
                    value: 1.0,
                    minHeight: 6,
                    backgroundColor: Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.progressGreen,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '100%',
                style: TextStyle(
                  fontSize: 14.5,
                  color: AppColors.darkBlueText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 3. Saved Passengers Card
  Widget _buildSavedPassengersCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 14.0),
      decoration: BoxDecoration(
        color: AppColors.passengerCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFEF3C7),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          // Header Section (Peach bg #FFF3E0)
          Container(
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              color: AppColors.passengerHeaderBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // Golden Group Icon
                const Icon(
                  Icons.people,
                  color: AppColors.passengerGold,
                  size: 28,
                ),
                const SizedBox(width: 12),

                // Title & Subtitle Column
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saved Passengers',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkBlueText,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Add/Edit Passenger info',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF475569),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Golden Sync Icon
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Refreshing passengers list...'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.sync,
                      color: AppColors.passengerGold,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Golden-Yellow Oval 'Add' Button
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Add New Passenger...'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.passengerGoldBtn,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5D4037),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Passenger List
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                // Passenger 1: User / Saved Passenger
                _buildPassengerItem(
                  context: context,
                  name: AppState.instance.fullName,
                  details: '${AppState.instance.age} Y, M, NC | Veg',
                  avatarAsset: AppAssets.maleAvatar,
                  isVeg: true,
                  isVerified: true,
                ),
                const SizedBox(height: 16),

                // Passenger 2: Sarita Khandelwa (No Food)
                _buildPassengerItem(
                  context: context,
                  name: 'Sarita Khandelwa',
                  details: '64 Y, F, LB | No Food',
                  avatarAsset: AppAssets.femaleAvatar,
                  isVeg: false,
                  isVerified: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerItem({
    required BuildContext context,
    required String name,
    required String details,
    required String avatarAsset,
    required bool isVeg,
    required bool isVerified,
  }) {
    return Row(
      children: [
        // Avatar circle
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: AppColors.passengerAvatarBg,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: AppAssets.safeImage(
              avatarAsset,
              width: 24,
              height: 24,
              fallbackIcon: Icons.person,
              fallbackIconColor: const Color(0xFFE67E22),
              fallbackIconSize: 22,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Name & Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Food Preference Symbol
                  _buildFoodIcon(isVeg),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Text(
                    details,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF78909C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isVerified) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      color: Color(0xFF43A047),
                      size: 15,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        // Actions: Edit & Delete
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Edit passenger $name...'),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(
              Icons.edit_note,
              color: AppColors.passengerGold,
              size: 22,
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Delete passenger $name?'),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(
              Icons.delete_outline,
              color: AppColors.passengerGold,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  /// Indian Railways Veg / Non-Veg / No-Food Symbol
  Widget _buildFoodIcon(bool isVeg) {
    final Color symbolColor = isVeg ? const Color(0xFF2E7D32) : const Color(0xFF78909C);

    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: symbolColor,
          width: 1.2,
        ),
      ),
      child: Center(
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: symbolColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  /// 4. Bottom 6 Action Grid Cards (3x2 Grid)
  Widget _buildActionGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 14.0, bottom: 24.0),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
        children: [
          // 1. Change Password
          _buildActionCard(
            context: context,
            bgColor: AppColors.cardChangePasswordBg,
            label: 'Change\nPassword',
            topWidget: AppAssets.safeImage(
              AppAssets.changePassword,
              width: 34,
              height: 34,
              fallbackIcon: Icons.lock_reset,
              fallbackIconColor: const Color(0xFF4DD0E1),
              fallbackIconSize: 32,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Change Password tapped'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),

          // 2. My Account
          _buildActionCard(
            context: context,
            bgColor: AppColors.cardMyAccountBg,
            label: 'My\nAccount',
            topWidget: AppAssets.safeImage(
              AppAssets.myAccount,
              width: 34,
              height: 34,
              fallbackIcon: Icons.badge_outlined,
              fallbackIconColor: const Color(0xFF66BB6A),
              fallbackIconSize: 32,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('My Account tapped'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),

          // 3. Biometric (Custom interactive toggle switch)
          _buildActionCard(
            context: context,
            bgColor: AppColors.cardBiometricBg,
            label: 'Biometric',
            topWidget: _buildBiometricSwitch(),
            onTap: () {
              setState(() {
                isBiometricOn = !isBiometricOn;
              });
            },
          ),

          // 4. Transfer Ticket
          _buildActionCard(
            context: context,
            bgColor: AppColors.cardTransferTicketBg,
            label: 'Transfer\nTicket',
            topWidget: const Icon(
              Icons.confirmation_number,
              color: Color(0xFF4FC3F7),
              size: 34,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transfer Ticket tapped'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),

          // 5. My Transaction
          _buildActionCard(
            context: context,
            bgColor: AppColors.cardMyTransactionBg,
            label: 'My\nTransaction',
            topWidget: AppAssets.safeImage(
              AppAssets.myTransaction,
              width: 34,
              height: 34,
              fallbackIcon: Icons.receipt_long_rounded,
              fallbackIconColor: const Color(0xFFFFB74D),
              fallbackIconSize: 32,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('My Transaction tapped'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),

          // 6. DeLink Aadhar
          _buildActionCard(
            context: context,
            bgColor: AppColors.cardDeLinkAadharBg,
            label: 'DeLink\nAadhar',
            topWidget: AppAssets.safeImage(
              AppAssets.delinkAadhar,
              width: 34,
              height: 34,
              fallbackIcon: Icons.credit_card_rounded,
              fallbackIconColor: const Color(0xFFC0CA33),
              fallbackIconSize: 32,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('DeLink Aadhar tapped'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required Color bgColor,
    required String label,
    required Widget topWidget,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 34,
              child: Center(child: topWidget),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.actionGridText,
                height: 1.15,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  /// Custom Pill Toggle Switch for Biometric (matches screenshot exact UI)
  Widget _buildBiometricSwitch() {
    return Container(
      width: 52,
      height: 24,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isBiometricOn ? AppColors.languageBlue : const Color(0xFFCBD5E1),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment:
            isBiometricOn ? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceBetween,
        children: [
          if (isBiometricOn) ...[
            const Padding(
              padding: EdgeInsets.only(left: 4.0),
              child: Text(
                'On',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.languageBlue,
                  height: 1.0,
                ),
              ),
            ),
            Container(
              width: 17,
              height: 17,
              decoration: const BoxDecoration(
                color: AppColors.languageBlue,
                shape: BoxShape.circle,
              ),
            ),
          ] else ...[
            Container(
              width: 17,
              height: 17,
              decoration: const BoxDecoration(
                color: Color(0xFFCBD5E1),
                shape: BoxShape.circle,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: Text(
                'Off',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B),
                  height: 1.0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final nameController =
        TextEditingController(text: AppState.instance.fullName);
    final mobileController =
        TextEditingController(text: AppState.instance.mobileNumber);
    final ageController =
        TextEditingController(text: AppState.instance.age);
    final idNumberController =
        TextEditingController(text: AppState.instance.idNumber);
    final walletController = TextEditingController(
        text: AppState.instance.rWalletBalance.toStringAsFixed(2));
    String selectedIdType = AppState.instance.idType;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
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
                          'Edit Profile Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0D234A),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                          onPressed: () => Navigator.pop(modalContext),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildEditTextField(
                      controller: nameController,
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildEditTextField(
                            controller: mobileController,
                            label: 'Mobile Number',
                            hint: '10 digit mobile',
                            icon: Icons.phone_android,
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: _buildEditTextField(
                            controller: ageController,
                            label: 'Age',
                            hint: 'Age',
                            icon: Icons.cake_outlined,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ID Type',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF475569),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border:
                                    Border.all(color: const Color(0xFFCBD5E1)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedIdType,
                                    isExpanded: true,
                                    items: [
                                      'Voter ID',
                                      'Aadhaar Card',
                                      'PAN Card',
                                      'Passport'
                                    ]
                                        .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e,
                                                style: const TextStyle(
                                                    fontSize: 13))))
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        setModalState(
                                            () => selectedIdType = val);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: _buildEditTextField(
                            controller: idNumberController,
                            label: 'ID Number',
                            hint: 'Enter ID number',
                            icon: Icons.badge_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildEditTextField(
                      controller: walletController,
                      label: 'R-Wallet Balance (₹)',
                      hint: 'Wallet balance',
                      icon: Icons.account_balance_wallet_outlined,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0066FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          final newName = nameController.text.trim();
                          if (newName.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Name cannot be empty')),
                            );
                            return;
                          }
                          AppState.instance.updateUserProfile(
                            fullName: newName,
                            mobileNumber: mobileController.text.trim(),
                            age: ageController.text.trim().isEmpty
                                ? AppState.instance.age
                                : ageController.text.trim(),
                            idType: selectedIdType,
                            idNumber: idNumberController.text.trim(),
                            rWalletBalance: double.tryParse(
                                    walletController.text.trim()) ??
                                AppState.instance.rWalletBalance,
                          );
                          Navigator.pop(modalContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile updated successfully!'),
                              backgroundColor: Color(0xFF0066FF),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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

  Widget _buildEditTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A)),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20, color: const Color(0xFF0066FF)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color(0xFF0066FF), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
