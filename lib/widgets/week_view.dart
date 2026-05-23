import 'package:flutter/material.dart';
import '../models/partials.dart';
import 'weather_icon.dart';

class WeekView extends StatelessWidget {
  final DateTime currentDate;
  final ValueChanged<DateTime>? onDateSelected;

  const WeekView({
    Key? key,
    required this.currentDate,
    this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate the width for each column
          double columnWidth = (constraints.maxWidth - 6 * 3) / 7;
          
          return GridView.count(
            crossAxisCount: 7,
            crossAxisSpacing: 3,
            mainAxisSpacing: 16,
            childAspectRatio: columnWidth / 400,
            children: List.generate(7, (index) {
              return DayCard(
                dayIndex: index,
                currentDate: currentDate,
                onDateSelected: onDateSelected,
              );
            }),
          );
        },
      ),
    );
  }
}

class DayCard extends StatelessWidget {
  final int dayIndex;
  final DateTime currentDate;
  final ValueChanged<DateTime>? onDateSelected;

  const DayCard({
    Key? key,
    required this.dayIndex,
    required this.currentDate,
    this.onDateSelected,
  }) : super(key: key);

  // Mock events function
  List<Map<String, dynamic>> mockEvents(int dayIndex) {
    final events = [
      {'time': '9:00 AM', 'title': 'Team Standup', 'color': 'blue'},
      {'time': '2:00 PM', 'title': 'Client Meeting', 'color': 'purple'},
      {'time': '4:30 PM', 'title': 'Code Review', 'color': 'green'},
    ];
    return dayIndex % 2 == 0 ? events.sublist(0, 2) : [events[2]];
  }

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
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final today = DateTime.now();
    final date = currentDate.add(Duration(days: dayIndex));
    
    bool isToday = date.day == today.day &&
        date.month == today.month &&
        date.year == today.year;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(
        minHeight: 400,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dayNames[dayIndex],
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isToday ? const Color(0xFF3B82F6) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isToday ? Colors.white : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isToday ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          WeatherIcon(
            type: 'partly-cloudy',
            high: 72,
            low: 54,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: mockEvents(dayIndex).length,
              itemBuilder: (context, eventIndex) {
                final event = mockEvents(dayIndex)[eventIndex];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: getColor(event['color']).withOpacity(0.2),
                      border: Border(
                        left: BorderSide(
                          color: getColor(event['color']),
                          width: 3,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(8),
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
                        Text(
                          event['title'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}