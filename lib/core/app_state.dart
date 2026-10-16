import 'package:flutter/material.dart';

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
  final int passengerAge;
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
    this.passengerAge = 27,
    this.idType = 'Voter ID',
    this.idNumber = 'ZMT1179324',
    this.secretCode = 'R20686',
  });

  /// Strict Smart Name Getter:
  /// Everywhere on tickets / journey planner, only the first name is displayed.
  String get passengerFirstName =>
      passengerFullName.trim().split(RegExp(r'\s+')).first;
}

/// Reactive Global Application State Singleton
class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  factory AppState() => instance;
  AppState._internal();

  // 1. User Profile Data
  String fullName = 'Rishi kumar kahar';
  String mobileNumber = '9584584988';
  int age = 27;
  String idType = 'Voter ID';
  String idNumber = 'ZMT1179324';
  double rWalletBalance = 3.50;

  /// Smart First Name Getter:
  /// Used strictly across Home, Profile header, Menu header, and Season Ticket cards.
  String get firstName => fullName.trim().split(RegExp(r'\s+')).first;

  /// Update user profile details and notify listeners
  void updateUserProfile({
    String? fullName,
    String? mobileNumber,
    int? age,
    String? idType,
    String? idNumber,
    double? rWalletBalance,
  }) {
    if (fullName != null && fullName.trim().isNotEmpty) {
      this.fullName = fullName.trim();
    }
    if (mobileNumber != null && mobileNumber.trim().isNotEmpty) {
      this.mobileNumber = mobileNumber.trim();
    }
    if (age != null) {
      this.age = age;
    }
    if (idType != null) {
      this.idType = idType;
    }
    if (idNumber != null && idNumber.trim().isNotEmpty) {
      this.idNumber = idNumber.trim();
    }
    if (rWalletBalance != null) {
      this.rWalletBalance = rWalletBalance;
    }
    notifyListeners();
  }

  // 2. Active Booked Tickets List (Pre-loaded with original Season Ticket)
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
      passengerFullName: 'Rishi kumar kahar',
      passengerAge: 27,
      idType: 'Voter ID',
      idNumber: 'ZMT1179324',
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
