import 'package:flutter/material.dart';
import '../models/partials.dart';
import 'weather_icon.dart';

class UpcomingView extends StatelessWidget {
  final DateTime currentDate;

  const UpcomingView({Key? key, required this.currentDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final mockUpcomingEvents = [
      _EventData(now.add(const Duration(days: 1)), '10:00 AM', 'Product Launch Meeting', 'Final review before launch', 'sunny', 75, 58),
      _EventData(now.add(const Duration(days: 2)), '2:30 PM', 'User Interview', 'Feedback session with beta users', 'cloudy', 68, 52),
      _EventData(now.add(const Duration(days: 5)), '9:00 AM', 'Sprint Planning', 'Plan next sprint objectives', 'rainy', 62, 48),
      _EventData(now.add(const Duration(days: 7)), '3:00 PM', 'Team Offsite', 'Quarterly team building event', 'partly-cloudy', 70, 55),
    ];

    final monthAbbr = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final dayAbbr = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];

    return Center(
      child: SizedBox(
        width: 720,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Upcoming Events', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...mockUpcomingEvents.map((event) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Column(
                            children: [
                              Text('${event.date.day}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              Text(monthAbbr[event.date.month - 1], style: TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.6))),
                              Text(dayAbbr[event.date.weekday - 1], style: TextStyle(fontSize: 11, color: Colors.black.withOpacity(0.5))),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.time, style: TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.6))),
                              const SizedBox(height: 4),
                              Text(event.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(event.description, style: TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.7))),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        WeatherIcon(type: event.weatherType, high: event.high, low: event.low),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventData {
  final DateTime date;
  final String time;
  final String title;
  final String description;
  final String weatherType;
  final int high;
  final int low;

  const _EventData(this.date, this.time, this.title, this.description, this.weatherType, this.high, this.low);
}
