import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import 'unreserved_booking_payment_screen.dart';

class UnreservedTicketScreen extends StatefulWidget {
  const UnreservedTicketScreen({super.key});

  @override
  State<UnreservedTicketScreen> createState() => _UnreservedTicketScreenState();
}

class _UnreservedTicketScreenState extends State<UnreservedTicketScreen> {
  // Top Segmented Tab State: false = Normal, true = Season
  bool isSeasonTab = false;

  // Normal Tab States
  bool isOutsideStation = true; // true = Outside Station, false = At Station
  String normalSource = '';
  String normalDestination = '';

  // Season Tab States
  String seasonType = 'ISSUE'; // 'ISSUE' or 'RENEW'
  String bookingFor = 'Self'; // 'Self' or 'Others'
  String seasonSource = '';
  String seasonDestination = '';
  bool isNextDate = true; // true = Next Date, false = Current Date

  // Recent Searches Data
  final List<_UnreservedRecentSearch> normalRecentSearches = const [
    _UnreservedRecentSearch(
      from: 'SHRIDHAM, SRID',
      to: 'MADAN MAHAL, MML',
    ),
    _UnreservedRecentSearch(
      from: 'SHRIDHAM, SRID',
      to: 'JABALPUR, JBP',
    ),
  ];

  final List<_UnreservedRecentSearch> seasonRecentSearches = const [
    _UnreservedRecentSearch(
      from: 'SHRIDHAM, SRID',
      to: 'JABALPUR, JBP',
    ),
    _UnreservedRecentSearch(
      from: 'NARSINGHPUR, NU',
      to: 'SHRIDHAM, SRID',
    ),
    _UnreservedRecentSearch(
      from: 'JABALPUR, JBP',
      to: 'SHRIDHAM, SRID',
    ),
  ];

  void _swapNormalStations() {
    setState(() {
      final temp = normalSource;
      normalSource = normalDestination;
      normalDestination = temp;
    });
  }

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
        backgroundColor: AppColors.scaffoldGreyBg,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildMainFormCard(context),
                      const SizedBox(height: 8),
                      _buildRecentSearchesSection(context),
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

  /// 1. Top Header Bar (White bg, Centered Title, Right Close Button)
  Widget _buildTopHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left placeholder for symmetry
          const SizedBox(width: 40, height: 40),

