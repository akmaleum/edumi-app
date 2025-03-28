// lib/notifications.dart
import 'package:flutter/material.dart';
import 'status.dart';
import 'profile.dart';
import 'widget/navbar.dart'; // Import the custom nav bar

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // Remove back arrow
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today Section
              const Text(
                'Today',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              _buildNotificationCard(
                title: 'Application confirmed!',
                subtitle: 'Your application to study abroad has been successfully approved!',
                onTap: () {
                  // Add navigation or action for this notification
                },
              ),
              const SizedBox(height: 10),
              _buildNotificationCard(
                title: 'Application confirmed!',
                subtitle: 'Your application to study abroad has been successfully approved!',
                onTap: () {
                  // Add navigation or action for this notification
                },
              ),
              const SizedBox(height: 10),
              _buildNotificationCard(
                title: 'Application confirmed!',
                subtitle: 'Your application to study abroad has been successfully approved!',
                onTap: () {
                  // Add navigation or action for this notification
                },
              ),
              const SizedBox(height: 20),

              // Yesterday Section
              const Text(
                'Yesterday',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              _buildNotificationCard(
                title: 'Application confirmed!',
                subtitle: 'Your application to study abroad has been successfully approved!',
                onTap: () {
                  // Add navigation or action for this notification
                },
              ),
              const SizedBox(height: 10),
              _buildNotificationCard(
                title: 'Application confirmed!',
                subtitle: 'Your application to study abroad has been successfully approved!',
                onTap: () {
                  // Add navigation or action for this notification
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, ModalRoute.withName('/home'));
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ApplicationStatusScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.check_circle_outline,
          color: Colors.green,
          size: 30,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}