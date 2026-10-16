import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../../core/app_state.dart';

class BookingDetailsScreen extends StatefulWidget {
  final BookedTicket? ticket;

  const BookingDetailsScreen({super.key, this.ticket});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  BookedTicket get _ticket => widget.ticket ?? AppState.instance.latestTicket;
  // 4 minutes 51 seconds countdown timer (291 seconds)
  int _secondsRemaining = 4 * 60 + 51;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int minutes = _secondsRemaining ~/ 60;
    final int seconds = _secondsRemaining % 60;
    final String minutesStr = minutes.toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Greeting Text
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 14.0,
                bottom: 12.0,
              ),
              child: Text(
                'Thank You ${_ticket.passengerFirstName}, Happy Journey !',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ),

            // 2. Main Ticket Card Container (with Top & Bottom Purple Caps)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Column(
                children: [
                  // Top Lavender-Purple Accent Bar
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.ticketTopPurple,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                  ),

                  // A. Dark Dynamic Preview Header Box (195px height)
                  _buildDynamicPreviewHeader(minutesStr, seconds),

                  // B. White Ticket Details Body
                  _buildTicketDetailsBody(),

                  // C. Ticket Cutout Notches & Dashed Divider Line
                  _buildTicketNotchDivider(),

                  // D. Passenger Info Section
                  _buildPassengerInfoSection(),

                  // Bottom Lavender-Purple Accent Bar
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.ticketBottomPurple,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. Red Warning Note Box
            Padding(
              padding: const EdgeInsets.only(
                left: 14.0,
                right: 14.0,
                top: 14.0,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warningPinkBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Note: This ticket is non refundable. Ticket is stored locally on the device. Please do not change your handset or perform factory reset.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.warningRedText,
                    height: 1.35,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // 4. Upgrade to Superfast Button
            Padding(
              padding: const EdgeInsets.only(
                left: 14.0,
                right: 14.0,
                top: 14.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Upgrade to Superfast tapped'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.languageBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: const Text(
                    'Upgrade to Superfast',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // 5. Dense QR Code Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 22.0),
              child: Center(
                child: Container(
                  width: 210,
                  height: 210,
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.white,
                  child: CustomPaint(
                    size: const Size(194, 194),
                    painter: _DenseQrPainter(),
                  ),
                ),
              ),
            ),

            // 6. Bottom "Do you know?" Footer Section
            _buildDoYouKnowFooter(),
          ],
        ),
      ),
    );
  }

  /// Top AppBar (Solid Blue #0066FF, height 64)
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: SafeArea(
        child: Container(
          height: 64,
          color: AppColors.languageBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              // Circular Outlined Back Button (38x38)
              InkWell(
                onTap: () => Navigator.pop(context),
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

              // Title Column
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Booking Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Mobile: 9584584988',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Right Action: Receipt Icon
              const Icon(
                Icons.receipt_long,
                color: Colors.white,
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A. Dark Dynamic Preview Header Box (height: 195)
  Widget _buildDynamicPreviewHeader(String minutesStr, int seconds) {
    return Container(
      height: 195,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF1C1E21),
        image: DecorationImage(
          image: AssetImage(AppAssets.ticketBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Left Vertical Strip: 'INDIAN RAILWAYS'
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 34,
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'INDIAN RAILWAYS',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade400,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
                CustomPaint(
                  size: const Size(1, double.infinity),
                  painter: _VerticalDashedLinePainter(),
                ),
              ],
            ),
          ),

          // Right Vertical Strip: 'भारतीय रेल'
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 34,
            child: Row(
              children: [
                CustomPaint(
                  size: const Size(1, double.infinity),
                  painter: _VerticalDashedLinePainter(),
                ),
                Expanded(
                  child: Center(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'भारतीय रेल',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Center Dynamic Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top text
                const Text(
                  'Dynamic preview will close in',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),

                // Live Rolling Timer (Minutes static red + rolling seconds odometer)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$minutesStr:',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: AppColors.timerRed,
                        height: 1.0,
                        letterSpacing: -1.0,
                      ),
                    ),
                    _RollingOdometerSeconds(seconds: seconds),
                  ],
                ),
                const SizedBox(height: 6),

                // Ticket Booking Date & Time label
                const Text(
                  'Ticket Booking Date & Time',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFCBD5E1),
                  ),
                ),
                const SizedBox(height: 4),

                // Orange Date-Time
                Text(
                  _ticket.bookingDateTimeText,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.bookingDateTimeOrange,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),

                // Code
                Text(
                  _ticket.secretCode,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),

                // Ticket is Non-Transferable
                const Text(
                  'Ticket is Non-Transferable',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFE2E8F0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// B. White Ticket Details Body
  Widget _buildTicketDetailsBody() {
    return Container(
      color: AppColors.bookingDetailsBodyBg,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Season Ticket & ACTIVE Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _ticket.isSeasonTicket ? 'Season Ticket' : 'Journey Ticket',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _ticket.utsNumber,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: AppColors.darkBlueText,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.activeGreenBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '• ACTIVE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.activeGreenText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Row 2: Source & Destination
          _buildInfoRow('Source', _ticket.sourceStation, 'Destination', _ticket.destinationStation),
          const SizedBox(height: 14),

          // Row 3: Distance & Booked on
          _buildInfoRow('Distance', '${_ticket.distanceKm} km', 'Booked on', _ticket.bookedOnNumeric),
          const SizedBox(height: 14),

          // Row 4: Ticket Type & Train Types
          _buildInfoRow(
            'Ticket Type',
            _ticket.ticketType,
            'Train Types',
            _ticket.trainType,
          ),
          const SizedBox(height: 14),

          // Row 5: Class & Fare
          _buildInfoRow('Class', _ticket.ticketClass, 'Fare', _ticket.fare.toStringAsFixed(2)),
          const SizedBox(height: 14),

          // Row 6: Valid From & Valid Upto
          _buildInfoRow('Valid From', _ticket.validFrom, 'Valid Upto', _ticket.validUpto),
          const SizedBox(height: 14),

          // Via Box
          Container(
            height: 38,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: const Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.alt_route,
                  size: 15,
                  color: Color(0xFF475569),
                ),
                SizedBox(width: 6),
                Text(
                  'Via: ------',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBlueText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String leftLabel,
    String leftValue,
    String rightLabel,
    String rightValue,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              leftLabel,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              leftValue,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkBlueText,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              rightLabel,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              rightValue,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkBlueText,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// C. Ticket Cutout Notches & Dashed Divider Line
  Widget _buildTicketNotchDivider() {
    return Container(
      color: AppColors.bookingDetailsBodyBg,
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Horizontal Dashed Line
          CustomPaint(
            size: const Size(double.infinity, 1),
            painter: _HorizontalDashedLinePainter(),
          ),

          // Left Inward Semi-Circle Notch
          Positioned(
            left: 0,
            child: Container(
              width: 12,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFF4F5F7),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
          ),

          // Right Inward Semi-Circle Notch
          Positioned(
            right: 0,
            child: Container(
              width: 12,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFF4F5F7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// D. Passenger Info Section
  Widget _buildPassengerInfoSection() {
    return Container(
      color: AppColors.bookingDetailsBodyBg,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name & Age
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _ticket.passengerFirstName,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: AppColors.darkBlueText,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Age',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${_ticket.passengerAge} years',
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: AppColors.darkBlueText,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ID Type* & ID Number
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ID Type*',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _ticket.idType,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: AppColors.darkBlueText,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'ID Number',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _ticket.idNumber,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: AppColors.darkBlueText,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 6. Bottom "Do you know?" Footer Section
  Widget _buildDoYouKnowFooter() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFEAECEF),
            width: 8.0,
          ),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Do you know?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2B2B2B),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'IR recovers only 57% of cost of travel on an average.',
            style: TextStyle(
              fontSize: 13.5,
              color: Color(0xFF555555),
              height: 1.4,
            ),
          ),
          SizedBox(height: 14),
          Text(
            'This ticket is booked on a personal user ID.\nIt\'s sale/purchase is an offence u/s 143 of the\nRailways Act, 1989',
            style: TextStyle(
              fontSize: 13.5,
              color: Color(0xFF555555),
              height: 1.4,
            ),
          ),
          SizedBox(height: 14),
          Text(
            'For enquiry and integrated railway helpline,\nplease dial 139.',
            style: TextStyle(
              fontSize: 13.5,
              color: Color(0xFF555555),
              height: 1.4,
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// Rolling Odometer for the seconds digits (rolling up from bottom to top)
class _RollingOdometerSeconds extends StatefulWidget {
  final int seconds;

  const _RollingOdometerSeconds({required this.seconds});

  @override
  State<_RollingOdometerSeconds> createState() =>
      _RollingOdometerSecondsState();
}

class _RollingOdometerSecondsState extends State<_RollingOdometerSeconds>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _oldSeconds = 51;
  int _currentSeconds = 51;

  @override
  void initState() {
    super.initState();
    _currentSeconds = widget.seconds;
    _oldSeconds = widget.seconds;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void didUpdateWidget(covariant _RollingOdometerSeconds oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seconds != widget.seconds) {
      _oldSeconds = oldWidget.seconds;
      _currentSeconds = widget.seconds;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w800,
      color: AppColors.timerRed,
      height: 1.0,
      letterSpacing: -1.0,
    );

    final oldStr = _oldSeconds.toString().padLeft(2, '0');
    final curStr = _currentSeconds.toString().padLeft(2, '0');

    return ClipRect(
      child: SizedBox(
        height: 40,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final double value = _animation.value;
            // Outgoing slides up: 0 -> -40
            final double outgoingTop = -value * 40;
            // Incoming slides in from bottom: 40 -> 0
            final double incomingTop = (1.0 - value) * 40;

            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  top: outgoingTop,
                  child: Text(oldStr, style: textStyle),
                ),
                Positioned(
                  top: incomingTop,
                  child: Text(curStr, style: textStyle),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Realistic High-Density Version-10 QR Code Matrix Painter
class _DenseQrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    const int modules = 57; // Version 10 size
    final double cellSize = size.width / modules;

    // Draw position detection patterns (3 corners)
    void drawPositionFinder(double startX, double startY) {
      // Outer 7x7 square
      canvas.drawRect(
        Rect.fromLTWH(startX, startY, cellSize * 7, cellSize * 7),
        paint,
      );
      // White inner 5x5 square
      final whitePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromLTWH(
          startX + cellSize,
          startY + cellSize,
          cellSize * 5,
          cellSize * 5,
        ),
        whitePaint,
      );
      // Center solid 3x3 square
      canvas.drawRect(
        Rect.fromLTWH(
          startX + cellSize * 2,
          startY + cellSize * 2,
          cellSize * 3,
          cellSize * 3,
        ),
        paint,
      );
    }

    // Top-Left Finder
    drawPositionFinder(0, 0);
    // Top-Right Finder
    drawPositionFinder((modules - 7) * cellSize, 0);
    // Bottom-Left Finder
    drawPositionFinder(0, (modules - 7) * cellSize);

    // Alignment patterns (at Version 10 standard positions)
    void drawAlignment(double cx, double cy) {
      final whitePaint = Paint()..color = Colors.white;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(cx, cy),
          width: cellSize * 5,
          height: cellSize * 5,
        ),
        paint,
      );
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(cx, cy),
          width: cellSize * 3,
          height: cellSize * 3,
        ),
        whitePaint,
      );
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(cx, cy),
          width: cellSize,
          height: cellSize,
        ),
        paint,
      );
    }

    drawAlignment(cellSize * 30, cellSize * 30);
    drawAlignment(cellSize * 30, cellSize * (modules - 9));
    drawAlignment(cellSize * (modules - 9), cellSize * 30);

    // Timing patterns
    for (int i = 8; i < modules - 8; i += 2) {
      canvas.drawRect(
        Rect.fromLTWH(i * cellSize, 6 * cellSize, cellSize, cellSize),
        paint,
      );
      canvas.drawRect(
        Rect.fromLTWH(6 * cellSize, i * cellSize, cellSize, cellSize),
        paint,
      );
    }

    // Deterministic pseudo-random dense data modules
    int seed = 0x9E3779B9;
    int nextRand() {
      seed = (seed ^ (seed << 13)) & 0xFFFFFFFF;
      seed = (seed ^ (seed >> 17)) & 0xFFFFFFFF;
      seed = (seed ^ (seed << 5)) & 0xFFFFFFFF;
      return seed;
    }

    for (int r = 0; r < modules; r++) {
      for (int c = 0; c < modules; c++) {
        // Skip finder areas
        if ((r < 8 && c < 8) ||
            (r < 8 && c >= modules - 8) ||
            (r >= modules - 8 && c < 8)) {
          continue;
        }
        // Skip timing lines
        if (r == 6 || c == 6) continue;

        if ((nextRand() % 100) < 48) {
          canvas.drawRect(
            Rect.fromLTWH(c * cellSize, r * cellSize, cellSize, cellSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _VerticalDashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 1.0;

    double y = 0;
    const double dashWidth = 5.0;
    const double dashSpace = 4.0;

    while (y < size.height) {
      canvas.drawLine(
        Offset(0, y),
        Offset(0, y + dashWidth),
        paint,
      );
      y += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HorizontalDashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1.0;

    double x = 14;
    final endX = size.width - 14;
    const double dashWidth = 4.0;
    const double dashSpace = 3.0;

    while (x < endX) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset(x + dashWidth, size.height / 2),
        paint,
      );
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
