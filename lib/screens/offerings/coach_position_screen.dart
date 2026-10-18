import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_assets.dart';

/// Screen 11: Train Coach Position Screen
class CoachPositionScreen extends StatefulWidget {
  const CoachPositionScreen({super.key});

  @override
  State<CoachPositionScreen> createState() => _CoachPositionScreenState();
}

class _CoachPositionScreenState extends State<CoachPositionScreen> {
  final TextEditingController _trainController = TextEditingController();
  final String _selectedStation = 'Select Station';
  String _selectedDate = 'Select Date';

  // Recent search data
  static const List<_RecentSearch> _recentSearches = [
    _RecentSearch(number: '12192', name: 'JBP NZM SF EXP', width: 165),
    _RecentSearch(number: '22188', name: 'INTERCITY EXP', width: 155),
    _RecentSearch(number: '61617', name: 'ET-KTE MEMU', width: 150),
  ];

  @override
  void dispose() {
    _trainController.dispose();
    super.dispose();
  }

  void _onShowCoachPosition() {
    if (_trainController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a Train Number/Name'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fetching coach position for: ${_trainController.text.trim()}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickStation() async {
    // Placeholder for station picker dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Station selection coming soon'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime.now().add(const Duration(days: 120)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0066FF),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedDate =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF0066FF),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Header Bar (White) ──────────────────────────────────
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    const SizedBox(width: 40, height: 40),
                    const Expanded(
                      child: Text(
                        'Train Coach Position',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0D234A),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFBCE0FD),
                            width: 1.5,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            color: Color(0xFF0066FF),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Main Scrollable Body ────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Form Card
                      _buildFormCard(),

                      // Recent Searches (White bg)
                      _buildRecentSearches(),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Form Card ───────────────────────────────────────────────────────────
  Widget _buildFormCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
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
          // A. Train Input
          const Text(
            'Train',
            style: TextStyle(
              fontSize: 13.5,
              color: Color(0xFF0288D1),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              AppAssets.safeImage(
                AppAssets.trainEngineIcon,
                width: 22,
                height: 22,
                color: const Color(0xFF78909C),
                fallbackIcon: Icons.directions_railway,
                fallbackIconSize: 22,
                fallbackIconColor: const Color(0xFF78909C),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _trainController,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0D234A),
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: 'Train Number/Name',
                    hintStyle: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFCBD5E1),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // B. Journey Station Dropdown
          const Text(
            'Journey Station',
            style: TextStyle(
              fontSize: 13.5,
              color: Color(0xFF0288D1),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickStation,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedStation,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF0288D1),
                  size: 22,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFFE2E8F0), thickness: 1, height: 1),

          const SizedBox(height: 20),

          // C. Journey Date Dropdown
          const Text(
            'Journey Date',
            style: TextStyle(
              fontSize: 13.5,
              color: Color(0xFF0288D1),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickDate,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF0288D1),
                  size: 22,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFFE2E8F0), thickness: 1, height: 1),

          const SizedBox(height: 26),

          // D. Show Coach Position Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _onShowCoachPosition,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066FF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'Show Coach Position',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Recent Searches ──────────────────────────────────────────────────────
  Widget _buildRecentSearches() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text(
              'Recent Searches',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0D234A),
                letterSpacing: -0.2,
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 86,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: _recentSearches.length,
              itemBuilder: (context, index) {
                final item = _recentSearches[index];
                return _buildRecentCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCard(_RecentSearch item) {
    return InkWell(
      onTap: () {
        setState(() {
          _trainController.text = '${item.number} - ${item.name}';
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: item.width.toDouble(),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFDCEBFA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top row: route icon + train number
            Row(
              children: [
                const Icon(
                  Icons.route_outlined,
                  color: Color(0xFF0066FF),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  item.number,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Bottom: train name
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF334155),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data Model ───────────────────────────────────────────────────────────────
class _RecentSearch {
  final String number;
  final String name;
  final int width;

  const _RecentSearch({
    required this.number,
    required this.name,
    required this.width,
  });
}
