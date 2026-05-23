import 'package:flutter/material.dart';

/// Left sidebar navigation — glassmorphism style.
class SideNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const SideNav({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  static const items = [
    _NavItem('Calendar', Icons.calendar_month),
    _NavItem('To Do', Icons.checklist),
    _NavItem('Tasks', Icons.task_alt),
    _NavItem('Chores', Icons.cleaning_services),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        border: Border(right: BorderSide(color: Colors.white.withOpacity(0.3))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(items.length, (i) {
          final item = items[i];
          final active = i == currentIndex;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GestureDetector(
              onTap: () => onItemSelected(i),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: active ? const Color(0xFF3B82F6) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: active
                      ? [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2))]
                      : null,
                ),
                child: Icon(
                  item.icon,
                  size: 20,
                  color: active ? Colors.white : Colors.black.withOpacity(0.4),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  const _NavItem(this.label, this.icon);
}
