import 'package:flutter/material.dart';
import '../../core/app_assets.dart';
import '../../core/app_colors.dart';

class ReservedTicketScreen extends StatefulWidget {
  const ReservedTicketScreen({super.key});

  @override
  State<ReservedTicketScreen> createState() => _ReservedTicketScreenState();
}

class _ReservedTicketScreenState extends State<ReservedTicketScreen> {
  // Station State
  String fromStation = 'MML - MADAN MAHAL';
  String toStation = 'SRID - SHRIDHAM';

  // Date State
  String selectedDate = 'Sun, 11 Oct';
  final List<String> quickDates = ['12 Oct', '13 Oct', '14 Oct'];

  // Class & Quota State
  String selectedClass = 'All';
  final List<String> classes = [
    'All',
    '2S',
    'VS',
    'SL',
    'CC',
    'VC',
    '3E',
    '3A',
    '2A',
    '1A'
  ];

  String selectedQuota = 'General';
  final List<String> quotas = [
    'General',
    'Tatkal',
    'Ladies',
    'Lower Berth/Sr. Citizen',
    'Divyangjan',
    'Premium Tatkal',
  ];

  String selectedOtherOption = 'Please Select';
  final List<String> otherOptions = [
    'Please Select',
    'Person with Disability Concession',
    'Flexible with Date',
    'Train with Available Berth',
    'Railway Pass Concession',
  ];

  // Recent Searches Data
  final List<_RecentSearchItem> recentSearches = const [
    _RecentSearchItem(
      from: 'MADAN MAHAL, MML',
      to: 'SHRIDHAM, SRID',
      date: 'Sun, 11 Oct',
    ),
    _RecentSearchItem(
      from: 'SHRIDHAM, SRID',
      to: 'MADAN MAHAL, MML',
      date: 'Mon, 05 Oct',
    ),
    _RecentSearchItem(
      from: 'JABALPUR, JBP',
      to: 'MADAN MAHAL, MML',
      date: 'Mon, 05 Oct',
    ),
  ];

