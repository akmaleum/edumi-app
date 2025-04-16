import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'notifications_screen.dart';
import 'my_profile_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class ApplicationStatusScreen extends StatefulWidget {
  const ApplicationStatusScreen({super.key});

  @override
  _ApplicationStatusScreenState createState() => _ApplicationStatusScreenState();
}

class _ApplicationStatusScreenState extends State<ApplicationStatusScreen> {
  int _currentIndex = 2;

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NotificationsScreen()),
        );
        break;
      case 2:
        // Already on ApplicationStatusScreen
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Application Status',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  hintText: 'product or service applied',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF9CA3AF),
                      ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              const SizedBox(height: 32),
              _buildStatusStep(
                1,
                'Initial Consultation',
                'Completed on 21 Feb',
                true,
                isCurrent: false,
              ),
              _buildStatusStep(
                2,
                'Document Submission',
                'submitted on 1 Mar\nunder review',
                true,
                isCurrent: false,
              ),
              _buildStatusStep(
                3,
                'Application Review',
                'in progress...',
                false,
                isCurrent: true,
              ),
              _buildStatusStep(
                4,
                'Visa and Offer Letter',
                '',
                false,
                isCurrent: false,
              ),
              _buildStatusStep(
                5,
                'Onboarding',
                '',
                false,
                isCurrent: false,
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

  Widget _buildStatusStep(
    int step,
    String title,
    String subtitle,
    bool isCompleted, {
    required bool isCurrent,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: isCurrent
                  ? const Color(0xFF3B82F6)
                  : isCompleted
                      ? Colors.green
                      : const Color(0xFFD1D5DB),
              child: Text(
                step.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (step != 5)
              Container(
                height: subtitle.isNotEmpty ? 80 : 40,
                width: 2,
                color: isCompleted || isCurrent
                    ? (isCurrent ? const Color(0xFF3B82F6) : Colors.green)
                    : const Color(0xFFD1D5DB),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isCurrent
                          ? const Color(0xFF3B82F6)
                          : const Color(0xFF1F2937),
                    ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isCurrent
                            ? const Color(0xFF3B82F6)
                            : const Color(0xFF6B7280),
                      ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}