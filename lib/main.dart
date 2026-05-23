import 'dart:ui';
import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'widgets/side_nav.dart';
import 'widgets/calendar_header.dart';
import 'widgets/month_view.dart';
import 'widgets/week_view.dart';
import 'widgets/day_view.dart';
import 'widgets/upcoming_view.dart';
import 'widgets/event_card.dart';
import 'models/partials.dart';

void main() {
  runApp(const FamilyHubApp());
}

class FamilyHubApp extends StatefulWidget {
  const FamilyHubApp({super.key});

  @override
  State<FamilyHubApp> createState() => _FamilyHubAppState();
}

class _FamilyHubAppState extends State<FamilyHubApp> {
  String activeView = 'calendar';
  String viewMode = 'upcoming';
  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FamilyHub',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(primary: Color(0xFF3B82F6)),
      ),
      home: Scaffold(
        body: Stack(
          children: [
            // Full-screen background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1553532434-5ab5b6b84993?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwzfHxhYnN0cmFjdCUyMGNvbG9yZnVsJTIwZ2VvbWV0cmljJTIwcGF0dGVybiUyMG1vZGVybnxlbnwxfHx8fDE3Nzk1NTUwNTd8MA&ixlib=rb-4.1.0&q=80&w=1080'),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
            // Main content overlay
            Row(
              children: [
                // SideNav (64px wide)
                SideNav(currentIndex: 0, onItemSelected: (i) {}),
                // Expanded column for content
                Expanded(
                  child: Column(
                    children: [
                      // CalendarHeader with glass effect
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              color: Colors.white.withOpacity(0.1),
                              child: CalendarHeader(
                                viewMode: viewMode,
                                currentDate: currentDate,
                                onPrevious: () {}, onNext: () {}, onViewModeChanged: (mode) {
                                  setState(() {
                                    viewMode = mode;
                                  });
                                },
                                // onDateChanged: (date) {
                                //   setState(() {
                                //     currentDate = date;
                                //   });
                                // },
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Content area based on viewMode
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                color: Colors.white.withOpacity(0.1),
                                child: _buildContentView(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // FAB positioned bottom-right
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  // Add event functionality
                },
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentView() {
    switch (viewMode) {
      case 'upcoming':
        return UpcomingView(currentDate: DateTime.now());
      case 'day':
        return DayView(selectedDate: currentDate);
      case 'week':
        return WeekView(currentDate: DateTime.now());
      case 'month':
        return MonthView(currentDate: DateTime.now(), events: const []);
      default:
        return MonthView(currentDate: DateTime.now(), events: const []);
    }
  }
}