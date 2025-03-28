// lib/custom_bottom_nav_bar.dart
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              icon: Icons.home,
              index: 0,
              isSelected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _buildNavItem(
              icon: Icons.notifications,
              index: 1,
              isSelected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _buildNavItem(
              icon: Icons.location_on,
              index: 2,
              isSelected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            _buildNavItem(
              icon: Icons.person,
              index: 3,
              isSelected: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
        ],
      ),
    );
  }
}