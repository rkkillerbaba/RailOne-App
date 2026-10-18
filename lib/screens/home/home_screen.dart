import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../bookings/booking_details_screen.dart';
import '../journey/reserved_ticket_screen.dart';
import '../journey/unreserved_ticket_screen.dart';
import '../offerings/search_trains_screen.dart';
import '../offerings/pnr_status_screen.dart';
import '../offerings/coach_position_screen.dart';
import '../offerings/track_your_train_screen.dart';
import '../offerings/food_on_train_screen.dart';
import '../offerings/file_refund_screen.dart';
import '../offerings/rail_madad_screen.dart';
import '../common/select_language_screen.dart';
import '../common/notification_screen.dart';
import '../../core/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Color(0xFF0066FF),
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          child: Scaffold(
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
                  if (AppState.instance.hasActiveTicket) ...[
                    const SizedBox(height: 24),
                    _buildUpcomingJourney(context),
                  ],
                  const SizedBox(height: 24),
                  _buildDoYouKnow(context),
                  const SizedBox(height: 24),
                  _buildSocialMediaSection(context),
                  const SizedBox(height: 32),
                ],
              ),
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
              // Left: Circular language toggle button
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectLanguageScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      AppAssets.languageHeaderLogo,
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Center: RailOne Logo image (BoxFit.contain)
              Image.asset(
                AppAssets.railOneLogoTitle,
                height: 32,
                fit: BoxFit.contain,
              ),

              // Right: Notification Bell button (clean circular button matching original)
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      AppAssets.notificationBellGif,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
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

  /// 2. Greeting & Section 1: Journey Planner
  Widget _buildGreetingAndPlanner(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi, ${AppState.instance.firstName}!',
          style: const TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF142459),
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Journey Planner',
          style: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF142459),
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
            aspectRatio: 1.25,
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
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF384E80),
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
        iconPadding: const EdgeInsets.all(9),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RailMadadScreen(),
            ),
          );
        },
      ),
      const _OfferingItem(
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
            fontFamily: 'NotoSans',
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF142459),
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
            padding: item.iconPadding ?? const EdgeInsets.all(10),
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
              fontFamily: 'NotoSans',
              fontSize: 12.2,
              fontWeight: FontWeight.w500,
              color: Color(0xFF142459),
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
    if (ticket == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.scale(
          scaleX: 1.08,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Upcoming Journey',
            style: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 16.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF132458),
              letterSpacing: 0.2,
            ),
          ),
        ),
        const SizedBox(height: 18),
        _buildUpcomingJourneyCard(context),
      ],
    );
  }

  Widget _buildUpcomingJourneyCard(BuildContext context) {
    final ticket = AppState.instance.latestTicket;
    if (ticket == null) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.75;
    final notchRight = cardWidth * 0.23 - 11;

    return Center(
      child: SizedBox(
        width: cardWidth,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF5450A4),
                      Color(0xFF7E60B8),
                      Color(0xFFBC84DA),
                    ],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(14, 26, 14, 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top: Date
                    Text(
                      ticket.bookingDateText,
                      style: const TextStyle(
                        fontFamily: 'NotoSans',
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Divider 1 below Date
                    Divider(
                      color: Colors.white.withValues(alpha: 0.25),
                      height: 1,
                      thickness: 0.8,
                    ),
                    const SizedBox(height: 8),

                    // Middle Row: Source & Destination
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ticket.sourceStation.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'NotoSans',
                            color: Colors.white,
                            fontSize: 11.8,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Text(
                          ticket.destinationStation.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'NotoSans',
                            color: Colors.white,
                            fontSize: 11.8,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Divider 2 below Stations
                    Divider(
                      color: Colors.white.withValues(alpha: 0.25),
                      height: 1,
                      thickness: 0.8,
                    ),
                    const SizedBox(height: 8),

                    // Bottom Row: 'Unreserved' & Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ticket.category,
                          style: const TextStyle(
                            fontFamily: 'NotoSans',
                            color: Color(0xFFBFEFBC),
                            fontSize: 13.8,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.1,
                          ),
                        ),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
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
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Top Ticket Cutout Notch
              Positioned(
                top: -11,
                right: notchRight,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Bottom Ticket Cutout Notch
              Positioned(
                bottom: -11,
                right: notchRight,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 1.1),
          color: const Color(0x28000000),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'NotoSans',
            color: Colors.white,
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// 5. Section 4: Do You Know?
  Widget _buildDoYouKnow(BuildContext context) {
    const List<_TriviaCardData> triviaCards = [
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
            "Noney Bridge is going to be world's tallest railway bridge pier at a height of 141 meters.",
      ),
      _TriviaCardData(
        assetPath: AppAssets.hubballiRailway,
        description:
            "Shree Siddharoodha Swamiji Railway Station Hubballi is world's longest Railway Platform with length of 1505 meters.",
      ),
      _TriviaCardData(
        assetPath: AppAssets.trackElectrification,
        description:
            '99% Electrification is achieved in Indian Railways.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Do You know?',
          style: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF142459),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 245,
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
                        fontFamily: 'NotoSans',
                        fontSize: 11.2,
                        color: Color(0xFF475882),
                        height: 1.35,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 6,
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
            fontFamily: 'NotoSans',
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF142459),
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
                      // X logo: Black circle 40x40 with FontAwesomeBrands X icon
                      _buildSocialIconWrapper(
                        width: 40,
                        height: 40,
                        shape: BoxShape.circle,
                        color: AppColors.xBlack,
                        child: const Center(
                          child: Icon(
                            IconData(0xe61b, fontFamily: 'FontAwesomeBrands'),
                            color: Colors.white,
                            size: 19,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Facebook logo: Blue circle 40x40 with FontAwesomeBrands 'f' icon
                      _buildSocialIconWrapper(
                        width: 40,
                        height: 40,
                        shape: BoxShape.circle,
                        color: AppColors.facebookBlue,
                        child: const Center(
                          child: Icon(
                            IconData(0xf39e, fontFamily: 'FontAwesomeBrands'),
                            color: Colors.white,
                            size: 21,
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
                            IconData(0xf16d, fontFamily: 'FontAwesomeBrands'),
                            color: Colors.white,
                            size: 21,
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
                            IconData(0xf167, fontFamily: 'FontAwesomeBrands'),
                            color: Colors.white,
                            size: 21,
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
  final EdgeInsetsGeometry? iconPadding;

  const _OfferingItem({
    required this.label,
    required this.bgColor,
    required this.assetPath,
    required this.fallbackIcon,
    this.isCustomWave = false,
    this.onTap,
    this.iconPadding,
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
