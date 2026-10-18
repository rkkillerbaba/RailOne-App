import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
/// Screen 15: Rail Madad Screen
///
/// Comprehensive grievance and assistance portal with location banner,
/// media uploads, complaint details form, suggestions/feedback, and 139 helpline.
class RailMadadScreen extends StatefulWidget {
  const RailMadadScreen({super.key});

  @override
  State<RailMadadScreen> createState() => _RailMadadScreenState();
}

class _RailMadadScreenState extends State<RailMadadScreen> {
  final TextEditingController _describeController = TextEditingController();

  int? _selectedMediaIndex; // 0: Video, 1: Audio, 2: Image
  String? _selectedHelpLocation; // 'Train' or 'Station'
  String? _selectedHelpFor;
  String? _selectedProblemFaced;

  @override
  void dispose() {
    _describeController.dispose();
    super.dispose();
  }

  void _showDropdownPicker({
    required String title,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D234A),
                  ),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return ListTile(
                      title: Text(
                        option,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF334155),
                        ),
                      ),
                      onTap: () {
                        onSelected(option);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSubmit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Submitting your concern to Rail Madad...'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF0066FF),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Column(
          children: [
            // 1. Top Custom Solid Blue AppBar
            _buildCustomAppBar(context),

            // 2. Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 14),

                    // Top Tagline
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'We are Commited to Make Your Journey Pleasant !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0288D1),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Location Pill Container
                    _buildLocationPill(),

                    // Main Form Card
                    _buildMainFormCard(),

                    // Bottom Suggestions & Feedback Buttons
                    _buildBottomActionButtons(),

                    const SizedBox(height: 14),

                    // 139 Helpline Mint Green Pill
                    _buildHelplinePill(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Top Custom AppBar (Height 64, Solid Blue #0066FF)
  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      color: const Color(0xFF0066FF),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Circular Outlined Back Button
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(19),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
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
              const Expanded(
                child: Text(
                  'Rail Madad',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
              ),

              // Right Outlined "Track" Pill Button
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No active complaints found to track'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white,
                      width: 1.2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Track',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 2. Location Pill Container
  Widget _buildLocationPill() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFDCEBFA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.location_on,
            color: Color(0xFF0066FF),
            size: 18,
          ),
          SizedBox(width: 6),
          Text(
            'Your Location ',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF78909C),
            ),
          ),
          Text(
            'MADAN MAHAL-MML',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0066FF),
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Main White Form Card
  Widget _buildMainFormCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      padding: const EdgeInsets.all(18),
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
          // A. "Your Concern" Section
          const Text(
            'Your Concern',
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0288D1),
            ),
          ),
          const SizedBox(height: 14),

          // 3 Media Option Pills Row (Video, Audio, Image)
          Row(
            children: [
              Expanded(
                child: _buildMediaPill(
                  index: 0,
                  icon: Icons.videocam_outlined,
                  label: 'Video',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMediaPill(
                  index: 1,
                  icon: Icons.record_voice_over_outlined,
                  label: 'Audio',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMediaPill(
                  index: 2,
                  icon: Icons.image_outlined,
                  label: 'Image',
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Helper Note
          const Text(
            '*Choose any one option. File should not be more than 5 MB.',
            style: TextStyle(
              fontSize: 10.5,
              color: Color(0xFF8A94A6),
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 18),

          // B. "More Details to Assist You Better" Section
          const Text(
            'More Details to Assist You Better',
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0288D1),
            ),
          ),
          const SizedBox(height: 16),

          // Row 1 - "Help Required At" (Train / Station Radio)
          Row(
            children: [
              const Text(
                'Help Required At',
                style: TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF78909C),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              _buildRadioOption('Train'),
              const SizedBox(width: 28),
              _buildRadioOption('Station'),
            ],
          ),

          const SizedBox(height: 20),

          // Row 2 - "Help Required For" Dropdown
          InkWell(
            onTap: () {
              _showDropdownPicker(
                title: 'Select Category',
                options: const [
                  'Medical Assistance',
                  'Security',
                  'Cleanliness',
                  'Catering / Food',
                  'Electrical Equipment',
                  'Coach Maintenance',
                  'Water Availability',
                  'Staff Behavior',
                ],
                onSelected: (val) {
                  setState(() => _selectedHelpFor = val);
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedHelpFor ?? 'Help Required For',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: _selectedHelpFor != null
                            ? const Color(0xFF0D234A)
                            : const Color(0xFF78909C),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF0052CC),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: Color(0xFFE2E8F0), thickness: 1, height: 1),

          const SizedBox(height: 18),

          // Row 3 - "Problem Faced" Dropdown
          InkWell(
            onTap: () {
              _showDropdownPicker(
                title: 'Select Problem',
                options: const [
                  'Delayed Response',
                  'Unclean Toilet / Coach',
                  'AC Not Working',
                  'Fan / Lights Not Working',
                  'No Water in Washroom',
                  'Charging Point Not Working',
                  'Bedroll / Linen Issue',
                  'Unauthorized Passengers',
                  'Overcharging by Vendor',
                ],
                onSelected: (val) {
                  setState(() => _selectedProblemFaced = val);
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedProblemFaced ?? 'Problem Faced',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: _selectedProblemFaced != null
                            ? const Color(0xFF0D234A)
                            : const Color(0xFF78909C),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF0052CC),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: Color(0xFFE2E8F0), thickness: 1, height: 1),

          const SizedBox(height: 22),

          // Describe More Text Box (Multiline with Mic Icon)
          Container(
            height: 155,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFCBD5E1),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                TextField(
                  controller: _describeController,
                  maxLines: 5,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0D234A),
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Describe More',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF78909C),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Voice input recording started...'),
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.mic,
                        color: Color(0xFF0066FF),
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066FF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Media Pill Helper
  Widget _buildMediaPill({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedMediaIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedMediaIndex = isSelected ? null : index;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEBF3FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF0066FF) : const Color(0xFFCBD5E1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color(0xFF0066FF),
              size: 19,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xFF0066FF) : const Color(0xFF78909C),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Radio Option Helper for Train / Station
  Widget _buildRadioOption(String value) {
    final isSelected = _selectedHelpLocation == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedHelpLocation = value;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.white : const Color(0xFFE1F5FE),
              border: Border.all(
                color: isSelected ? const Color(0xFF0066FF) : const Color(0xFF81D4FA),
                width: 1.5,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF0066FF),
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFF78909C),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 4. Bottom Suggestions & Feedback Action Buttons
  Widget _buildBottomActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Suggestions Button
          Expanded(
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening Suggestions portal...'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF0066FF),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.lightbulb_circle,
                      color: Color(0xFF0066FF),
                      size: 22,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Suggestions',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0066FF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Feedback Button
          Expanded(
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening Feedback portal...'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF0066FF),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.feedback_outlined,
                      color: Color(0xFF0066FF),
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Feedback',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0066FF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 5. 139 Helpline Mint Green Pill
  Widget _buildHelplinePill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F8E9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.phone_in_talk,
            color: Color(0xFF0D234A),
            size: 14,
          ),
          SizedBox(width: 4),
          Text(
            '139 for Security/Medical Assistance',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0D234A),
            ),
          ),
        ],
      ),
    );
  }
}
