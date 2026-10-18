import 'package:flutter/material.dart';

/// App-wide color palette matching the RailOne UI design specifications.
class AppColors {
  AppColors._();

  // Primary & Navigation
  static const Color primaryBlue = Color(0xFF0072EE);
  static const Color languageBlue = Color(0xFF0066FF);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color badgeRed = Color(0xFFFF0000);

  // Typography
  static const Color railTitleGrey = Color(0xFF4A4A4A);
  static const Color greetingText = Color(0xFF1A2B4C);
  static const Color headingNavy = Color(0xFF0D234A);
  static const Color labelMuted = Color(0xFF4A5B75);
  static const Color offeringLabel = Color(0xFF2B3A55);
  static const Color triviaText = Color(0xFF334155);

  // Offerings Card Background Colors (Pastel)
  static const Color searchTrainsBg = Color(0xFFFFF0F3);
  static const Color pnrStatusBg = Color(0xFFEAFAEA);
  static const Color coachPositionBg = Color(0xFFE6F6FC);
  static const Color trackTrainBg = Color(0xFFFFF9EB);
  static const Color orderFoodBg = Color(0xFFE8E6FA);
  static const Color fileRefundBg = Color(0xFFEBEBEB);
  static const Color railMadadBg = Color(0xFFFDE8E8);
  static const Color wavesBg = Color(0xFF75748A);

  // Ticket Card Gradient & Accent
  static const Color ticketGradientStart = Color(0xFF473B7B);
  static const Color ticketGradientMiddle = Color(0xFF8B63BA);
  static const Color ticketGradientEnd = Color(0xFFB580D1);
  static const Color ticketUnreservedGreen = Color(0xFFB9F6CA);
  static const Color ticketDivider = Colors.white38;
  static const Color ticketButtonFill = Color(0x33000000);

  // Social Media Colors
  static const Color facebookBlue = Color(0xFF1877F2);
  static const Color youtubeRed = Color(0xFFFF0000);
  static const Color xBlack = Color(0xFF000000);
  static const List<Color> instagramGradient = [
    Color(0xFF833AB4),
    Color(0xFFFD1D1D),
    Color(0xFFFCB045),
  ];

  // Neutral Backgrounds
  static const Color screenBackground = Color(0xFFFFFFFF);
  static const Color scaffoldGreyBg = Color(0xFFF5F7FA);
  static const Color cardShadow = Color(0x0D000000);

  // Reserved Ticket Screen Colors
  static const Color darkBlueText = Color(0xFF1E293B);
  static const Color labelBlue = Color(0xFF0288D1);
  static const Color labelGrey = Color(0xFF78909C);
  static const Color slateGrey = Color(0xFF64748B);
  static const Color chipSelectedBg = Color(0xFFD6E8FF);
  static const Color chipBorderGrey = Color(0xFFCBD5E1);
  static const Color swapButtonBg = Color(0xFFC2DBFF);
  static const Color swapIconBlue = Color(0xFF0052CC);
  static const Color savedPrefBg = Color(0xFFEBF3FF);
  static const Color recentCardBg = Color(0xFFDCEBFA);
  static const Color recentCardText = Color(0xFF1E3A8A);

  // My Bookings Screen Colors
  static const Color ticketBorderOrange = Color(0xFFF3B078);
  static const Color ticketCardBg = Color(0xFFF9F9FB);
  static const Color ticketDashedDivider = Color(0xFFF5CBA7);
  static const Color bookingAmber = Color(0xFFE69138);
  static const Color unreservedBadgeBg = Color(0xFFEBDDF8);
  static const Color unreservedBadgePurple = Color(0xFF9C27B0);
  static const Color bookingBottomBarBg = Color(0xFFEAF4FE);
  static const Color bookingInactiveTabBg = Color(0xFFE1EFFC);
  static const Color bookingActiveTabBg = Color(0xFFFAF8F5);

  // Profile / You Screen Colors
  static const Color profileHeaderBg = Color(0xFFE6F6FE);
  static const Color profileAvatarBg = Color(0xFF4AA9DF);
  static const Color rWalletAmountText = Color(0xFF134E4A);
  static const Color progressGreen = Color(0xFF388E3C);
  static const Color progressBorder = Color(0xFFE0F2FE);
  static const Color passengerCardBg = Color(0xFFFCFBF7);
  static const Color passengerHeaderBg = Color(0xFFFFF3E0);
  static const Color passengerGold = Color(0xFFF5B041);
  static const Color passengerGoldBtn = Color(0xFFF5B749);
  static const Color passengerAvatarBg = Color(0xFFFDEBD0);
  static const Color actionGridText = Color(0xFF1E3A5F);

  // Profile Action Card Backgrounds
  static const Color cardChangePasswordBg = Color(0xFFE6F7FC);
  static const Color cardMyAccountBg = Color(0xFFEBFAEB);
  static const Color cardBiometricBg = Color(0xFFFDF2F8);
  static const Color cardTransferTicketBg = Color(0xFFF1F7FA);
  static const Color cardMyTransactionBg = Color(0xFFFFF3E6);
  static const Color cardDeLinkAadharBg = Color(0xFFEFEFE9);

  // Menu Screen Colors
  static const Color menuHeaderBg = Color(0xFFF2F2FF);
  static const Color menuIconColor = Color(0xFF9395FF);
  static const Color menuWalletIcon = Color(0xFF9B9BFF);
  static const Color menuDivider = Color(0xFFE2E8FF);
  static const Color menuTextDark = Color(0xFF2B2B2B);

  // Booking Details Screen Colors
  static const Color timerRed = Color(0xFFFF2424);
  static const Color bookingDateTimeOrange = Color(0xFFF57C00);
  static const Color ticketTopPurple = Color(0xFF9B8CDA);
  static const Color ticketBottomPurple = Color(0xFF8E7CC3);
  static const Color activeGreenBg = Color(0xFFE2E7CC);
  static const Color activeGreenText = Color(0xFF2E7D32);
  static const Color warningPinkBg = Color(0xFFF5E0DF);
  static const Color warningRedText = Color(0xFFE53935);
  static const Color bookingDetailsBodyBg = Color(0xFFF8F8FA);
}
