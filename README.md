# RailOne 3.0 - Official Indian Railways Flutter App

A complete, pixel-perfect, production-ready Flutter mobile application replicating the official Indian Railways RailOne super app.

## Features
- **Splash Screen:** Smooth zoom-out scale animation with official RailOne branding.
- **mPIN & Biometrics Authentication:** 6-digit auto-advancing pin boxes, Face ID, Fingerprint login, and rotating loader overlay.
- **Home Dashboard:** Greeting with smart first-name display, Journey Planner (Reserved, Unreserved, Platform), 8 More Offerings grid, Upcoming Journey purple ticket card with live details, and Social Media links.
- **More Offerings Screens:**
  - Search Trains Screen (Train search, station schedules, route lookup, swap, filter toggles)
  - PNR Status Screen
  - Train Coach Position Screen
  - Track Your Train Screen
  - Food On Train (e-Catering / PNR food order)
  - Tickets Eligible For Refund (File Refund)
  - Rail Madad (Grievance, media upload, GPS location banner, 139 helpline)
- **Journey Booking:**
  - Reserved Ticket planner
  - Unreserved & Season Ticket booking (Daily, Monthly, Quarterly)
  - Booking Customization & Live Payment Screen (UPI apps, UPI ID, Net Banking, R-Wallet with live balance check & deduction)
  - Live animated rotating spinner overlay (`RailOneLoaderOverlay`)
- **Active Ticket & My Bookings:**
  - Dynamic Ticket generation with authentic UTS number format (`X80MEGZ...`), route, time, and security code.
  - Live Booking Details screen with 5-minute animated countdown timer, odometer-style seconds animation, and dashed cutout notches.
  - Filter tabs (Upcoming, Completed, Cancelled, All).
- **Profile & Menu:**
  - Profile screen with strict name rule (First name on header, full name in Saved Passengers list).
  - Interactive profile editor bottom sheet.
  - Side Menu Drawer with user greeting, version, and wallet info.

## Automated Cloud Build via GitHub Actions
This repository includes `.github/workflows/build_apk.yml`. 
Simply push this repository to GitHub or run the workflow from the **Actions** tab:
1. Push code to GitHub (`main` or `master` branch).
2. Go to **Actions** -> **Build Release APK** -> Click **Run workflow**.
3. Once completed, download `RailOne.apk` directly from the **Artifacts** section!

## Local Build Instructions
```bash
# 1. Fetch dependencies
flutter pub get

# 2. Build release APK
flutter build apk --release

# The APK will be generated at:
# build/app/outputs/flutter-apk/app-release.apk
```
