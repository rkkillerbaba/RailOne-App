import 'package:flutter/material.dart';
import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../bookings/booking_details_screen.dart';
import '../bookings/my_bookings_screen.dart';
import '../journey/reserved_ticket_screen.dart';
import '../journey/unreserved_ticket_screen.dart';
import '../offerings/search_trains_screen.dart';
import '../offerings/pnr_status_screen.dart';
import '../offerings/coach_position_screen.dart';
import '../offerings/track_your_train_screen.dart';
import '../offerings/food_on_train_screen.dart';
import '../offerings/file_refund_screen.dart';
import '../offerings/rail_madad_screen.dart';
import '../../core/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.screenBackground,
          appBar: _buildCustomAppBar(context),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 14),
            _buildGreetingAndPlanner(context),
            const SizedBox(height: 24),
            _buildMoreOfferings(context),
            const SizedBox(height: 24),
            _buildUpcomingJourney(context),
            const SizedBox(height: 24),
            _buildDoYouKnow(context),
            const SizedBox(height: 24),
            _buildSocialMediaSection(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
      },
    );
  }

  /// 1. Top AppBar (Sticky, White bg, height 64)
  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: SafeArea(
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x08000000),
                offset: Offset(0, 1),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Circular language toggle button (42x42, 1.5px border #E2E8F0)
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(21),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: AppColors.borderLight,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'A',
                            style: TextStyle(
                              color: AppColors.languageBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              height: 1.0,
                            ),
                          ),
                          TextSpan(
                            text: 'अ',
                            style: TextStyle(
                              color: AppColors.languageBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Center: 'Rail' (w300) + 'One' (w800) in #4A4A4A (26px)
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Rail',
                      style: TextStyle(
                        color: AppColors.railTitleGrey,
                        fontSize: 26,
                        fontWeight: FontWeight.w300,
                        letterSpacing: -0.5,
                      ),
                    ),
                    TextSpan(
                      text: 'One',
                      style: TextStyle(
                        color: AppColors.railTitleGrey,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Right: Notification Bell button (42x42, 1.5px border #E2E8F0) with badge '5'
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(21),
                child: SizedBox(
                  width: 42,
                  height: 42,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: AppColors.borderLight,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: AppAssets.safeImage(
                            AppAssets.bellNotification,
                            width: 22,
                            height: 22,
                            fallbackIcon: Icons.notifications_none_outlined,
                            fallbackIconColor: AppColors.railTitleGrey,
                          ),
                        ),
                      ),
                      // Top-right Red circular badge showing '5'
                      Positioned(
                        top: -1,
                        right: -1,
                        child: Container(
                          padding: const EdgeInsets.all(3.5),
                          decoration: const BoxDecoration(
                            color: AppColors.badgeRed,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 17,
                            minHeight: 17,
                          ),
                          child: const Center(
                            child: Text(
                              '5',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                height: 1.0,
                              ),
                              textAlign: TextAlign.center,
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
        ),
      ),
    );
  }

  /// 2. Greeting & Section 1: Journey Planner
  Widget _buildGreetingAndPlanner(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi, ${AppState.instance.firstName}!',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.greetingText,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Journey Planner',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.headingNavy,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildPlannerCard(
                title: 'Reserved',
                assetPath: AppAssets.reservedCard,
                fallbackIcon: Icons.train,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReservedTicketScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPlannerCard(
                title: 'Unreserved',
                assetPath: AppAssets.unreservedCard,
                fallbackIcon: Icons.directions_railway,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UnreservedTicketScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPlannerCard(
                title: 'Platform',
                assetPath: AppAssets.platformCard,
                fallbackIcon: Icons.apartment,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlannerCard({
    required String title,
    required String assetPath,
    required IconData fallbackIcon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: AppAssets.safeImage(
                assetPath,
                fit: BoxFit.cover,
                fallbackIcon: fallbackIcon,
                fallbackIconSize: 36,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.labelMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 3. Section 2: More Offerings
  Widget _buildMoreOfferings(BuildContext context) {
    final List<_OfferingItem> offerings = [
      _OfferingItem(
        label: 'Search\nTrains',
        bgColor: AppColors.searchTrainsBg,
        assetPath: AppAssets.searchTrains,
        fallbackIcon: Icons.alt_route_rounded,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchTrainsScreen(),
            ),
          );
        },
      ),
      _OfferingItem(
        label: 'PNR\nStatus',
        bgColor: AppColors.pnrStatusBg,
        assetPath: AppAssets.pnrStatus,
        fallbackIcon: Icons.receipt_long_rounded,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PnrStatusScreen(),
            ),
          );
        },
      ),
      _OfferingItem(
        label: 'Coach\nPosition',
        bgColor: AppColors.coachPositionBg,
        assetPath: AppAssets.coachPosition,
        fallbackIcon: Icons.train_outlined,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CoachPositionScreen(),
            ),
          );
        },
      ),
      _OfferingItem(
        label: 'Track Your\nTrain',
        bgColor: AppColors.trackTrainBg,
        assetPath: AppAssets.trackTrain,
        fallbackIcon: Icons.location_on_outlined,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TrackYourTrainScreen(),
            ),
          );
        },
      ),
      _OfferingItem(
        label: 'Order\nFood',
        bgColor: AppColors.orderFoodBg,
        assetPath: AppAssets.orderFood,
        fallbackIcon: Icons.fastfood_outlined,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FoodOnTrainScreen(),
            ),
          );
        },
      ),
      _OfferingItem(
        label: 'File\nRefund',
        bgColor: AppColors.fileRefundBg,
        assetPath: AppAssets.fileRefund,
        fallbackIcon: Icons.money_off_csred_outlined,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FileRefundScreen(),
            ),
          );
        },
      ),
      _OfferingItem(
        label: 'Rail\nMadad',
        bgColor: AppColors.railMadadBg,
        assetPath: AppAssets.railMadad,
        fallbackIcon: Icons.support_agent_rounded,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RailMadadScreen(),
            ),
          );
        },
      ),
      _OfferingItem(
        label: 'Go To\nWAVES',
        bgColor: AppColors.wavesBg,
        assetPath: AppAssets.waves,
        fallbackIcon: Icons.waves_rounded,
        isCustomWave: true,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'More Offerings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.headingNavy,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: offerings.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.72,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final item = offerings[index];
            return _buildOfferingItem(item);
          },
        ),
      ],
    );
  }

  Widget _buildOfferingItem(_OfferingItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: item.bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(15),
            child: item.isCustomWave
                ? AppAssets.safeImage(
                    item.assetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text(
                          'W',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'serif',
                          ),
                        ),
                      );
                    },
                  )
                : AppAssets.safeImage(
                    item.assetPath,
                    fit: BoxFit.contain,
                    fallbackIcon: item.fallbackIcon,
                    fallbackIconColor: AppColors.offeringLabel,
                  ),
          ),
          const SizedBox(height: 6),
          Text(
            item.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.offeringLabel,
              height: 1.15,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  /// 4. Section 3: Upcoming Journey
  Widget _buildUpcomingJourney(BuildContext context) {
    final ticket = AppState.instance.latestTicket;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Journey',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.headingNavy,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 14),
        // Purple Ticket Card with Ticket Cutout Notches
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.ticketGradientStart,
                      AppColors.ticketGradientMiddle,
                      AppColors.ticketGradientEnd,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top: Date
                    Text(
                      ticket.bookingDateText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Divider
                    const Divider(
                      color: AppColors.ticketDivider,
                      height: 1,
                      thickness: 1,
                    ),
                    const SizedBox(height: 12),

                    // Middle Row: Source & Destination
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ticket.sourceStation,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                        ),
                        Text(
                          ticket.destinationStation,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Divider
                    const Divider(
                      color: AppColors.ticketDivider,
                      height: 1,
                      thickness: 1,
                    ),
                    const SizedBox(height: 12),

                    // Bottom Row: 'Unreserved' & Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ticket.category,
                          style: const TextStyle(
                            color: AppColors.ticketUnreservedGreen,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            _buildTicketButton(
                              'Book Again',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const UnreservedTicketScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            _buildTicketButton(
                              'View Details',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingDetailsScreen(ticket: ticket),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Top Ticket Cutout Notch (20x20 white circle at top: -10, right: 75)
              Positioned(
                top: -10,
                right: 75,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Bottom Ticket Cutout Notch (20x20 white circle at bottom: -10, right: 75)
              Positioned(
                bottom: -10,
                right: 75,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTicketButton(
    String label, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white70, width: 1),
          color: AppColors.ticketButtonFill,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// 5. Section 4: Do You Know?
  Widget _buildDoYouKnow(BuildContext context) {
    final List<_TriviaCardData> triviaCards = [
      _TriviaCardData(
        assetPath: AppAssets.firstEverTrain,
        description:
            'First ever passenger train was run between Bori Bandar to Thane on April 16, 1853.',
      ),
      _TriviaCardData(
        assetPath: AppAssets.chenabBridge,
        description:
            "Chenab Railway Bridge in Dharot, Jammu & Kashmir is the World's highest Railway Bridge.",
      ),
      _TriviaCardData(
        assetPath: AppAssets.noneyBridge,
        description:
            "Noney Bridge in Manipur is the world's tallest railway pier bridge.",
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Do You know?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.headingNavy,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 235,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: triviaCards.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final card = triviaCards[index];
              return SizedBox(
                width: 175,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: AppAssets.safeImage(
                        card.assetPath,
                        width: 175,
                        height: 145,
                        fit: BoxFit.cover,
                        fallbackIcon: Icons.landscape_rounded,
                        fallbackIconSize: 40,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      card.description,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.triviaText,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 6. Section 5: Follow Us On Social Media Platforms
  Widget _buildSocialMediaSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Follow Us On Social Media Platforms',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.headingNavy,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 175,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                AppAssets.safeImage(
                  AppAssets.socialMediaBanner,
                  fit: BoxFit.cover,
                  fallbackIcon: Icons.photo_library_outlined,
                  fallbackIconSize: 48,
                ),

                // Centered Social Media Icons
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // X logo: Black circle 40x40 with white 'X'
                      _buildSocialIconWrapper(
                        width: 40,
                        height: 40,
                        shape: BoxShape.circle,
                        color: AppColors.xBlack,
                        child: const Center(
                          child: Text(
                            'X',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Facebook logo: Blue circle 40x40 with white 'f'
                      _buildSocialIconWrapper(
                        width: 40,
                        height: 40,
                        shape: BoxShape.circle,
                        color: AppColors.facebookBlue,
                        child: const Center(
                          child: Text(
                            'f',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'serif',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Instagram logo: 38x38 rounded square (r:10) with gradient
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: AppColors.instagramGradient,
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // YouTube logo: 44x32 red rounded rectangle (r:8) with play icon
                      Container(
                        width: 44,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.youtubeRed,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 22,
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
      ],
    );
  }

  Widget _buildSocialIconWrapper({
    required double width,
    required double height,
    required BoxShape shape,
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        shape: shape,
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _OfferingItem {
  final String label;
  final Color bgColor;
  final String assetPath;
  final IconData fallbackIcon;
  final bool isCustomWave;
  final VoidCallback? onTap;

  const _OfferingItem({
    required this.label,
    required this.bgColor,
    required this.assetPath,
    required this.fallbackIcon,
    this.isCustomWave = false,
    this.onTap,
  });
}

class _TriviaCardData {
  final String assetPath;
  final String description;

  const _TriviaCardData({
    required this.assetPath,
    required this.description,
  });
}
