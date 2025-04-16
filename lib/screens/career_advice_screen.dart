import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'notifications_screen.dart';
import 'application_status_screen.dart';
import 'my_profile_screen.dart';
import '../widgets/bottom_nav_bar.dart';

// Define a Consultant class to hold consultant data
class Consultant {
  final String name;
  final String phoneNumber;
  final String expertise;
  final String availability;

  Consultant({
    required this.name,
    required this.phoneNumber,
    required this.expertise,
    required this.availability,
  });
}

class CareerAdviceScreen extends StatefulWidget {
  const CareerAdviceScreen({super.key});

  @override
  _CareerAdviceScreenState createState() => _CareerAdviceScreenState();
}

class _CareerAdviceScreenState extends State<CareerAdviceScreen> {
  int _currentIndex = 0; // Set to 0 since WelcomeScreen is the home screen

  // Sample consultant data
  final List<Consultant> _consultants = [
    Consultant(
      name: 'Dr. Emily Carter',
      phoneNumber: '+60 12-345 6789',
      expertise: 'Career Counseling',
      availability: 'Mon-Fri, 9 AM - 5 PM',
    ),
    Consultant(
      name: 'Mr. James Tan',
      phoneNumber: '+60 19-876 5432',
      expertise: 'Resume Building',
      availability: 'Tue-Thu, 10 AM - 3 PM',
    ),
    Consultant(
      name: 'Ms. Aisha Rahman',
      phoneNumber: '+60 17-234 5678',
      expertise: 'Interview Preparation',
      availability: 'Mon-Wed, 1 PM - 6 PM',
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NotificationsScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ApplicationStatusScreen()),
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                      );
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Career Advice',
                      style: Theme.of(context).textTheme.headlineLarge ??
                          const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 40), // Spacer for the back button
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: _consultants.length,
                  itemBuilder: (context, index) {
                    final consultant = _consultants[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildConsultantCard(consultant),
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

  Widget _buildConsultantCard(Consultant consultant) {
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
            radius: 24,
            backgroundColor: Color(0xFFE5E7EB),
            child: Icon(
              Icons.person,
              color: Color(0xFF3B82F6),
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  consultant.name,
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
                  'Expertise: ${consultant.expertise}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6B7280),
                      ) ??
                      const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Phone: ${consultant.phoneNumber}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6B7280),
                      ) ??
                      const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Available: ${consultant.availability}',
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
        ],
      ),
    );
  }
}