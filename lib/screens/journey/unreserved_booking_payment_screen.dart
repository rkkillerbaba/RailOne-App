import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_assets.dart';
import '../../core/app_state.dart';
import '../../core/widgets/railone_loader_overlay.dart';
import '../bookings/booking_details_screen.dart';

/// Screen: Unreserved & Season Ticket Booking Customization + UPI/R-Wallet Payment Screen
class UnreservedBookingPaymentScreen extends StatefulWidget {
  final String sourceStation;
  final String destinationStation;
  final bool isSeasonTicket;
  final String? initialTicketType;

  const UnreservedBookingPaymentScreen({
    super.key,
    required this.sourceStation,
    required this.destinationStation,
    this.isSeasonTicket = true,
    this.initialTicketType,
  });

  @override
  State<UnreservedBookingPaymentScreen> createState() =>
      _UnreservedBookingPaymentScreenState();
}

class _UnreservedBookingPaymentScreenState
    extends State<UnreservedBookingPaymentScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _idNumberController;

  late String _idType;
  late String _ticketType; // 'MONTHLY', 'QUARTERLY', etc.
  String _trainType = 'MAIL/EXPRESS';
  String _ticketClass = 'SECOND (II)';
  int _selectedPaymentMode = 1; // 0: R-Wallet, 1: UPI / Online
  int _selectedUpiSubOption = 0; // 0: UPI App, 1: Enter UPI ID, 2: Net Banking

  bool _isLoading = false;
  Timer? _bookingTimer;

  // Pricing map
  static const Map<String, double> _seasonPricing = {
    'MONTHLY': 270.0,
    'QUARTERLY': 730.0,
    'HALF YEARLY': 1400.0,
    'YEARLY': 2650.0,
  };

  static const Map<String, double> _normalPricing = {
    'JOURNEY (ONE WAY)': 35.0,
    'RETURN': 70.0,
  };

  @override
  void initState() {
    super.initState();
    final user = AppState.instance;
    _nameController = TextEditingController(text: user.fullName);
    _ageController = TextEditingController(text: user.age.toString());
    _idNumberController = TextEditingController(text: user.idNumber);
    _idType = user.idType;

    if (widget.isSeasonTicket) {
      _ticketType = widget.initialTicketType ?? 'MONTHLY';
    } else {
      _ticketType = 'JOURNEY (ONE WAY)';
    }
  }

  @override
  void dispose() {
    _bookingTimer?.cancel();
    _nameController.dispose();
    _ageController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  double get _currentFare {
    if (widget.isSeasonTicket) {
      return _seasonPricing[_ticketType] ?? 270.0;
    } else {
      return _normalPricing[_ticketType] ?? 35.0;
    }
  }

  String _cleanStation(String raw, String fallback) {
    if (raw.trim().isEmpty) return fallback;
    return raw.split(',').first.trim().toUpperCase();
  }

  void _onPayAndBook() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter passenger name'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedPaymentMode == 0 &&
        AppState.instance.rWalletBalance < _currentFare) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insufficient R-Wallet balance. Please choose UPI.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // 1.5 seconds loading with RailOneLoaderOverlay
    _bookingTimer = Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      final random = Random();
      final utsNumber = 'X80MEGZ${100 + random.nextInt(900)}';
      final secretCode = 'R${10000 + random.nextInt(90000)}';

      final now = DateTime.now();
      const monthNames = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

      final bookingDateText =
          '${dayNames[now.weekday - 1]}, ${now.day} ${monthNames[now.month - 1]} ${now.year.toString().substring(2)}';
      final bookingDateTimeText =
          '${now.day.toString().padLeft(2, '0')} ${monthNames[now.month - 1]} ${now.year}, ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      final bookedOnNumeric =
          '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      final validFromDate = now;
      final validUptoDate = widget.isSeasonTicket
          ? (_ticketType == 'QUARTERLY'
              ? now.add(const Duration(days: 90))
              : now.add(const Duration(days: 30)))
          : now.add(const Duration(days: 1));

      final validFrom =
          '${validFromDate.day.toString().padLeft(2, '0')}/${validFromDate.month.toString().padLeft(2, '0')}/${validFromDate.year}';
      final validUpto =
          '${validUptoDate.day.toString().padLeft(2, '0')}/${validUptoDate.month.toString().padLeft(2, '0')}/${validUptoDate.year}';

      final newTicket = BookedTicket(
        utsNumber: utsNumber,
        category: widget.isSeasonTicket ? 'Unreserved' : 'Journey',
        isSeasonTicket: widget.isSeasonTicket,
        ticketType: _ticketType,
        sourceStation: _cleanStation(widget.sourceStation, 'SHRIDHAM'),
        destinationStation: _cleanStation(widget.destinationStation, 'JABALPUR'),
        distanceKm: 54,
        bookingDateText: bookingDateText,
        bookingDateTimeText: bookingDateTimeText,
        bookedOnNumeric: bookedOnNumeric,
        trainType: _trainType,
        ticketClass: _ticketClass.split(' ').first,
        fare: _currentFare,
        validFrom: validFrom,
        validUpto: validUpto,
        via: '------',
        passengerFullName: _nameController.text.trim(),
        passengerAge: int.tryParse(_ageController.text.trim()) ?? 27,
        idType: _idType,
        idNumber: _idNumberController.text.trim(),
        secretCode: secretCode,
      );

      // Save to reactive global state
      AppState.instance.addTicket(newTicket);

      // Deduct R-Wallet if used
      if (_selectedPaymentMode == 0) {
        AppState.instance.updateUserProfile(
          rWalletBalance: AppState.instance.rWalletBalance - _currentFare,
        );
      }

      setState(() => _isLoading = false);

      // Open live Booking Details Screen with new ticket
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BookingDetailsScreen(ticket: newTicket),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final cleanSource = _cleanStation(widget.sourceStation, 'SHRIDHAM');
    final cleanDest = _cleanStation(widget.destinationStation, 'JABALPUR');

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: RailOneLoaderOverlay(
          isLoading: _isLoading,
          child: Column(
            children: [
              // Top AppBar
              _buildTopAppBar(context),

              // Scrollable Form & Payment Modes
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Route Summary Card
                      _buildRouteSummaryCard(cleanSource, cleanDest),

                      const SizedBox(height: 14),

                      // Passenger & Ticket Configuration Card
                      _buildConfigurationCard(),

                      const SizedBox(height: 16),

                      // Payment Mode Selection Card
                      _buildPaymentModeCard(),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Bottom Pay Button
              _buildBottomPayBar(),
            ],
          ),
        ),
      ),
    );
  }

  /// Top Solid Blue AppBar
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      color: const Color(0xFF0066FF),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Back Button
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(19),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.7),
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

              // Title
              Expanded(
                child: Text(
                  widget.isSeasonTicket
                      ? 'Book Season Ticket'
                      : 'Book Unreserved Ticket',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Route Summary Header Card
  Widget _buildRouteSummaryCard(String source, String destination) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Source
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'From Station',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF78909C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  source,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0D234A),
                  ),
                ),
              ],
            ),
          ),

          // Arrow with Train Route Icon & Distance
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFDCEBFA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Color(0xFF0066FF),
                  size: 18,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '54 km',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0288D1),
                ),
              ),
            ],
          ),

          // Destination
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'To Station',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF78909C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  destination,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0D234A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Ticket Configuration Form Card
  Widget _buildConfigurationCard() {
    final previewFirstName = _nameController.text.trim().isEmpty
        ? 'Rishi'
        : _nameController.text.trim().split(RegExp(r'\s+')).first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Text(
            'Passenger & Ticket Details',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0288D1),
            ),
          ),
          const SizedBox(height: 14),

          // 1. Passenger Full Name
          const Text(
            'Passenger Full Name',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF78909C),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _nameController,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0D234A),
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF0066FF), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '• Ticket will display first name: $previewFirstName',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0066FF),
            ),
          ),

          const SizedBox(height: 16),

          // 2. Age & ID Type
          Row(
            children: [
              // Age
              SizedBox(
                width: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Age',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF78909C),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D234A),
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xFFCBD5E1)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // ID Type Dropdown
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ID Card Type',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF78909C),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _idType,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF0066FF),
                            size: 20,
                          ),
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D234A),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'Voter ID', child: Text('Voter ID')),
                            DropdownMenuItem(
                                value: 'Aadhaar Card',
                                child: Text('Aadhaar Card')),
                            DropdownMenuItem(
                                value: 'PAN Card', child: Text('PAN Card')),
                            DropdownMenuItem(
                                value: 'Driving Licence',
                                child: Text('Driving Licence')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _idType = val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 3. ID Number
          const Text(
            'ID Card Number',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF78909C),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _idNumberController,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0D234A),
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // 4. Ticket Duration / Type
          Text(
            widget.isSeasonTicket ? 'Season Duration' : 'Journey Type',
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF78909C),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (widget.isSeasonTicket
                    ? _seasonPricing.keys
                    : _normalPricing.keys)
                .map((type) {
              final isSel = _ticketType == type;
              final price = widget.isSeasonTicket
                  ? _seasonPricing[type]
                  : _normalPricing[type];
              return InkWell(
                onTap: () => setState(() => _ticketType = type),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSel ? const Color(0xFFEBF3FF) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSel
                          ? const Color(0xFF0066FF)
                          : const Color(0xFFCBD5E1),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    '$type (₹${price?.toStringAsFixed(0)})',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                      color: isSel
                          ? const Color(0xFF0066FF)
                          : const Color(0xFF334155),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // 5. Train Type
          const Text(
            'Train Type',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF78909C),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: ['ORDINARY', 'MAIL/EXPRESS', 'SUPERFAST'].map((train) {
              final isSel = _trainType == train;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    onTap: () => setState(() => _trainType = train),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      decoration: BoxDecoration(
                        color: isSel ? const Color(0xFFEBF3FF) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSel
                              ? const Color(0xFF0066FF)
                              : const Color(0xFFCBD5E1),
                          width: 1.2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        train,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                          color: isSel
                              ? const Color(0xFF0066FF)
                              : const Color(0xFF334155),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Payment Mode Selection Card
  Widget _buildPaymentModeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Payment Mode',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0D234A),
            ),
          ),
          const SizedBox(height: 14),

          // Option 1: R-Wallet
          InkWell(
            onTap: () => setState(() => _selectedPaymentMode = 0),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _selectedPaymentMode == 0
                    ? const Color(0xFFEBF3FF)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _selectedPaymentMode == 0
                      ? const Color(0xFF0066FF)
                      : const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  AppAssets.safeImage(
                    AppAssets.rWallet,
                    width: 28,
                    height: 28,
                    fallbackIcon: Icons.account_balance_wallet,
                    fallbackIconColor: const Color(0xFF0066FF),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'R-Wallet',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0D234A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Available Balance: ₹ ${AppState.instance.rWalletBalance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF78909C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _selectedPaymentMode == 0
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: _selectedPaymentMode == 0
                        ? const Color(0xFF0066FF)
                        : const Color(0xFFCBD5E1),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Option 2: UPI / Online Payment (Default Selected)
          InkWell(
            onTap: () => setState(() => _selectedPaymentMode = 1),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _selectedPaymentMode == 1
                    ? const Color(0xFFEBF3FF)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _selectedPaymentMode == 1
                      ? const Color(0xFF0066FF)
                      : const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppAssets.safeImage(
                        AppAssets.upiIcon,
                        width: 32,
                        height: 32,
                        fallbackIcon: Icons.qr_code_2,
                        fallbackIconColor: const Color(0xFF0066FF),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Pay via UPI / QR / Net Banking',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0D234A),
                          ),
                        ),
                      ),
                      Icon(
                        _selectedPaymentMode == 1
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: _selectedPaymentMode == 1
                            ? const Color(0xFF0066FF)
                            : const Color(0xFFCBD5E1),
                      ),
                    ],
                  ),

                  // UPI Sub-options when selected
                  if (_selectedPaymentMode == 1) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildUpiPill(0, 'GPay / PhonePe'),
                        const SizedBox(width: 8),
                        _buildUpiPill(1, 'UPI ID'),
                        const SizedBox(width: 8),
                        _buildUpiPill(2, 'Net Banking'),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpiPill(int index, String label) {
    final isSel = _selectedUpiSubOption == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedUpiSubOption = index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSel ? const Color(0xFF0066FF) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSel ? const Color(0xFF0066FF) : const Color(0xFFCBD5E1),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: isSel ? Colors.white : const Color(0xFF334155),
            ),
          ),
        ),
      ),
    );
  }

  /// Bottom Pay Button Bar
  Widget _buildBottomPayBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _onPayAndBook,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0066FF),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              'Pay ₹ ${_currentFare.toStringAsFixed(2)} & Book Ticket',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
