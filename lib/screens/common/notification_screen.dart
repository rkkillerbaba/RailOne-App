import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'Season Ticket Validity Reminder',
        'desc': 'Your monthly season ticket from SHRIDHAM to JABALPUR is active.',
        'time': '10 mins ago',
        'icon': Icons.confirmation_number_outlined,
      },
      {
        'title': 'Train Advisory Update',
        'desc': 'Platform change for Train No. 12062 at Bhopal Junction.',
        'time': '2 hours ago',
        'icon': Icons.info_outline,
      },
      {
        'title': 'R-Wallet Recharge',
        'desc': 'Use UPI to instantly top-up your R-Wallet with zero convenience fee.',
        'time': '1 day ago',
        'icon': Icons.account_balance_wallet_outlined,
      },
      {
        'title': 'Rail Madad Assistance',
        'desc': 'Track all your grievances in real time with RailOne app.',
        'time': '2 days ago',
        'icon': Icons.support_agent_outlined,
      },
      {
        'title': 'Security Alert',
        'desc': 'Biometric authentication enabled on your account.',
        'time': '3 days ago',
        'icon': Icons.fingerprint,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF142459),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF142459)),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: notifications.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = notifications[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: AppColors.primaryBlue,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontFamily: 'NotoSans',
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF142459),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['desc'] as String,
                          style: TextStyle(
                            fontFamily: 'NotoSans',
                            fontSize: 12.5,
                            color: Colors.grey.shade700,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['time'] as String,
                          style: TextStyle(
                            fontFamily: 'NotoSans',
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
