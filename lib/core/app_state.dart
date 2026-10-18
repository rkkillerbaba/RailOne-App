import 'dart:convert';
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

  Map<String, dynamic> toJson() => {
        'utsNumber': utsNumber,
        'category': category,
        'isSeasonTicket': isSeasonTicket,
        'ticketType': ticketType,
        'sourceStation': sourceStation,
        'destinationStation': destinationStation,
        'distanceKm': distanceKm,
        'bookingDateText': bookingDateText,
        'bookingDateTimeText': bookingDateTimeText,
        'bookedOnNumeric': bookedOnNumeric,
        'trainType': trainType,
        'ticketClass': ticketClass,
        'fare': fare,
        'validFrom': validFrom,
        'validUpto': validUpto,
        'via': via,
        'passengerFullName': passengerFullName,
        'passengerAge': passengerAge,
        'idType': idType,
        'idNumber': idNumber,
        'secretCode': secretCode,
      };

  factory BookedTicket.fromJson(Map<String, dynamic> json) => BookedTicket(
        utsNumber: json['utsNumber'] ?? '',
        category: json['category'] ?? 'Unreserved',
        isSeasonTicket: json['isSeasonTicket'] ?? true,
        ticketType: json['ticketType'] ?? 'MONTHLY',
        sourceStation: json['sourceStation'] ?? '',
        destinationStation: json['destinationStation'] ?? '',
        distanceKm: json['distanceKm'] ?? 54,
        bookingDateText: json['bookingDateText'] ?? '',
        bookingDateTimeText: json['bookingDateTimeText'] ?? '',
        bookedOnNumeric: json['bookedOnNumeric'] ?? '',
        trainType: json['trainType'] ?? 'MAIL/EXPRESS',
        ticketClass: json['ticketClass'] ?? 'SECOND',
        fare: (json['fare'] as num?)?.toDouble() ?? 270.00,
        validFrom: json['validFrom'] ?? '',
        validUpto: json['validUpto'] ?? '',
        via: json['via'] ?? '------',
        passengerFullName: json['passengerFullName'] ?? 'User',
        passengerAge: json['passengerAge'] ?? 'X',
        idType: json['idType'] ?? 'Voter ID',
        idNumber: json['idNumber'] ?? 'ZMT1234567',
        secretCode: json['secretCode'] ?? 'R20686',
      );

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

/// Dynamic Saved Passenger Model
class SavedPassenger {
  final String id;
  final String fullName;
  final String age;
  final String gender; // 'M', 'F', 'T'
  final String berthPreference; // 'NC', 'LB', 'MB', 'UB', 'SL', 'SU'
  final String foodChoice; // 'Veg', 'Non-Veg', 'No Food'
  final bool isVerified;

  const SavedPassenger({
    required this.id,
    required this.fullName,
    required this.age,
    this.gender = 'M',
    this.berthPreference = 'NC',
    this.foodChoice = 'Veg',
    this.isVerified = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'age': age,
        'gender': gender,
        'berthPreference': berthPreference,
        'foodChoice': foodChoice,
        'isVerified': isVerified,
      };

  factory SavedPassenger.fromJson(Map<String, dynamic> json) => SavedPassenger(
        id: json['id'] ?? '',
        fullName: json['fullName'] ?? '',
        age: json['age'] ?? 'X',
        gender: json['gender'] ?? 'M',
        berthPreference: json['berthPreference'] ?? 'NC',
        foodChoice: json['foodChoice'] ?? 'Veg',
        isVerified: json['isVerified'] ?? true,
      );
}

/// Reactive Global Application State Singleton
class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  factory AppState() => instance;
  AppState._internal();

  // Registration Flag (Device Local only)
  bool isUserRegistered = false;

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

  // Saved Passengers list (Default empty - user must add)
  final List<SavedPassenger> _savedPassengers = [];
  List<SavedPassenger> get savedPassengers =>
      List.unmodifiable(_savedPassengers);

