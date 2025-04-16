import 'package:flutter/material.dart';
import 'home_screen.dart'; // Updated import
import 'application_status_screen.dart';
import 'my_profile_screen.dart';
import '../widgets/bottom_nav_bar.dart';

// Define a Notification class to hold notification data
class NotificationItem {
  final String title;
  final String message;
  final String dateGroup;

  NotificationItem({
    required this.title,
    required this.message,
    required this.dateGroup,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _currentIndex = 1;

  // Sample notification data grouped by date
  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: 'Application confirmed!',
      message: 'Your application to study abroad has been successfully approved!',
      dateGroup: 'Today',
    ),
    NotificationItem(
      title: 'Application confirmed!',
      message: 'Your application to study abroad has been successfully approved!',
      dateGroup: 'Today',
    ),
    NotificationItem(
      title: 'Application confirmed!',
      message: 'Your application to study abroad has been successfully approved!',
      dateGroup: 'Today',
    ),
    NotificationItem(
      title: 'Application confirmed!',
      message: 'Your application to study abroad has been successfully approved!',
      dateGroup: 'Yesterday',
    ),
    NotificationItem(
      title: 'Application confirmed!',
      message: 'Your application to study abroad has been successfully approved!',
      dateGroup: 'Yesterday',
    ),
  ];

  void _onNavBarTap(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
        break;
      case 1:
        // Already on NotificationsScreen
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ApplicationStatusScreen(),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Group notifications by date
    Map<String, List<NotificationItem>> groupedNotifications = {};
    for (var notification in _notifications) {
      groupedNotifications.putIfAbsent(notification.dateGroup, () => []);
      groupedNotifications[notification.dateGroup]!.add(notification);
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: Theme.of(context).textTheme.headlineLarge ??
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: groupedNotifications.keys.length,
                  itemBuilder: (context, index) {
                    final dateGroup = groupedNotifications.keys.elementAt(index);
                    final notifications = groupedNotifications[dateGroup]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateGroup.toUpperCase(),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: const Color(0xFF6B7280),
                                fontWeight: FontWeight.bold,
                              ) ??
                              const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6B7280),
                              ),
                        ),
                        const SizedBox(height: 12),
                        ...notifications.map((notification) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _buildNotificationItem(
                              notification.title,
                              notification.message,
                            ),
                          );
                        }),
                        const SizedBox(height: 24), // Space between groups
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }

  Widget _buildNotificationItem(String title, String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFFE5E7EB),
            child: Icon(
              Icons.check_circle_outline,
              color: Color(0xFF3B82F6),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ) ??
                      const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6B7280),
                      ) ??
                      const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Color(0xFF6B7280),
            size: 24,
          ),
        ],
      ),
    );
  }
}