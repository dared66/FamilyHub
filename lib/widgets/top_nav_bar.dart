import 'package:flutter/material.dart';

class TopNavBar extends StatelessWidget {
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const TopNavBar({
    Key? key,
    required this.currentPage,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: const Color(0xFF1A1A2E),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTab(0, Icons.calendar_month, 'Calendar'),
          _buildTab(1, Icons.checklist, 'To Do'),
          _buildTab(2, Icons.task_alt, 'Tasks'),
          _buildTab(3, Icons.cleaning_services, 'Chores'),
        ],
      ),
    );
  }

  Widget _buildTab(int index, IconData icon, String label) {
    bool isActive = currentPage == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onPageChanged(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isActive)
              const SizedBox(height: 4)
            else
              const SizedBox(height: 8),
            if (isActive)
              Container(
                height: 2,
                width: 40,
                color: Colors.blue,
              ),
          ],
        ),
      ),
    );
  }
}