  void _swapStations() {
    setState(() {
      final temp = fromStation;
      fromStation = toStation;
      toStation = temp;
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime now = DateTime(2026, 10, 11);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: now.add(const Duration(days: 120)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.languageBlue,
              onPrimary: Colors.white,
              onSurface: AppColors.darkBlueText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final List<String> months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final weekday = weekdays[picked.weekday - 1];
      final month = months[picked.month - 1];
      setState(() {
        selectedDate = '$weekday, ${picked.day} $month';
      });
    }
  }

  void _showQuotaModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Select Quota',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.headingNavy,
                  ),
                ),
              ),
              const Divider(height: 1),
              ...quotas.map((quota) {
                final isSelected = selectedQuota == quota;
                return ListTile(
                  title: Text(
                    quota,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.languageBlue : AppColors.darkBlueText,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.languageBlue)
                      : null,
                  onTap: () {
                    setState(() {
                      selectedQuota = quota;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showOtherOptionsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Other Options',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.headingNavy,
                  ),
                ),
              ),
              const Divider(height: 1),
              ...otherOptions.map((option) {
                final isSelected = selectedOtherOption == option;
                return ListTile(
                  title: Text(
                    option,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.languageBlue : AppColors.darkBlueText,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.languageBlue)
                      : null,
                  onTap: () {
                    setState(() {
                      selectedOtherOption = option;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldGreyBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildMainFormCard(context),
                    const SizedBox(height: 8),
                    _buildRecentSearchesSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Top Header Bar (White bg, Centered Title + Subtitle, Right Close Button)
  Widget _buildTopHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Spacer for visual symmetry
          const SizedBox(width: 40, height: 40),

          // Center Column: 'Reserved Ticket' + 'Powered by IRCTC'
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Reserved Ticket',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.headingNavy,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppAssets.safeImage(
                    AppAssets.irctcLogo,
                    width: 16,
                    height: 16,
                    fallbackIcon: Icons.train,
                    fallbackIconSize: 16,
                    fallbackIconColor: AppColors.headingNavy,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Powered by IRCTC',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.headingNavy,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Right Action: Circular Close Button (40x40, 1.5px border #D0E2FF)
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFD0E2FF),
                  width: 1.5,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.close,
                  color: AppColors.languageBlue,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Main White Form Card
  Widget _buildMainFormCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A. Saved Preferences Button
          _buildSavedPreferencesButton(),

          // B. "•  OR  •" Divider
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Center(
              child: Text(
                '•  OR  •',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slateGrey,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),

          // C. From & To Station Section (with Swap Button)
          _buildStationSection(),
          const SizedBox(height: 18),

          // D. Departure Date Row
          _buildDepartureDateSection(context),
          const SizedBox(height: 18),

          // E. Class Selection Chips
          _buildClassSelectionSection(),
          const SizedBox(height: 18),

          // F. Quota Dropdown Field
          _buildQuotaSection(),
          const SizedBox(height: 18),

          // G. Other Options Dropdown Field
          _buildOtherOptionsSection(),
          const SizedBox(height: 22),

          // H. Search Button
          _buildSearchButton(context),
          const SizedBox(height: 14),

          // I. Check Last Transaction
          _buildCheckLastTransaction(),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  /// A. Saved Preferences Button
  Widget _buildSavedPreferencesButton() {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: AppColors.savedPrefBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.languageBlue,
            width: 1,
          ),
        ),
        child: const Column(
          children: [
            Text(
              'Search Using Saved Preferences',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppColors.languageBlue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2),
            Text(
              '(Source, Destination, Class and Quota)',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.labelMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// C. Station Section with Overlapping Swap Button
  Widget _buildStationSection() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // From
            const Text(
              'From',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.labelBlue,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                AppAssets.safeImage(
                  AppAssets.trainEngineIcon,
                  width: 22,
                  height: 22,
                  fallbackIcon: Icons.directions_railway,
                  fallbackIconColor: AppColors.slateGrey,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    fromStation,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkBlueText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 48), // Padding so text doesn't touch swap button
              ],
            ),
            const SizedBox(height: 12),

            // Divider Line
            const Padding(
              padding: EdgeInsets.only(right: 48.0),
              child: Divider(
                color: AppColors.borderLight,
                height: 1,
                thickness: 1,
              ),
            ),
            const SizedBox(height: 12),

            // To
            const Text(
              'To',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.labelBlue,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                AppAssets.safeImage(
                  AppAssets.trainEngineIcon,
                  width: 22,
                  height: 22,
                  fallbackIcon: Icons.directions_railway,
                  fallbackIconColor: AppColors.slateGrey,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    toStation,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkBlueText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 48), // Padding so text doesn't touch swap button
              ],
            ),
          ],
        ),

        // Overlapping Circular Swap Button (40x40, bg #C2DBFF, swap icon #0052CC)
        Positioned(
          right: 0,
          child: InkWell(
            onTap: _swapStations,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.swapButtonBg,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.swap_vert,
                  color: AppColors.swapIconBlue,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// D. Departure Date Section
  Widget _buildDepartureDateSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Departure Date',
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            color: AppColors.labelBlue,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Selected Date Text & Blue Calendar Icon
            InkWell(
              onTap: () => _pickDate(context),
              borderRadius: BorderRadius.circular(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedDate,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkBlueText,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.calendar_month_rounded,
                    color: AppColors.languageBlue,
                    size: 22,
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Horizontal Quick-Date Pills
            ...quickDates.map((qDate) {
              final bool isSelected = selectedDate == qDate;
              return Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedDate = qDate;
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.chipSelectedBg : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.languageBlue
                            : AppColors.chipBorderGrey,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      qDate,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.languageBlue
                            : AppColors.slateGrey,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  /// E. Class Selection Chips
  Widget _buildClassSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Class',
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            color: AppColors.labelBlue,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 32,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: classes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = classes[index];
              final bool isSelected = selectedClass == item;
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedClass = item;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.chipSelectedBg : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.languageBlue
                          : AppColors.chipBorderGrey,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.languageBlue
                          : AppColors.slateGrey,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// F. Quota Dropdown Field
  Widget _buildQuotaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quota',
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            color: AppColors.labelBlue,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: _showQuotaModal,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedQuota,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBlueText,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.languageBlue,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Divider(
          color: AppColors.borderLight,
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }

  /// G. Other Options Dropdown Field
  Widget _buildOtherOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Other Options',
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            color: AppColors.labelGrey,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: _showOtherOptionsModal,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedOtherOption,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBlueText,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.languageBlue,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Divider(
          color: AppColors.borderLight,
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }

  /// H. Search Button
  Widget _buildSearchButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Searching trains from $fromStation to $toStation on $selectedDate ($selectedClass - $selectedQuota)...',
              ),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.languageBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Text(
          'Search',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// I. Check Last Transaction
  Widget _buildCheckLastTransaction() {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.chipSelectedBg,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.sync_alt,
                  color: AppColors.languageBlue,
                  size: 14,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Check Last Transaction',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.languageBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 3. Bottom Section - Recent Searches
  Widget _buildRecentSearchesSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Searches',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.headingNavy,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 105,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: recentSearches.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = recentSearches[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      fromStation = item.from;
                      toStation = item.to;
                      selectedDate = item.date;
                    });
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 165,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: AppColors.recentCardBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.from,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.recentCardText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        const Icon(
                          Icons.swap_calls_rounded,
                          color: AppColors.languageBlue,
                          size: 18,
                        ),
                        Text(
                          item.to,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.recentCardText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          item.date,
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF475569),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentSearchItem {
  final String from;
  final String to;
  final String date;

  const _RecentSearchItem({
    required this.from,
    required this.to,
    required this.date,
  });
}
