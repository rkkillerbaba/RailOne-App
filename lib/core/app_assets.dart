import 'package:flutter/material.dart';

/// Asset paths for the RailOne mobile application.
class AppAssets {
  AppAssets._();

  static const String basePath = 'assets/images';

  // Header & App Bar
  static const String bellNotification = '$basePath/bell_notification.png';
  static const String bellAnimation = '$basePath/Animation1.gif';

  // Section 1: Journey Planner
  static const String reservedCard = '$basePath/reserve_card.png';
  static const String unreservedCard = '$basePath/card_unreserve_ticket.png';
  static const String platformCard = '$basePath/platform_card.png';

  // Section 2: More Offerings
  static const String searchTrains = '$basePath/search_train_route.png';
  static const String pnrStatus = '$basePath/enquire_pnr_icon.png';
  static const String coachPosition = '$basePath/coachpositionNew.png';
  static const String trackTrain = '$basePath/enquire_spot_your_train.png';
  static const String orderFood = '$basePath/more_order_food.png';
  static const String fileRefund = '$basePath/cancelledTicket.png';
  static const String fileRefundIcon = '$basePath/cancelledTicket.png';
  static const String railMadad = '$basePath/support.jpg';
  static const String waves = '$basePath/waves.png';

  // Section 4: Do You Know?
  static const String firstEverTrain = '$basePath/first_ever_train.png';
  static const String chenabBridge = '$basePath/chenab.jpg';
  static const String noneyBridge = '$basePath/noney_bridge.webp';

  // Section 5: Social Media Banner
  static const String socialMediaBanner = '$basePath/social_media_background.png';

  // Section: Reserved Ticket Screen
  static const String irctcLogo = '$basePath/irctcLogo.png';
  static const String trainEngineIcon = '$basePath/new_train_engine.png';
  static const String flipIcon = '$basePath/flip_icon.png';
  static const String searchTrainRoute = '$basePath/search_train_route.png';
  static const String dropdownIcon = '$basePath/dropdown_icon.png';

  // Section: My Bookings Screen
  static const String sortFilter = '$basePath/sort_filter.webp';
  static const String refreshIcon = '$basePath/refresh_icon.png';
  static const String upcomingTicketTab = '$basePath/select_upcoming_ticket.png';
  static const String completedTicketTab = '$basePath/select_completed_ticket.png';
  static const String cancelledTicketTab = '$basePath/selected_cancelled_ticket.png';
  static const String allTicketTab = '$basePath/select_all_ticket.png';

  // Section: Profile / You Screen
  static const String rWallet = '$basePath/r_wallet.png';
  static const String maleAvatar = '$basePath/male_gender_icon.png';
  static const String femaleAvatar = '$basePath/female_gender_icon.png';
  static const String editIcon = '$basePath/edit_icon.png';
  static const String changePassword = '$basePath/change_password.png';
  static const String myAccount = '$basePath/myAccountCard.png';
  static const String myTransaction = '$basePath/my_transaction_icon.png';
  static const String delinkAadhar = '$basePath/link_aadhar_icon.png';

  // Section: Menu Screen
  static const String shareIcon = '$basePath/share_icon.png';

  // Section: Booking Details Screen
  static const String ticketBackground = '$basePath/ticket_bcgrnd.png';

  // Section: Splash Screen & App Icon
  static const String splashLogo = '$basePath/my_rail_login.png';
  static const String appLogo = 'assets/images/Railone.png';

  // Section: Food On Train Screen
  static const String foodBackgroundImage = '$basePath/backgroundImageOfFood.png';

  // Section: Rail Madad Screen
  static const String railMadadIcon = '$basePath/support.jpg';
  static const String locationPinIcon = '$basePath/location_icon.png';
  static const String currentLocationIcon = '$basePath/current_location.png';
  static const String micIcon = '$basePath/mic.png';
  static const String callIcon = '$basePath/call_icon.png';
  static const String suggestionIcon = '$basePath/suggestion_icon.png';
  static const String cameraIcon = '$basePath/camera_icon.png';

  // Section: Auth & Loader
  static const String loaderIcon = '$basePath/loader.png';
  static const String faceIdIcon = '$basePath/Face_ID_logo.png';
  static const String fingerprintIcon = '$basePath/finger_print_icon.png';

  // Section: Payment & UPI
  static const String upiIcon = '$basePath/upi_icon.png';
  static const String upiImage = '$basePath/upi_image.png';
  static const String successIcon = '$basePath/success.png';
  static const String myTransactionCard = '$basePath/myTransactionCard.png';

  /// Reusable helper to build an asset image with a guaranteed safe fallback.
  static Widget safeImage(
    String assetPath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    IconData fallbackIcon = Icons.image_not_supported_outlined,
    double fallbackIconSize = 24.0,
    Color fallbackIconColor = Colors.grey,
    BorderRadius? borderRadius,
    ImageErrorWidgetBuilder? errorBuilder,
  }) {
    Widget imageWidget = Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      color: color,
      errorBuilder: errorBuilder ??
          (context, error, stackTrace) {
            return Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              color: Colors.black.withOpacity(0.04),
              child: Icon(
                fallbackIcon,
                size: fallbackIconSize,
                color: fallbackIconColor,
              ),
            );
          },
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: imageWidget,
      );
    }
    return imageWidget;
  }
}
