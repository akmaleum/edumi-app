// lib/consultation_scheduling_screen.dart
import 'package:flutter/material.dart';
import 'notifications.dart';
import 'app_status.dart';
import 'profile.dart';
import 'widget/navbar.dart'; // Import the custom nav bar

class ConsultationSchedulingScreen extends StatefulWidget {
  const ConsultationSchedulingScreen({super.key});

  @override
  _ConsultationSchedulingScreenState createState() => _ConsultationSchedulingScreenState();
}

class _ConsultationSchedulingScreenState extends State<ConsultationSchedulingScreen> {
  DateTime? _selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to HomeScreen
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Consultation Scheduling',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Date Picker
            const Text(
              'Pick date',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _pickDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'dd/mm/yyyy'
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: TextStyle(
                        color: _selectedDate == null ? Colors.grey : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Book Appointment Button
            ElevatedButton(
              onPressed: () {
                // Add booking logic here
                if (_selectedDate != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Appointment booked for ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a date')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Book Appointment',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),

            // Consultation History
            const Text(
              'Consultation History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Initial Consultation',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '21 Feb',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Follow-up',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      '1 Mar',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 0,
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
}