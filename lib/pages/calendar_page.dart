import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/partials.dart';
import '../services/calendar_service.dart';
import '../services/weather_service.dart';
import '../widgets/month_grid.dart';
import '../widgets/add_event_sheet.dart';

/// Calendar page — full month grid with weather per day.
class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  int _monthOffset = 0;
  DateTime _selectedDate = DateTime.now();
  String _viewMode = 'Month'; // Upcoming | Day | Week | Month

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(calendarNotifierProvider);
    final weekForecast = ref.watch(weekForecastProvider);

    return Container(
      color: const Color(0xFF121212),
      child: eventsAsync.when(
        data: (events) {
          return Column(
            children: [
              const SizedBox(height: 64), // Space for top nav bar
              // View switcher
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    _viewChip('Upcoming'),
                    const SizedBox(width: 8),
                    _viewChip('Day'),
                    const SizedBox(width: 8),
                    _viewChip('Week'),
                    const SizedBox(width: 8),
                    _viewChip('Month'),
                    const Spacer(),
                    // FAB for add event
                    FloatingActionButton.small(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (ctx) => AddEventSheet(
                          selectedDate: _selectedDate,
                          calendars: const [],
                        ),
                      ),
                      backgroundColor: const Color(0xFF1A73E8),
                      child: const Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
              // Month grid
              Expanded(
                child: MonthGrid(
                  selectedDate: _selectedDate,
                  monthOffset: _monthOffset,
                  events: events,
                  onTapDate: (d) => setState(() => _selectedDate = d),
                  onMonthChange: (o) => setState(() => _monthOffset = o),
                ),
              ),
              // Selected date events
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: _buildSelectedEvents(events),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (e, _) => Center(child: Text('$e', style: const TextStyle(color: Colors.white70))),
      ),
    );
  }

  Widget _viewChip(String label) {
    final active = _viewMode == label;
    return GestureDetector(
      onTap: () => setState(() => _viewMode = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1A73E8) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? const Color(0xFF1A73E8) : Colors.white24),
        ),
        child: Text(label, style: TextStyle(
          color: active ? Colors.white : Colors.white60,
          fontSize: 12, fontWeight: FontWeight.w500,
        )),
      ),
    );
  }

  Widget _buildSelectedEvents(List<FamilyEvent> events) {
    final dayEvents = events.where((e) =>
      e.startTime.year == _selectedDate.year &&
      e.startTime.month == _selectedDate.month &&
      e.startTime.day == _selectedDate.day
    ).toList();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: dayEvents.isEmpty
              ? const Center(child: Text('No events', style: TextStyle(color: Colors.white30, fontSize: 14)))
              : ListView.separated(
                  itemCount: dayEvents.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.white12),
                  itemBuilder: (_, i) {
                    final e = dayEvents[i];
                    final time = '${e.startTime.hour.toString().padLeft(2, '0')}:${e.startTime.minute.toString().padLeft(2, '0')}';
                    return ListTile(
                      dense: true,
                      leading: Container(
                        width: 3, height: 24,
                        color: const Color(0xFF1A73E8),
                      ),
                      title: Text(e.summary, style: const TextStyle(color: Colors.white, fontSize: 13)),
                      subtitle: Text(time, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
