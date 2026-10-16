import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../../core/app_state.dart';
import 'booking_details_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const MyBookingsScreen({
    super.key,
    this.onBackToHome,
  });

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  // Selected Filter Index: 0 = Upcoming, 1 = Completed, 2 = Cancelled, 3 = All
  int selectedFilterIndex = 0;

  final List<_FilterTabInfo> filterTabs = const [
    _FilterTabInfo(
      title: 'Upcoming',
      count: 1,
      assetPath: AppAssets.upcomingTicketTab,
      fallbackIcon: Icons.confirmation_number_outlined,
    ),
    _FilterTabInfo(
      title: 'Completed',
      count: 0,
      assetPath: AppAssets.completedTicketTab,
      fallbackIcon: Icons.task_alt_rounded,
    ),
    _FilterTabInfo(
      title: 'Cancelled',
      count: 0,
      assetPath: AppAssets.cancelledTicketTab,
      fallbackIcon: Icons.cancel_outlined,
    ),
    _FilterTabInfo(
      title: 'All',
      count: 1,
      assetPath: AppAssets.allTicketTab,
      fallbackIcon: Icons.receipt_long_outlined,
    ),
  ];

  void _handleBack(BuildContext context) {
    if (widget.onBackToHome != null) {
      widget.onBackToHome!();
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final currentTab = filterTabs[selectedFilterIndex];
        final tickets = AppState.instance.activeTickets;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(context),
          body: Column(
            children: [
              // Sub-Header: "Upcoming (N)" + Refresh Icon
              _buildSubHeader(currentTab, tickets.length),

              // Main Scrollable Area with Custom Ticket Card
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                  child: (selectedFilterIndex == 0 || selectedFilterIndex == 3)
                      ? (tickets.isEmpty
                          ? _buildEmptyState(currentTab.title)
                          : Column(
                              children: tickets
                                  .map((t) => Padding(
                                        padding: const EdgeInsets.only(bottom: 14.0),
                                        child: _buildTicketCard(context, t),
                                      ))
                                  .toList(),
                            ))
                      : _buildEmptyState(currentTab.title),
                ),
              ),

              // Bottom Filter Bar (4 Status Tabs)
              _buildBottomFilterBar(),
            ],
          ),
        );
      },
    );
  }

  /// 1. Top AppBar (Solid Blue #0066FF, height 60)
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: SafeArea(
        child: Container(
          height: 60,
          color: AppColors.languageBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              // Circular Outlined Back Button (38x38, 1.2px white70 border)
              InkWell(
                onTap: () => _handleBack(context),
                borderRadius: BorderRadius.circular(19),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white70,
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
              const SizedBox(width: 14),

              // Title: 'My Bookings'
              const Text(
                'My Bookings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),

              const Spacer(),

              // Right Action: Sort Filter Icon
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sort / Filter options'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: Center(
                    child: AppAssets.safeImage(
                      AppAssets.sortFilter,
                      width: 24,
                      height: 24,
                      color: Colors.white,
                      fallbackIcon: Icons.sort_rounded,
                      fallbackIconColor: Colors.white,
                      fallbackIconSize: 24,
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

  /// 2. Sub-Header Row ("Upcoming (N)" + Refresh Icon)
  Widget _buildSubHeader(_FilterTabInfo currentTab, [int? count]) {
    final displayCount = count ?? currentTab.count;
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 14.0,
        bottom: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Empty placeholder for centering
          const SizedBox(width: 24),

          // Center Text: 'Upcoming (N)'
          Text(
            '${currentTab.title} ($displayCount)',
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: AppColors.bookingAmber,
            ),
          ),

          // Right End: Refresh Icon
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Refreshing bookings...'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 24,
              height: 24,
              child: Center(
                child: AppAssets.safeImage(
                  AppAssets.refreshIcon,
                  width: 20,
                  height: 20,
                  fallbackIcon: Icons.sync,
                  fallbackIconColor: AppColors.labelGrey,
                  fallbackIconSize: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Custom Ticket Card with Left & Right Semi-Circle Notches
  Widget _buildTicketCard(BuildContext context, BookedTicket ticket) {
    return CustomPaint(
      painter: _TicketCardPainter(
        notchCenterYFromBottom: 48.0,
        notchRadius: 14.0,
        borderRadius: 14.0,
        borderColor: AppColors.ticketBorderOrange,
        fillColor: AppColors.ticketCardBg,
        dashColor: AppColors.ticketDashedDivider,
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 14.0, left: 16.0, right: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Unreserved Badge & UTS Number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Unreserved Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 5.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.unreservedBadgeBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Unreserved',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.unreservedBadgePurple,
                    ),
                  ),
                ),

                // UTS Number
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'UTS: ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.labelGrey,
                        ),
                      ),
                      TextSpan(
                        text: ticket.utsNumber,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkBlueText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Row 2: Ticket Type & Booking Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ticket Type',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      ticket.ticketType,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.darkBlueText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Booking Date',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      ticket.bookingDateText,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.darkBlueText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Row 3: Stations & Distance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ticket.sourceStation,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlueText,
                  ),
                ),
                Text(
                  '— ${ticket.distanceKm} km —',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                Text(
                  ticket.destinationStation,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlueText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24), // Gap leading into the dashed divider line

            // Bottom Action Row (Height 48)
            SizedBox(
              height: 48,
              child: Row(
                children: [
                  // Book Again
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Booking again for ${ticket.sourceStation} to ${ticket.destinationStation}...'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Center(
                        child: Text(
                          'Book Again',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.labelGrey,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Vertical Separator
                  Container(
                    width: 1,
                    height: 18,
                    color: AppColors.chipBorderGrey,
                  ),

                  // View Details
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingDetailsScreen(ticket: ticket),
                          ),
                        );
                      },
                      child: const Center(
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.languageBlue,
                          ),
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
    );
  }

  Widget _buildEmptyState(String tabTitle) {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.confirmation_number_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No $tabTitle Bookings Found',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.headingNavy,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your booked tickets will appear here',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.labelGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 4. Bottom Filter Bar (4 Ticket Status Tabs: Upcoming, Completed, Cancelled, All)
  Widget _buildBottomFilterBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bookingBottomBarBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        border: Border(
          top: BorderSide(
            color: Color(0xFFCBD5E1),
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 82,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            children: List.generate(filterTabs.length, (index) {
              final tab = filterTabs[index];
              final bool isSelected = selectedFilterIndex == index;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedFilterIndex = index;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.bookingActiveTabBg
                            : AppColors.bookingInactiveTabBg,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected
                            ? const [
                                BoxShadow(
                                  color: Color(0x14000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppAssets.safeImage(
                            tab.assetPath,
                            width: isSelected ? 28 : 26,
                            height: isSelected ? 28 : 26,
                            fallbackIcon: tab.fallbackIcon,
                            fallbackIconColor: isSelected
                                ? const Color(0xFFF59E0B)
                                : AppColors.labelGrey,
                            fallbackIconSize: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tab.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? const Color(0xFFF59E0B)
                                  : AppColors.labelGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

/// CustomPainter to draw ticket card with curved border and left/right semi-circle notches
class _TicketCardPainter extends CustomPainter {
  final double notchCenterYFromBottom;
  final double notchRadius;
  final double borderRadius;
  final Color borderColor;
  final Color fillColor;
  final Color dashColor;

  _TicketCardPainter({
    required this.notchCenterYFromBottom,
    required this.notchRadius,
    required this.borderRadius,
    required this.borderColor,
    required this.fillColor,
    required this.dashColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double notchY = size.height - notchCenterYFromBottom;

    final path = Path();

    // 1. Start top-left corner
    path.moveTo(borderRadius, 0);

    // Top edge
    path.lineTo(size.width - borderRadius, 0);

    // Top-right corner
    path.arcToPoint(
      Offset(size.width, borderRadius),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );

    // Right edge down to top of right notch
    path.lineTo(size.width, notchY - notchRadius);

    // Right Inward Semi-Circle Notch
    path.arcToPoint(
      Offset(size.width, notchY + notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    // Right edge down to bottom-right corner
    path.lineTo(size.width, size.height - borderRadius);

    // Bottom-right corner
    path.arcToPoint(
      Offset(size.width - borderRadius, size.height),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );

    // Bottom edge
    path.lineTo(borderRadius, size.height);

    // Bottom-left corner
    path.arcToPoint(
      Offset(0, size.height - borderRadius),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );

    // Left edge up to bottom of left notch
    path.lineTo(0, notchY + notchRadius);

    // Left Inward Semi-Circle Notch
    path.arcToPoint(
      Offset(0, notchY - notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    // Left edge up to top-left corner
    path.lineTo(0, borderRadius);

    // Top-left corner
    path.arcToPoint(
      Offset(borderRadius, 0),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );

    path.close();

    // Fill background
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Stroke outline
    final strokePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(path, strokePaint);

    // Draw dashed horizontal line between the two notches
    final dashPaint = Paint()
      ..color = dashColor
      ..strokeWidth = 1.0;

    double startX = notchRadius + 4;
    final double endX = size.width - notchRadius - 4;
    const double dashWidth = 4.0;
    const double dashSpace = 3.0;

    while (startX < endX) {
      canvas.drawLine(
        Offset(startX, notchY),
        Offset(math.min(startX + dashWidth, endX), notchY),
        dashPaint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _TicketCardPainter oldDelegate) {
    return oldDelegate.notchCenterYFromBottom != notchCenterYFromBottom ||
        oldDelegate.notchRadius != notchRadius ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.fillColor != fillColor;
  }
}

class _FilterTabInfo {
  final String title;
  final int count;
  final String assetPath;
  final IconData fallbackIcon;

  const _FilterTabInfo({
    required this.title,
    required this.count,
    required this.assetPath,
    required this.fallbackIcon,
  });
}
