import 'package:flutter/material.dart';

class MonthView extends StatelessWidget {
  final DateTime currentDate;
  final List<FamilyEvent> events;

  const MonthView({
    Key? key,
    required this.currentDate,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the number of days in the current month
    final int daysInMonth = DateTime(currentDate.year, currentDate.month + 1, 0).day;
    
    // Get the weekday of the first day of the month (1 = Sunday, 2 = Monday, etc.)
    final int firstDayOfWeek = DateTime(currentDate.year, currentDate.month, 1).weekday;
    
    // Calculate how many days from the previous month to show
    final int daysFromPrevMonth = firstDayOfWeek - 1;

    // Create a list of all days in the month grid (including previous/next month days)
    final List<DateTime> days = [];
    
    // Add days from previous month
    final prevMonthDays = DateTime(currentDate.year, currentDate.month, 0).day;
    for (int i = daysFromPrevMonth - 1; i >= 0; i--) {
      days.add(DateTime(currentDate.year, currentDate.month - 1, prevMonthDays - i));
    }

    // Add current month days
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(currentDate.year, currentDate.month, i));
    }

    // Add days from next month to complete the grid (42 days = 6 rows × 7 columns)
    final int daysInGrid = 42;
    final int remainingDays = daysInGrid - days.length;
    for (int i = 1; i <= remainingDays; i++) {
      days.add(DateTime(currentDate.year, currentDate.month + 1, i));
    }

    // Find today's index in the list for highlighting
    final int todayIndex = days.indexWhere((day) => 
        day.year == DateTime.now().year && 
        day.month == DateTime.now().month && 
        day.day == DateTime.now().day);

    return Container(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        color: Colors.white,
      ),
      child: Column(
        children: [
          // Day headers row
          Row(
            children: [
              for (int i = 0; i < 7; i++)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          i == 0 ? const Color(0xFFFE5A5A).withOpacity(0.2) : const Color(0xFFFE5A5A).withOpacity(0.2),
                          i == 0 ? const Color(0xFFFE5A5A) : const Color(0xFFFE5A5A).withOpacity(0.2),
                          i == 1 ? const Color(0xFF43B4FE).withOpacity(0.2) : const Color(0xFF43B4FE).withOpacity(0.2),
                          i == 1 ? const Color(0xFF43B4FE) : const Color(0xFF43B4FE).withOpacity(0.2),
                          i == 2 ? const Color(0xFF3B6CFF).withOpacity(0.2) : const Color(0xFF3B6CFF).withOpacity(0.2),
                          i == 2 ? const Color(0xFF3B6CFF) : const Color(0xFF3B6CFF).withOpacity(0.2),
                          i == 3 ? const Color(0xFF8645FF).withOpacity(0.2) : const Color(0xFF8645FF).withOpacity(0.2),
                          i == 3 ? const Color(0xFF8645FF) : const Color(0xFF8645FF).withOpacity(0.2),
                          i == 4 ? const Color(0xFF3E8355).withOpacity(0.2) : const Color(0xFF3E8355).withOpacity(0.2),
                          i == 4 ? const Color(0xFF3E8355) : const Color(0xFF3E8355).withOpacity(0.2),
                          i == 5 ? const Color(0xFF60A300).withOpacity(0.2) : const Color(0xFF60A300).withOpacity(0.2),
                          i == 5 ? const Color(0xFF60A300) : const Color(0xFF60A300).withOpacity(0.2),
                          i == 6 ? const Color(0xFFFA732C).withOpacity(0.2) : const Color(0xFFFA732C).withOpacity(0.2),
                          i == 6 ? const Color(0xFFFA732C) : const Color(0xFFFA732C).withOpacity(0.2),
                        ],
                      ),
                      border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3), width: 2)),
                    ),
                    child: Text(
                      ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][i],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Calendar grid
          Column(
            children: List.generate(6, (rowIndex) {
              return Row(
                children: List.generate(7, (colIndex) {
                  final int dayIndex = rowIndex * 7 + colIndex;
                  final DateTime day = days[dayIndex];
                  final bool isCurrentMonth = day.month == currentDate.month;
                  final bool isToday = todayIndex == dayIndex;
                  
                  // Generate mock weather data based on day number
                  final String weatherType = ['sunny', 'cloudy', 'rainy', 'partly-cloudy'][day.day % 4];
                  final int highTemp = 65 + (day.day % 15);
                  final int lowTemp = 45 + (day.day % 10);
                  final String weatherEmoji = getWeatherEmoji(weatherType);
                  
                  // Generate mock events for this day
                  final int eventCount = day.day % 3;
                  final List<String> eventColors = ['#3B82F6', '#8B5CF6', '#22C55E', '#F97316', '#EC4899'];
                  final List<String> eventTitles = ['Meeting', 'Call', 'Lunch'];

                  return Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isToday ? Colors.blue.shade100 : null,
                        border: Border.all(
                          color: isToday ? Colors.blue : Colors.transparent,
                          width: isToday ? 2 : 0,
                        ),
                        boxShadow: [
                          if (!isCurrentMonth)
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.8),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                day.day.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isCurrentMonth 
                                      ? (isToday ? Colors.blue : Colors.black) 
                                      : Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.8),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '$weatherEmoji $highTemp° / $lowTemp°',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isCurrentMonth ? Colors.black : Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (eventCount > 0) 
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  eventCount,
                                  (index) {
                                    return Container(
                                      width: 5,
                                      height: 5,
                                      margin: const EdgeInsets.symmetric(horizontal: 2),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(int.parse(eventColors[index % 5].replaceAll('#', '0xFF'))),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        ],
      ),
    );
  }

  String getWeatherEmoji(String type) {
    switch (type) {
      case 'sunny':
        return '☀️';
      case 'cloudy':
        return '☁️';
      case 'rainy':
        return '🌧️';
      case 'partly-cloudy':
        return '⛅';
      default:
        return '☀️';
    }
  }
}

// Simple FamilyEvent model for demonstration purposes
class FamilyEvent {
  final String title;
  final String color;
  final DateTime date;

  FamilyEvent({
    required this.title,
    required this.color,
    required this.date,
  });
}