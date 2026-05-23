import 'package:flutter/material.dart';
import '../models/partials.dart';

class CalendarViews extends StatelessWidget {
  final String mode;
  final DateTime selectedDate;
  final List<FamilyEvent> events;
  final ValueChanged<DateTime>? onDateSelected;

  const CalendarViews({
    Key? key,
    required this.mode,
    required this.selectedDate,
    required this.events,
    this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case 'month':
        return _buildMonthView();
      case 'week':
        return _buildWeekView();
      case 'day':
        return _buildDayView();
      case 'upcoming':
        return _buildUpcomingView();
      default:
        return _buildMonthView();
    }
  }

  Widget _buildMonthView() {
    final DateTime currentMonth = DateTime(selectedDate.year, selectedDate.month);
    final DateTime firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final int firstDayOfWeek = firstDayOfMonth.weekday;
    final int daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    
    final List<DateTime> monthDays = [];
    // Add empty cells for days before the first day of the month
    for (int i = 1; i < firstDayOfWeek; i++) {
      monthDays.add(DateTime(0, 0, 0)); // Placeholder for empty cells
    }
    
    // Add actual days of the month
    for (int i = 1; i <= daysInMonth; i++) {
      monthDays.add(DateTime(currentMonth.year, currentMonth.month, i));
    }

    return Container(
      color: const Color(0xFF121212),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month header
          Center(
            child: Text(
              '${_getMonthName(currentMonth.month)} ${currentMonth.year}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Day headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...List.generate(7, (index) => _buildDayHeader(index)),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.0,
            ),
            itemCount: monthDays.length,
            itemBuilder: (context, index) {
              final date = monthDays[index];
              if (date.year == 0) {
                return const SizedBox.shrink();
              }
              return _buildMonthCell(date);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDayHeader(int index) {
    final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Expanded(
      child: Center(
        child: Text(
          weekdays[index],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMonthCell(DateTime date) {
    final isCurrentMonth = date.month == selectedDate.month;
    final isToday = date.year == DateTime.now().year && 
                   date.month == DateTime.now().month && 
                   date.day == DateTime.now().day;
    
    final dayEvents = events.where((event) => 
      event.date.year == date.year &&
      event.date.month == date.month &&
      event.date.day == date.day
    ).toList();

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isCurrentMonth ? const Color(0xFF1E1E1E) : const Color(0xFF252525),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Date number
          Text(
            date.day.toString(),
            style: TextStyle(
              color: isToday ? Colors.blueAccent : Colors.white,
              fontSize: 16,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          
          // Weather emoji and temperature (mock data for now)
          const Text('☀️', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 2),
          const Text('75°/65°', style: TextStyle(fontSize: 12, color: Colors.white)),
          
          // Event indicators
          const SizedBox(height: 4),
          if (dayEvents.isNotEmpty)
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeekView() {
    final DateTime startOfWeek = _getStartOfWeek(selectedDate);
    final List<DateTime> weekDays = List.generate(7, (index) {
      return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + index);
    });

    final selectedDayEvents = events.where((event) => 
      event.date.year == selectedDate.year &&
      event.date.month == selectedDate.month &&
      event.date.day == selectedDate.day
    ).toList();

    return Container(
      color: const Color(0xFF121212),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Week header
          Text(
            'Week of ${_getMonthName(startOfWeek.month)} ${startOfWeek.day}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Week days row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...weekDays.map((date) => _buildWeekDay(date)),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Selected day events list
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    '${_getDayName(selectedDate.weekday)} ${_getMonthName(selectedDate.month)} ${selectedDate.day}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (selectedDayEvents.isEmpty)
                    const Text('No events for this day', style: TextStyle(color: Colors.white))
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: selectedDayEvents.length,
                        itemBuilder: (context, index) {
                          return _buildEventCard(selectedDayEvents[index]);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDay(DateTime date) {
    final isSelected = date.year == selectedDate.year &&
                      date.month == selectedDate.month &&
                      date.day == selectedDate.day;
    final dayEvents = events.where((event) => 
      event.date.year == date.year &&
      event.date.month == date.month &&
      event.date.day == date.day
    ).toList();

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF333333) : const Color(0xFF252525),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            _getDayName(date.weekday).substring(0, 3),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            date.day.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          if (dayEvents.isNotEmpty)
            Text(
              dayEvents.length.toString(),
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDayView() {
    final dayEvents = events.where((event) => 
      event.date.year == selectedDate.year &&
      event.date.month == selectedDate.month &&
      event.date.day == selectedDate.day
    ).toList();

    // Group events by time slot (hour)
    Map<String, List<FamilyEvent>> groupedEvents = {};
    for (final event in dayEvents) {
      final hourKey = '${event.date.hour}';
      if (!groupedEvents.containsKey(hourKey)) {
        groupedEvents[hourKey] = [];
      }
      groupedEvents[hourKey]!.add(event);
    }

    final hours = List.generate(12, (i) => i + 8); // 8AM to 7PM

    return Container(
      color: const Color(0xFF121212),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_getDayName(selectedDate.weekday)}, ${_getMonthName(selectedDate.month)} ${selectedDate.day}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: ListView.builder(
              itemCount: hours.length,
              itemBuilder: (context, index) {
                final hour = hours[index];
                final hourEvents = groupedEvents['$hour'] ?? [];
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '${hour} ${hour < 12 ? 'AM' : 'PM'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    ...hourEvents.map((event) => _buildEventCard(event)),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingView() {
    final today = DateTime.now();
    final tomorrow = DateTime(today.year, today.month, today.day + 1);
    final nextWeek = DateTime(today.year, today.month, today.day + 7);
    
    final upcomingEvents = events.where((event) {
      final eventDate = DateTime(event.date.year, event.date.month, event.date.day);
      return eventDate.isAfter(today);
    }).toList()
    ..sort((a, b) => a.date.compareTo(b.date));

    return Container(
      color: const Color(0xFF121212),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Events',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Today
                const Text('Today', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ..._filterEventsByTime(upcomingEvents, today, tomorrow, 'Today'),
                const SizedBox(height: 16),
                
                // Tomorrow
                const Text('Tomorrow', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ..._filterEventsByTime(upcomingEvents, tomorrow, nextWeek, 'Tomorrow'),
                const SizedBox(height: 16),
                
                // This Week
                const Text('This Week', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ..._filterEventsByTime(upcomingEvents, nextWeek, DateTime(today.year, today.month, today.day + 14), 'This Week'),
                const SizedBox(height: 16),
                
                // Later
                const Text('Later', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ..._filterEventsByTime(upcomingEvents, DateTime(today.year, today.month, today.day + 14), null, 'Later'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _filterEventsByTime(List<FamilyEvent> events, DateTime start, DateTime? end, String group) {
    final filtered = events.where((event) {
      final eventDate = DateTime(event.date.year, event.date.month, event.date.day);
      if (end != null) {
        return eventDate.isAtSameMomentAs(start) || 
               (eventDate.isAfter(start) && eventDate.isBefore(end));
      }
      return eventDate.isAfter(start);
    }).toList();

    return filtered.map((event) => _buildEventCard(event)).toList();
  }

  Widget _buildEventCard(FamilyEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            color: event.color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_getMonthName(event.date.month)} ${event.date.day}, ${event.date.hour}:${event.date.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DateTime _getStartOfWeek(DateTime date) {
    final daysUntilStartOfWeek = date.weekday - 1; // Monday = 1, Sunday = 7
    return DateTime(date.year, date.month, date.day - daysUntilStartOfWeek);
  }

  String _getDayName(int dayOfWeek) {
    const weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return weekdays[dayOfWeek - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}