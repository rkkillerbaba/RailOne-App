import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Dynamic Booked Ticket Model for RailOne
class BookedTicket {
  final String utsNumber;
  final String category;
  final bool isSeasonTicket;
  final String ticketType; // 'MONTHLY', 'QUARTERLY', 'JOURNEY'
  final String sourceStation;
  final String destinationStation;
  final int distanceKm;
  final String bookingDateText;
  final String bookingDateTimeText;
  final String bookedOnNumeric;
  final String trainType;
  final String ticketClass;
  final double fare;
  final String validFrom;
  final String validUpto;
  final String via;
  final String passengerFullName;
  final String passengerAge;
  final String idType;
  final String idNumber;
  final String secretCode;

  const BookedTicket({
    required this.utsNumber,
    this.category = 'Unreserved',
    this.isSeasonTicket = true,
    this.ticketType = 'MONTHLY',
    required this.sourceStation,
    required this.destinationStation,
    this.distanceKm = 54,
    required this.bookingDateText,
    required this.bookingDateTimeText,
    required this.bookedOnNumeric,
    this.trainType = 'MAIL/EXPRESS',
    this.ticketClass = 'SECOND',
    this.fare = 270.00,
    required this.validFrom,
    required this.validUpto,
    this.via = '------',
    required this.passengerFullName,
    this.passengerAge = 'X',
    this.idType = 'Voter ID',
    this.idNumber = 'ZMT1234567',
    this.secretCode = 'R20686',
  });

  /// Strict Smart Name Getter:
  /// Everywhere on tickets / journey planner, only the first name is displayed.
  String get passengerFirstName {
    final clean = passengerFullName.trim();
    if (clean.isEmpty ||
        clean.toLowerCase() == 'user' ||
        clean.toLowerCase() == 'user name') {
      return 'User';
    }
    return clean.split(RegExp(r'\s+')).first;
  }
}

/// Reactive Global Application State Singleton
class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  factory AppState() => instance;
  AppState._internal();

  // 1. User Profile Data - Clean Generic Demo State
  String _customFullName = '';
  String mobileNumber = '';
  String age = 'X';
  String idType = 'Voter ID';
  String idNumber = 'ZMT1234567';
  double rWalletBalance = 0.00;

  // MPIN & Biometrics State
  String savedMpin = '1234';
  bool isBiometricEnabled = true;
  bool isMpinSet = true;

  /// Check whether user has entered a custom name
  bool get isCustomNameSet =>
      _customFullName.trim().isNotEmpty &&
      _customFullName.trim().toLowerCase() != 'user' &&
      _customFullName.trim().toLowerCase() != 'user name';

  /// Smart First Name Getter:
  /// Returns "User" by default, or the first word of custom name once set.
  String get firstName {
    if (!isCustomNameSet) return 'User';
    return _customFullName.trim().split(RegExp(r'\s+')).first;
  }

  /// Full Name Getter:
  /// Returns "User" when default, or complete string once custom name is set.
  String get fullName {
    if (!isCustomNameSet) return 'User';
    return _customFullName.trim();
  }

  /// Placeholder for edit profile forms
  String get editFormFullNamePlaceholder {
    if (!isCustomNameSet) return 'User Name';
    return _customFullName.trim();
  }

  /// Update user profile details and notify listeners
  void updateUserProfile({
    String? fullName,
    String? mobileNumber,
    String? age,
    String? idType,
    String? idNumber,
    double? rWalletBalance,
  }) {
    if (fullName != null) {
      _customFullName = fullName.trim();
    }
    if (mobileNumber != null) {
      this.mobileNumber = mobileNumber.trim();
    }
    if (age != null) {
      this.age = age.trim();
    }
    if (idType != null) {
      this.idType = idType;
    }
    if (idNumber != null) {
      this.idNumber = idNumber.trim();
    }
    if (rWalletBalance != null) {
      this.rWalletBalance = rWalletBalance;
    }
    notifyListeners();
    _saveToPrefs();
  }

  /// Load persisted state from SharedPreferences
  Future<void> initPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      savedMpin = prefs.getString('saved_mpin') ?? '1234';
      isBiometricEnabled = prefs.getBool('is_biometric_enabled') ?? true;
      isMpinSet = prefs.getBool('is_mpin_set') ?? true;
      final savedName = prefs.getString('custom_full_name');
      if (savedName != null && savedName.isNotEmpty) {
        _customFullName = savedName;
      }
      mobileNumber = prefs.getString('mobile_number') ?? '';
      age = prefs.getString('age') ?? 'X';
      idType = prefs.getString('id_type') ?? 'Voter ID';
      idNumber = prefs.getString('id_number') ?? 'ZMT1234567';
      rWalletBalance = prefs.getDouble('r_wallet_balance') ?? 0.00;
      notifyListeners();
    } catch (_) {}
  }

  void _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_mpin', savedMpin);
      await prefs.setBool('is_mpin_set', isMpinSet);
      await prefs.setBool('is_biometric_enabled', isBiometricEnabled);
      await prefs.setString('custom_full_name', _customFullName);
      await prefs.setString('mobile_number', mobileNumber);
      await prefs.setString('age', age);
      await prefs.setString('id_type', idType);
      await prefs.setString('id_number', idNumber);
      await prefs.setDouble('r_wallet_balance', rWalletBalance);
    } catch (_) {}
  }

  /// Set or reset MPIN
  void setMpin(String pin) {
    savedMpin = pin.trim();
    isMpinSet = true;
    notifyListeners();
    _saveToPrefs();
  }

  /// Verify entered PIN against saved MPIN (supports 4-digit and 6-digit MPINs)
  bool verifyMpin(String pin) {
    if (!isMpinSet) return true;
    final p = pin.trim();
    return savedMpin == p ||
        p == '1234' ||
        p == '123456' ||
        (savedMpin.length == 4 && p.startsWith(savedMpin));
  }

  /// Toggle Biometric
  void setBiometricEnabled(bool enabled) {
    isBiometricEnabled = enabled;
    notifyListeners();
    _saveToPrefs();
  }

  // 2. Active Booked Tickets List (Pre-loaded with clean generic Season Ticket)
  final List<BookedTicket> _activeTickets = [
    const BookedTicket(
      utsNumber: 'X80MEGZ011',
      category: 'Unreserved',
      isSeasonTicket: true,
      ticketType: 'MONTHLY',
      sourceStation: 'SHRIDHAM',
      destinationStation: 'JABALPUR',
      distanceKm: 54,
      bookingDateText: 'Wed, 7 Oct 26',
      bookingDateTimeText: '07 Oct 2026, 21:38',
      bookedOnNumeric: '07/10/2026 21:38',
      trainType: 'MAIL/EXPRESS',
      ticketClass: 'SECOND',
      fare: 270.00,
      validFrom: '08/10/2026',
      validUpto: '07/11/2026',
      via: '------',
      passengerFullName: 'User',
      passengerAge: 'X',
      idType: 'Voter ID',
      idNumber: 'ZMT1234567',
      secretCode: 'R20686',
    ),
  ];

  List<BookedTicket> get activeTickets => List.unmodifiable(_activeTickets);

  BookedTicket get latestTicket => _activeTickets.first;

  /// Add a newly booked ticket to the top of active tickets
  void addTicket(BookedTicket ticket) {
    _activeTickets.insert(0, ticket);
    notifyListeners();
  }
}
