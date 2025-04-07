// lib/profile.dart
import 'package:flutter/material.dart';
import 'edit_profile.dart';
import 'notifications.dart';
import 'status.dart';
import 'widget/navbar.dart'; // Import the custom nav bar
import 'database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String firstName = '';
  String lastName = '';
  String username = '';
  String email = '';
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    if (storedUsername != null) {
      final user = await DatabaseHelper.instance.getUserByUsername(storedUsername);
      if (user != null) {
        setState(() {
          userId = user['id'];
          firstName = user['firstName'];
          lastName = user['lastName'];
          username = user['username'];
          email = user['email'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
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
            // Profile Picture and User Details
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: Center(
                        child: Text(
                          firstName.isNotEmpty ? firstName[0].toUpperCase() : 'A',
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '$firstName $lastName',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () async {
                              // Navigate to EditProfileScreen and wait for result
                              final updatedProfile = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(
                                    firstName: firstName,
                                    lastName: lastName,
                                    username: username,
                                    email: email,
                                  ),
                                ),
                              );

                              // Update state with new values if the result is not null
                              if (updatedProfile != null) {
                                setState(() {
                                  firstName = updatedProfile['firstName'];
                                  lastName = updatedProfile['lastName'];
                                  username = updatedProfile['username'];
                                  email = updatedProfile['email'];
                                });
                              }
                            },
                            child: const Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Active Student',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Menu Options
            _buildMenuOption(
              title: 'Edit profile',
              onTap: () async {
                // Navigate to EditProfileScreen and wait for result
                final updatedProfile = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      firstName: firstName,
                      lastName: lastName,
                      username: username,
                      email: email,
                    ),
                  ),
                );

                // Update state with new values if the result is not null
                if (updatedProfile != null) {
                  setState(() {
                    firstName = updatedProfile['firstName'];
                    lastName = updatedProfile['lastName'];
                    username = updatedProfile['username'];
                    email = updatedProfile['email'];
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            _buildMenuOption(
              title: 'Settings',
              onTap: () {
                // Add navigation or action for Settings
              },
            ),
            const SizedBox(height: 16),
            _buildMenuOption(
              title: 'Support',
              onTap: () {
                // Add navigation or action for Support
              },
            ),
            const SizedBox(height: 40),

            // Log out Button
            GestureDetector(
              onTap: () {
                // Navigate back to LoginScreen and clear the navigation stack
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                'Log out',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3,
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
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ApplicationStatusScreen(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildMenuOption({
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}