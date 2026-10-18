import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_assets.dart';
/// Screen 9: Search Trains Screen
///
/// Features Train Number/Name search, Station schedule lookup,
/// Source to Destination search with Swap button, "All Trains" / "Trains on Run"
/// filter toggles, and Recent Searches history.
class SearchTrainsScreen extends StatefulWidget {
  const SearchTrainsScreen({super.key});

  @override
  State<SearchTrainsScreen> createState() => _SearchTrainsScreenState();
}

class _SearchTrainsScreenState extends State<SearchTrainsScreen> {
  final TextEditingController _trainController = TextEditingController();
  final TextEditingController _stationController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  bool _isAllTrainsSelected = true;

  @override
  void dispose() {
    _trainController.dispose();
    _stationController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _swapStations() {
    setState(() {
      final temp = _fromController.text;
      _fromController.text = _toController.text;
      _toController.text = temp;
    });
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
            children: [
              // 1. Top Header Bar (White bg)
              _buildTopHeader(context),

              // 2. Scrollable Body
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Form Card
                      _buildMainFormCard(),

                      const SizedBox(height: 10),

                      // Bottom Section: Recent Searches
                      _buildRecentSearchesSection(),

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

  /// 1. Top Header Bar (White bg)
  Widget _buildTopHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Left placeholder for symmetry
          const SizedBox(width: 40, height: 40),

          // Center Title
          const Expanded(
            child: Text(
              'Search Trains',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0D234A),
                letterSpacing: -0.2,
              ),
            ),
          ),

          // Right Close Action
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
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
    );
  }

  /// 2. Main White Form Card
  Widget _buildMainFormCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
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
          // A. "Train" Input Section
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

          // B. Horizontal Divider with Centered "OR"
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: const [
                Expanded(
                  child: Divider(
                    color: Color(0xFFE2E8F0),
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'OR',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Color(0xFFE2E8F0),
                    thickness: 1,
                  ),
                ),
              ],
            ),
          ),

          // C. "Station" Input Section
          const Text(
            'Station',
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
                  controller: _stationController,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0D234A),
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: 'Station',
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

          // D. "Schedule" Button
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fetching train schedule...'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066FF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'Schedule',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),

          // E. "From" & "To" Station Section (with Swap Button)
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerRight,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // From label
                  const Text(
                    'From',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF0288D1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 48),
                    child: Row(
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
                            controller: _fromController,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0D234A),
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              hintText: 'Source',
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
                  ),

                  const SizedBox(height: 14),
                  const Divider(
                    color: Color(0xFFE2E8F0),
                    thickness: 1,
                    height: 1,
                  ),
                  const SizedBox(height: 14),

                  // To label
                  const Text(
                    'To',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF0288D1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 48),
                    child: Row(
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
                            controller: _toController,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0D234A),
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              hintText: 'Destination',
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
                  ),
                ],
              ),

              // Overlapping circular swap button
              Positioned(
                right: 0,
                child: InkWell(
                  onTap: _swapStations,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC2DBFF),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.swap_vert,
                        color: Color(0xFF0052CC),
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // F. Filter Pills Row ("All Trains" | "Trains on Run")
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildFilterPill(
                  title: 'All Trains',
                  isSelected: _isAllTrainsSelected,
                  onTap: () {
                    setState(() {
                      _isAllTrainsSelected = true;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterPill(
                  title: 'Trains on Run',
                  isSelected: !_isAllTrainsSelected,
                  onTap: () {
                    setState(() {
                      _isAllTrainsSelected = false;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // G. "Search" Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Searching trains...'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066FF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'Search',
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

  /// Filter pill button helper
  Widget _buildFilterPill({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD6E8FF) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFF0066FF) : const Color(0xFFCBD5E1),
            width: isSelected ? 1.2 : 1.0,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? const Color(0xFF0066FF) : const Color(0xFF78909C),
          ),
        ),
      ),
    );
  }

  /// 3. Bottom Section: "Recent Searches"
  Widget _buildRecentSearchesSection() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Searches',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0D234A),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 12),
          // Left-aligned light blue card
          InkWell(
            onTap: () {
              setState(() {
                _fromController.text = 'SHRIDHAM - SRID';
                _toController.text = 'JABALPUR - JBP';
              });
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 170,
              height: 92,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFDCEBFA),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'SHRIDHAM - SRID',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF334155),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Icon(
                    Icons.route_outlined,
                    color: Color(0xFF0066FF),
                    size: 18,
                  ),
                  Text(
                    'JABALPUR - JBP',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF334155),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
