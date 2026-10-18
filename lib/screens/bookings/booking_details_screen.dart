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
      backgroundColor: const Color(0xFFF3F5F8),
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

                  // Progress bar: 5 minutes (300s) left→right lavender fill
                  ClipRRect(
                    child: LinearProgressIndicator(
                      value: ((300 - _secondsRemaining) / 300.0).clamp(0.0, 1.0),
                      backgroundColor: Colors.transparent,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF9FA8DA),
                      ),
                      minHeight: 4,
                    ),
                  ),

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

            // 5. Full-Width White QR Code Section
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 22.0),
              child: const Center(
                child: CustomPaint(
                  size: Size(220, 220),
                  painter: _DenseQrPainter(gridSize: 61),
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
              Column(
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
                    'Mobile: ${AppState.instance.mobileNumber.isEmpty ? "N/A" : AppState.instance.mobileNumber}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Right Action: Zig-Zag Receipt Icon
              const CustomPaint(
                size: Size(22, 26),
                painter: _ZigZagReceiptPainter(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A. Dark Dynamic Preview Header Box (height: 208)
  Widget _buildDynamicPreviewHeader(String minutesStr, int seconds) {
    return Container(
      height: 208,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1C),
        image: DecorationImage(
          image: AssetImage(AppAssets.ticketBackground),
          fit: BoxFit.fill,
          colorFilter: ColorFilter.mode(
            Color(0xFF1A1A1C),
            BlendMode.color,
          ),
          opacity: 0.18,
        ),
      ),
      child: Stack(
        children: [
          // Left Vertical Strip: 'INDIAN RAILWAYS'
          Positioned(
            left: 6,
            top: 10,
            bottom: 10,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    'INDIAN RAILWAYS',
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: Color(0xFFB0B3B8),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                CustomPaint(
                  size: const Size(1.2, double.infinity),
                  painter: const _VerticalDashedLinePainter(
                    dashCount: 25,
                    dashHeight: 4.5,
                    dashWidth: 1.2,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),

          // Right Vertical Strip: 'भारतीय रेल'
          Positioned(
            right: 6,
            top: 0,
            bottom: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomPaint(
                  size: const Size(1.2, double.infinity),
                  painter: const _VerticalDashedLinePainter(
                    dashCount: 25,
                    dashHeight: 4.5,
                    dashWidth: 1.2,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(width: 6),
                const RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    'भारतीय रेल',
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 20.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: Color(0xFFB0B3B8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Center Dynamic Content
          Positioned.fill(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Top text
                    const Text(
                      'Dynamic preview will close in',
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 15.8,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Centered Live Rolling Countdown Timer
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '$minutesStr:',
                            style: const TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 47,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFFF2424),
                              height: 1.0,
                            ),
                          ),
                          _RollingOdometerSeconds(seconds: seconds),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Ticket Booking Date & Time label
                    const Text(
                      'Ticket Booking Date & Time',
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 13.8,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFD1D5DB),
                      ),
                    ),
                    const SizedBox(height: 3),

                    // Orange Date & Time with FittedBox
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _ticket.bookingDateTimeText,
                        style: const TextStyle(
                          fontFamily: 'NotoSans',
                          fontSize: 25.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFFF8C00),
                          letterSpacing: 0.3,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),

                    // Secret Code
                    Text(
                      _ticket.secretCode,
                      style: const TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),

                    // Ticket is Non-Transferable
                    const Text(
                      'Ticket is Non-Transferable',
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 14.2,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE5E7EB),
                      ),
                    ),
                  ],
                ),
              ),
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
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Row(
              children: [
                RotatedBox(
                  quarterTurns: 1,
                  child: Icon(
                    Icons.alt_route,
                    size: 17,
                    color: Color(0xFF64748B),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Via: ------',
                  style: TextStyle(
                    fontFamily: 'NotoSans',
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
      height: 22,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Horizontal Dashed Line
          CustomPaint(
            size: const Size(double.infinity, 1.2),
            painter: const _HorizontalDashedLinePainter(
              dashWidth: 3.5,
              dashHeight: 1.2,
              dashSpace: 3.0,
              color: Color(0xFFCBD5E1),
            ),
          ),

          // Left Inward Semi-Circle Notch
          Positioned(
            left: -11,
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F5F8),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Right Inward Semi-Circle Notch
          Positioned(
            right: -11,
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F5F8),
                shape: BoxShape.circle,
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
      color: const Color(0xFFF3F5F8),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Do you know?',
            style: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'IR recovers only 57% of cost of travel on an average.',
            style: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 13.8,
              fontWeight: FontWeight.w400,
              color: Color(0xFF475569),
              height: 1.4,
            ),
          ),
          SizedBox(height: 14),
          Text(
            'This ticket is booked on a personal user ID.\nIt\'s sale/purchase is an offence u/s 143 of the\nRailways Act, 1989',
            style: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 13.8,
              fontWeight: FontWeight.w400,
              color: Color(0xFF475569),
              height: 1.4,
            ),
          ),
          SizedBox(height: 14),
          Text(
            'For enquiry and integrated railway helpline,\nplease dial 139.',
            style: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 13.8,
              fontWeight: FontWeight.w400,
              color: Color(0xFF475569),
              height: 1.4,
            ),
          ),
          SizedBox(height: 28),
        ],
      ),
    );
  }
}

