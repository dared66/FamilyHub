import 'package:flutter/material.dart';
import '../models/partials.dart';
import 'weather_icon.dart';

class DayView extends StatelessWidget {
  final DateTime selectedDate;
  static final List<Map<String, dynamic>> mockEvents = [
    {'time': '9:00 AM', 'title': 'Team Standup', 'description': 'Daily sync', 'color': 'blue'},
    {'time': '10:30 AM', 'title': 'Design Review', 'description': 'Review mockups', 'color': 'purple'},
    {'time': '2:00 PM', 'title': 'Client Meeting', 'description': 'Q2 planning', 'color': 'green'},
    {'time': '4:30 PM', 'title': 'Code Review', 'description': 'PR reviews', 'color': 'orange'},
  ];

  const DayView({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  // Color mapping
  Color getColor(String colorName) {
    switch (colorName) {
      case 'blue':
        return const Color(0xFF3B82F6);
      case 'purple':
        return const Color(0xFF8B5CF6);
      case 'green':
        return const Color(0xFF22C55E);
      case 'orange':
        return const Color(0xFFF97316);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weather card
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${selectedDate.day} ${selectedDate.month} ${selectedDate.year}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  WeatherIcon(
                    type: 'partly-cloudy',
                    high: 72,
                    low: 54,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Event list
            ...mockEvents.asMap().entries.map((entry) {
              final index = entry.key;
              final event = entry.value;
              return Container(
                key: ValueKey(index),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.only(bottom: 12),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: getColor(event['color']),
                        width: 4,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event['title'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event['description'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}