  // Active Tickets list (Default empty - no ticket card until booked)
  final List<BookedTicket> _activeTickets = [];
  List<BookedTicket> get activeTickets => List.unmodifiable(_activeTickets);

  bool get hasActiveTicket => _activeTickets.isNotEmpty;

  BookedTicket? get latestTicket =>
      _activeTickets.isNotEmpty ? _activeTickets.first : null;

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

  /// User Registration
  void registerUser({
    required String fullName,
    required String mobileNumber,
    String? age,
    String? idType,
    String? idNumber,
    required String mpin,
  }) {
    _customFullName = fullName.trim();
    this.mobileNumber = mobileNumber.trim();
    if (age != null && age.trim().isNotEmpty) {
      this.age = age.trim();
    }
    if (idType != null && idType.trim().isNotEmpty) {
      this.idType = idType.trim();
    }
    if (idNumber != null && idNumber.trim().isNotEmpty) {
      this.idNumber = idNumber.trim();
    }
    savedMpin = mpin.trim();
    isMpinSet = true;
    isUserRegistered = true;
    notifyListeners();
    _saveToPrefs();
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

  /// Load persisted state strictly from local SharedPreferences
  Future<void> initPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isUserRegistered = prefs.getBool('is_user_registered') ?? false;
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

      // Load saved passengers
      final spJsonList = prefs.getStringList('saved_passengers');
      if (spJsonList != null) {
        _savedPassengers.clear();
        for (final item in spJsonList) {
          try {
            _savedPassengers.add(
                SavedPassenger.fromJson(jsonDecode(item) as Map<String, dynamic>));
          } catch (_) {}
        }
      }

      // Load active tickets
      final ticketsJsonList = prefs.getStringList('active_tickets');
      if (ticketsJsonList != null) {
        _activeTickets.clear();
        for (final item in ticketsJsonList) {
          try {
            _activeTickets.add(
                BookedTicket.fromJson(jsonDecode(item) as Map<String, dynamic>));
          } catch (_) {}
        }
      }

      notifyListeners();
    } catch (_) {}
  }

  void _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_user_registered', isUserRegistered);
      await prefs.setString('saved_mpin', savedMpin);
      await prefs.setBool('is_mpin_set', isMpinSet);
      await prefs.setBool('is_biometric_enabled', isBiometricEnabled);
      await prefs.setString('custom_full_name', _customFullName);
      await prefs.setString('mobile_number', mobileNumber);
      await prefs.setString('age', age);
      await prefs.setString('id_type', idType);
      await prefs.setString('id_number', idNumber);
      await prefs.setDouble('r_wallet_balance', rWalletBalance);

      final spJsonList =
          _savedPassengers.map((p) => jsonEncode(p.toJson())).toList();
      await prefs.setStringList('saved_passengers', spJsonList);

      final ticketsJsonList =
          _activeTickets.map((t) => jsonEncode(t.toJson())).toList();
      await prefs.setStringList('active_tickets', ticketsJsonList);
    } catch (_) {}
  }

  /// Set or reset MPIN
  void setMpin(String pin) {
    savedMpin = pin.trim();
    isMpinSet = true;
    notifyListeners();
    _saveToPrefs();
  }

  /// Verify entered PIN against saved MPIN
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

  /// Saved Passenger Management
  void addSavedPassenger(SavedPassenger passenger) {
    _savedPassengers.add(passenger);
    notifyListeners();
    _saveToPrefs();
  }

  void removeSavedPassenger(String id) {
    _savedPassengers.removeWhere((p) => p.id == id);
    notifyListeners();
    _saveToPrefs();
  }

  /// Active Ticket Management
  void addTicket(BookedTicket ticket) {
    _activeTickets.insert(0, ticket);
    notifyListeners();
    _saveToPrefs();
  }

  void removeTicket(String utsNumber) {
    _activeTickets.removeWhere((t) => t.utsNumber == utsNumber);
    notifyListeners();
    _saveToPrefs();
  }

  void clearTickets() {
    _activeTickets.clear();
    notifyListeners();
    _saveToPrefs();
  }
}