/// Rolling Odometer for the seconds digits (downfall transition from top to bottom)
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
      value: 1.0,
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
      fontFamily: 'NotoSans',
      fontSize: 47,
      fontWeight: FontWeight.w800,
      color: Color(0xFFFF2424),
      height: 1.0,
    );

    final oldStr = _oldSeconds.toString().padLeft(2, '0');
    final curStr = _currentSeconds.toString().padLeft(2, '0');

    return SizedBox(
      width: 68,
      height: 74,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final double t = _animation.value;
            // Outgoing falls down from center (0) to bottom (+44)
            final double outgoingTop = 44.0 * t;
            // Incoming slides in from top (-44) down to center (0)
            final double incomingTop = -44.0 * (1.0 - t);

            return Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: Offset(0, outgoingTop),
                  child: Text(oldStr, style: textStyle),
                ),
                Transform.translate(
                  offset: Offset(0, incomingTop),
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

/// Realistic High-Density QR Code Matrix Painter (default 61x61)
class _DenseQrPainter extends CustomPainter {
  final int gridSize;

  const _DenseQrPainter({this.gridSize = 61});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final int modules = gridSize;
    final double cellSize = size.width / modules;

    // Draw position detection patterns (3 corners)
    void drawPositionFinder(double startX, double startY) {
      // Outer 7x7 square
      canvas.drawRect(
        Rect.fromLTWH(startX, startY, cellSize * 7, cellSize * 7),
        paint,
      );
      // White inner 5x5 square
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

    // Alignment patterns (5x5)
    void drawAlignment(double cx, double cy) {
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

    final List<int> alignCoords = [28, modules - 9];
    for (final r in alignCoords) {
      for (final c in alignCoords) {
        drawAlignment(c * cellSize, r * cellSize);
      }
    }

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

        // Skip alignment pattern areas
        bool inAlign = false;
        for (final ar in alignCoords) {
          for (final ac in alignCoords) {
            if ((r - ar).abs() <= 2 && (c - ac).abs() <= 2) {
              inAlign = true;
              break;
            }
          }
          if (inAlign) break;
        }
        if (inAlign) continue;

        if ((nextRand() % 100) < 50) {
          canvas.drawRect(
            Rect.fromLTWH(c * cellSize, r * cellSize, cellSize, cellSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DenseQrPainter oldDelegate) =>
      oldDelegate.gridSize != gridSize;
}

class _VerticalDashedLinePainter extends CustomPainter {
  final int dashCount;
  final double dashHeight;
  final double dashWidth;
  final Color color;

  const _VerticalDashedLinePainter({
    this.dashCount = 25,
    this.dashHeight = 4.5,
    this.dashWidth = 1.2,
    this.color = const Color(0xFF9CA3AF),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = dashWidth;

    if (dashCount > 0 && size.height > 0) {
      final double totalGap = size.height - (dashCount * dashHeight);
      final double dashGap = dashCount > 1
          ? (totalGap / (dashCount - 1)).clamp(1.0, 10.0)
          : 4.0;
      double y = 0;
      for (int i = 0; i < dashCount; i++) {
        canvas.drawLine(
          Offset(0, y),
          Offset(0, y + dashHeight),
          paint,
        );
        y += dashHeight + dashGap;
        if (y >= size.height) break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _VerticalDashedLinePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.dashCount != dashCount ||
      oldDelegate.dashHeight != dashHeight ||
      oldDelegate.dashWidth != dashWidth;
}

class _HorizontalDashedLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashHeight;
  final double dashSpace;
  final Color color;

  const _HorizontalDashedLinePainter({
    this.dashWidth = 3.5,
    this.dashHeight = 1.2,
    this.dashSpace = 3.0,
    this.color = const Color(0xFFCBD5E1),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = dashHeight;

    double x = 16.0;
    final endX = size.width - 16.0;

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
  bool shouldRepaint(covariant _HorizontalDashedLinePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.dashWidth != dashWidth ||
      oldDelegate.dashHeight != dashHeight ||
      oldDelegate.dashSpace != dashSpace;
}

/// Custom flat white Zig-Zag Ticket/Receipt Icon (Size: 22, 26)
/// 4 small triangular zig-zag teeth on top edge, 4 along bottom edge.
/// 3 horizontal blue lines (#0066FF, strokeWidth: 1.8), each with tiny dot on left and line on right.
class _ZigZagReceiptPainter extends CustomPainter {
  const _ZigZagReceiptPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const double w = 22.0;
    const double h = 26.0;
    const int teeth = 4;
    const double toothWidth = w / teeth; // 5.5
    const double toothDepth = 2.0;

    final path = Path();
    // Start at top-left base of teeth
    path.moveTo(0, toothDepth);

    // 4 teeth on top edge
    for (int i = 0; i < teeth; i++) {
      path.lineTo(i * toothWidth + (toothWidth / 2), 0);
      path.lineTo((i + 1) * toothWidth, toothDepth);
    }

    // Right edge
    path.lineTo(w, h - toothDepth);

    // 4 teeth on bottom edge (right to left)
    for (int i = teeth - 1; i >= 0; i--) {
      path.lineTo(i * toothWidth + (toothWidth / 2), h);
      path.lineTo(i * toothWidth, h - toothDepth);
    }

    // Left edge
    path.lineTo(0, toothDepth);
    path.close();

    canvas.drawPath(path, whitePaint);

    // 3 horizontal blue lines inside
    final blueLinePaint = Paint()
      ..color = const Color(0xFF0066FF)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final blueDotPaint = Paint()
      ..color = const Color(0xFF0066FF)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final List<double> lineYPositions = [8.5, 13.0, 17.5];

    for (final y in lineYPositions) {
      // Tiny dot on the left (at x = 4.5)
      canvas.drawLine(Offset(4.5, y), Offset(4.5, y), blueDotPaint);

      // Line on the right (from x = 8.5 to x = 17.5)
      canvas.drawLine(Offset(8.5, y), Offset(17.5, y), blueLinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