          // Center Title
          const Text(
            'Unreserved E-Ticket',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.headingNavy,
              letterSpacing: -0.2,
            ),
          ),

          // Right Close Button (40x40, 1.5px border #D0E2FF)
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFD0E2FF),
                  width: 1.5,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.close,
                  color: AppColors.languageBlue,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Main White Form Card
  Widget _buildMainFormCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A. Segmented Tab Toggle ("Normal" | "Season")
          _buildSegmentedTabToggle(),
          const SizedBox(height: 18),

          // Dynamic Content based on active tab
          if (!isSeasonTab) ...[
            _buildNormalTabContent(context),
          ] else ...[
            _buildSeasonTabContent(context),
          ],
        ],
      ),
    );
  }

  /// A. Segmented Tab Toggle ("Normal" | "Season")
  Widget _buildSegmentedTabToggle() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          // Normal Tab
          Expanded(
            child: InkWell(
              onTap: () {
                if (isSeasonTab) {
                  setState(() {
                    isSeasonTab = false;
                  });
                }
              },
              borderRadius: BorderRadius.circular(9),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isSeasonTab ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: !isSeasonTab
                      ? const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'Normal',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: !isSeasonTab
                        ? AppColors.languageBlue
                        : AppColors.darkBlueText,
                  ),
                ),
              ),
            ),
          ),

          // Season Tab
          Expanded(
            child: InkWell(
              onTap: () {
                if (!isSeasonTab) {
                  setState(() {
                    isSeasonTab = true;
                  });
                }
              },
              borderRadius: BorderRadius.circular(9),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSeasonTab ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: isSeasonTab
                      ? const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'Season',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isSeasonTab
                        ? AppColors.languageBlue
                        : AppColors.darkBlueText,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// B. Normal Tab Content (Screenshot 1)
  Widget _buildNormalTabContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location Pills: 'Outside Station' vs 'At Station'
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isOutsideStation = true;
                  });
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: isOutsideStation
                        ? AppColors.languageBlue
                        : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isOutsideStation
                          ? AppColors.languageBlue
                          : AppColors.chipBorderGrey,
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Outside Station',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: isOutsideStation
                              ? Colors.white
                              : AppColors.labelGrey,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: isOutsideStation
                            ? Colors.white
                            : AppColors.chipBorderGrey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isOutsideStation = false;
                  });
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: !isOutsideStation
                        ? AppColors.languageBlue
                        : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: !isOutsideStation
                          ? AppColors.languageBlue
                          : AppColors.chipBorderGrey,
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'At Station',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: !isOutsideStation
                              ? Colors.white
                              : AppColors.labelGrey,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: !isOutsideStation
                            ? Colors.white
                            : AppColors.chipBorderGrey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // From & To with Circular Swap Button
        _buildNormalStationSection(),
        const SizedBox(height: 36),

        // Action Button 1: Proceed To Book
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UnreservedBookingPaymentScreen(
                    sourceStation: normalSource.isEmpty ? 'SHRIDHAM' : normalSource,
                    destinationStation:
                        normalDestination.isEmpty ? 'JABALPUR' : normalDestination,
                    isSeasonTicket: false,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.languageBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text(
              'Proceed To Book',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Action Button 2: Check Upcoming Trains (Outlined)
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Checking upcoming trains...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: AppColors.languageBlue, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text(
              'Check Upcoming Trains',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                color: AppColors.labelBlue,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  /// Normal Station Section (From & To with Overlapping Circular Swap Button)
  Widget _buildNormalStationSection() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // From
            const Text(
              'From',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppColors.labelBlue,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                AppAssets.safeImage(
                  AppAssets.trainEngineIcon,
                  width: 22,
                  height: 22,
                  fallbackIcon: Icons.directions_railway,
                  fallbackIconColor: AppColors.slateGrey,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    normalSource.isEmpty ? 'Source' : normalSource,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: normalSource.isEmpty
                          ? AppColors.chipBorderGrey
                          : AppColors.darkBlueText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 14),

            // Divider Line
            const Padding(
              padding: EdgeInsets.only(right: 48.0),
              child: Divider(
                color: AppColors.borderLight,
                height: 1,
                thickness: 1,
              ),
            ),
            const SizedBox(height: 14),

            // To
            const Text(
              'To',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppColors.labelBlue,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                AppAssets.safeImage(
                  AppAssets.trainEngineIcon,
                  width: 22,
                  height: 22,
                  fallbackIcon: Icons.directions_railway,
                  fallbackIconColor: AppColors.slateGrey,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    normalDestination.isEmpty
                        ? 'Destination'
                        : normalDestination,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: normalDestination.isEmpty
                          ? AppColors.chipBorderGrey
                          : AppColors.darkBlueText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ],
        ),

        // Circular Swap Button
        Positioned(
          right: 0,
          child: InkWell(
            onTap: _swapNormalStations,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.swapButtonBg,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.swap_vert,
                  color: AppColors.swapIconBlue,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// C. Season Tab Content (Screenshot 2)
  Widget _buildSeasonTabContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1 - "Type" Container (ISSUE | RENEW)
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6F8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderLight, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Type',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.labelGrey,
                ),
              ),
              Row(
                children: [
                  // ISSUE Pill
                  InkWell(
                    onTap: () {
                      setState(() {
                        seasonType = 'ISSUE';
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 7.0,
                      ),
                      decoration: BoxDecoration(
                        color: seasonType == 'ISSUE'
                            ? AppColors.languageBlue
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: seasonType == 'ISSUE'
                            ? null
                            : Border.all(
                                color: AppColors.chipBorderGrey,
                                width: 1,
                              ),
                      ),
                      child: Text(
                        'ISSUE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: seasonType == 'ISSUE'
                              ? Colors.white
                              : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // RENEW Pill
                  InkWell(
                    onTap: () {
                      setState(() {
                        seasonType = 'RENEW';
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 7.0,
                      ),
                      decoration: BoxDecoration(
                        color: seasonType == 'RENEW'
                            ? AppColors.languageBlue
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: seasonType == 'RENEW'
                            ? null
                            : Border.all(
                                color: AppColors.chipBorderGrey,
                                width: 1,
                              ),
                      ),
                      child: Text(
                        'RENEW',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: seasonType == 'RENEW'
                              ? Colors.white
                              : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Row 2 - "Booking For" (Self | Others)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Booking For',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.labelGrey,
                ),
              ),
              Row(
                children: [
                  // Self Pill
                  InkWell(
                    onTap: () {
                      setState(() {
                        bookingFor = 'Self';
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 95,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: bookingFor == 'Self'
                            ? AppColors.languageBlue
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: bookingFor == 'Self'
                            ? null
                            : Border.all(
                                color: AppColors.chipBorderGrey,
                                width: 1,
                              ),
                      ),
                      child: Text(
                        'Self',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: bookingFor == 'Self'
                              ? Colors.white
                              : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Others Pill
                  InkWell(
                    onTap: () {
                      setState(() {
                        bookingFor = 'Others';
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 85,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: bookingFor == 'Others'
                            ? AppColors.languageBlue
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: bookingFor == 'Others'
                            ? null
                            : Border.all(
                                color: AppColors.chipBorderGrey,
                                width: 1,
                              ),
                      ),
                      child: Text(
                        'Others',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: bookingFor == 'Others'
                              ? Colors.white
                              : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // From Section (Season)
        const Text(
          'From',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: AppColors.labelBlue,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            AppAssets.safeImage(
              AppAssets.trainEngineIcon,
              width: 22,
              height: 22,
              fallbackIcon: Icons.directions_railway,
              fallbackIconColor: AppColors.slateGrey,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                seasonSource.isEmpty ? 'Source' : seasonSource,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: seasonSource.isEmpty
                      ? AppColors.chipBorderGrey
                      : AppColors.darkBlueText,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(
          color: AppColors.borderLight,
          height: 1,
          thickness: 1,
        ),
        const SizedBox(height: 14),

        // To Section (Season)
        const Text(
          'To',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: AppColors.labelBlue,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            AppAssets.safeImage(
              AppAssets.trainEngineIcon,
              width: 22,
              height: 22,
              fallbackIcon: Icons.directions_railway,
              fallbackIconColor: AppColors.slateGrey,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                seasonDestination.isEmpty ? 'Destination' : seasonDestination,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: seasonDestination.isEmpty
                      ? AppColors.chipBorderGrey
                      : AppColors.darkBlueText,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(
          color: AppColors.borderLight,
          height: 1,
          thickness: 1,
        ),
        const SizedBox(height: 20),

        // Date Selection Pills Row ("Next Date" | "Current Date")
        Row(
          children: [
            // Next Date Pill
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isNextDate = true;
                  });
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isNextDate
                        ? AppColors.chipSelectedBg
                        : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isNextDate
                          ? AppColors.languageBlue
                          : AppColors.chipBorderGrey,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Next Date',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight:
                          isNextDate ? FontWeight.w700 : FontWeight.w600,
                      color: isNextDate
                          ? AppColors.languageBlue
                          : AppColors.labelGrey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Current Date Pill
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isNextDate = false;
                  });
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: !isNextDate
                        ? AppColors.chipSelectedBg
                        : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: !isNextDate
                          ? AppColors.languageBlue
                          : AppColors.chipBorderGrey,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Current Date',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight:
                          !isNextDate ? FontWeight.w700 : FontWeight.w600,
                      color: !isNextDate
                          ? AppColors.languageBlue
                          : AppColors.labelGrey,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Action Button: Proceed To Book
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UnreservedBookingPaymentScreen(
                    sourceStation: seasonSource.isEmpty ? 'SHRIDHAM' : seasonSource,
                    destinationStation:
                        seasonDestination.isEmpty ? 'JABALPUR' : seasonDestination,
                    isSeasonTicket: true,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.languageBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text(
              'Proceed To Book',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  /// 3. Bottom Section - Recent Searches
  Widget _buildRecentSearchesSection(BuildContext context) {
    final recentList =
        isSeasonTab ? seasonRecentSearches : normalRecentSearches;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Searches',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.headingNavy,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: recentList.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = recentList[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (!isSeasonTab) {
                        normalSource = item.from;
                        normalDestination = item.to;
                      } else {
                        seasonSource = item.from;
                        seasonDestination = item.to;
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 175,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.recentCardBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.from,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.recentCardText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        const Icon(
                          Icons.swap_calls_rounded,
                          color: AppColors.languageBlue,
                          size: 18,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.to,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.recentCardText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UnreservedRecentSearch {
  final String from;
  final String to;

  const _UnreservedRecentSearch({
    required this.from,
    required this.to,
  });
}
