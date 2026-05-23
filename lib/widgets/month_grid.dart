import 'package:flutter/material.dart';
import '../models/partials.dart';
import '../core/const.dart';

class MonthGrid extends StatelessWidget {
  final DateTime selectedDate;
  final int monthOffset;
  final List<FamilyEvent> events;
  final ValueChanged<DateTime> onTapDate;
  final ValueChanged<int> onMonthChange;

  const MonthGrid({
    super.key,
    required this.selectedDate,
    required this.monthOffset,
    required this.events,
    required this.onTapDate,
    required this.onMonthChange,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstOfMonth = DateTime(now.year, now.month + monthOffset, 1);
    final daysInMonth = DateTime(firstOfMonth.year, firstOfMonth.month + 1, 0).day;
    final firstWeekday = firstOfMonth.weekday % 7; // Sunday = 0

    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Column(
      children: [
        // Month header with arrows
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white70),
                onPressed: () => onMonthChange(monthOffset - 1),
              ),
              Text(
                '${_monthName(firstOfMonth.month)} ${firstOfMonth.year}',
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white70),
                onPressed: () => onMonthChange(monthOffset + 1),
              ),
            ],
          ),
        ),
        // Day names header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: dayNames.map((d) => Expanded(
              child: Center(child: Text(d, style: const TextStyle(color: Colors.white54, fontSize: 13))),
            )).toList(),
          ),
        ),
        const SizedBox(height: 4),
        // Day cells grid
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.72,
            ),
            itemCount: firstWeekday + daysInMonth,
            itemBuilder: (_, i) {
              if (i < firstWeekday) return const SizedBox.shrink();
              final day = i - firstWeekday + 1;
              final date = DateTime(firstOfMonth.year, firstOfMonth.month, day);
              final isToday = date.day == now.day && date.month == now.month && date.year == now.year;
              final hasEvents = events.any((e) =>
                e.startTime.year == date.year &&
                e.startTime.month == date.month &&
                e.startTime.day == day);
              // Mock weather per day
              final weatherEmoji = ['☀️', '⛅', '☁️', '🌧️', '☀️', '⛅', '☁️'][day % 7];
              final hiTemp = 65 + (day % 15);
              final loTemp = 45 + (day % 10);

              return GestureDetector(
                onTap: () => onTapDate(date),
                child: Container(
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: isToday ? const Color(0xFF1A73E8).withOpacity(0.25) : const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: isToday ? const Color(0xFF1A73E8) : const Color(0xFF2A2A2A), width: 0.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$day', style: TextStyle(
                        color: isToday ? Colors.white : const Color(0xFFCCCCCC),
                        fontSize: 18, fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                      )),
                      Text(weatherEmoji, style: const TextStyle(fontSize: 13)),
                      Text('$hiTemp°/$loTemp°', style: const TextStyle(color: const Color(0xFF999999), fontSize: 13)),
                      if (hasEvents)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 5, height: 5,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1A73E8), shape: BoxShape.circle,
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
    );
  }

  String _monthName(int m) => ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][m - 1];
}