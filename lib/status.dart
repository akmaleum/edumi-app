// lib/status.dart
import 'package:flutter/material.dart';
import 'notifications.dart';
import 'profile.dart';
import 'widget/navbar.dart'; // Import the custom nav bar

class ApplicationStatusScreen extends StatelessWidget {
  const ApplicationStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Application Status',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'product or service applied',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildTimelineStep(
                    stepNumber: 1,
                    title: 'Initial Consultation',
                    subtitle: 'Completed on 21 Feb',
                    isCompleted: true,
                    isActive: false,
                  ),
                  _buildTimelineStep(
                    stepNumber: 2,
                    title: 'Document Submission',
                    subtitle: 'submitted on 1 Mar\nunder review',
                    isCompleted: true,
                    isActive: false,
                  ),
                  _buildTimelineStep(
                    stepNumber: 3,
                    title: 'Application Review',
                    subtitle: 'in progress...',
                    isCompleted: false,
                    isActive: true,
                  ),
                  _buildTimelineStep(
                    stepNumber: 4,
                    title: 'Visa and Offer Letter',
                    subtitle: '',
                    isCompleted: false,
                    isActive: false,
                  ),
                  _buildTimelineStep(
                    stepNumber: 5,
                    title: 'Onboarding',
                    subtitle: '',
                    isCompleted: false,
                    isActive: false,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, ModalRoute.withName('/home'));
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsScreen(),
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

  Widget _buildTimelineStep({
    required int stepNumber,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isActive,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline Indicator and Line
        Column(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? Colors.green
                    : (isActive ? Colors.blue : Colors.grey),
                border: Border.all(
                  color: isCompleted
                      ? Colors.green
                      : (isActive ? Colors.blue : Colors.grey),
                ),
              ),
              child: Center(
                child: Text(
                  '$stepNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: isCompleted ? Colors.green : Colors.grey,
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Step Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (subtitle.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}