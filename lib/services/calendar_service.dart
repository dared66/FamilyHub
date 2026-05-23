import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/partials.dart';

/// Mock CalendarService — returns fake data immediately, no API calls.
class CalendarService {
  final Random _rnd = Random(42);

  List<TaskList> fetchCalendars() {
    return [
      TaskList(id: 'cal_family', title: 'Family'),
      TaskList(id: 'cal_work', title: 'Work'),
      TaskList(id: 'cal_holidays', title: 'Holidays'),
    ];
  }

  List<FamilyEvent> fetchEvents({String? calendarId, bool force = false}) {
    final now = DateTime.now();
    final events = <FamilyEvent>[];
    final titles = [
      'Dentist appointment', 'Soccer practice', 'Grocery run',
      'Team standup', 'Anniversary dinner', 'Parent-teacher conference',
      'Gym session', 'Book club meeting', 'Birthday party',
      'Doctor checkup', 'Car maintenance', 'Movie night',
    ];

    for (int i = 0; i < 8; i++) {
      final day = 1 + _rnd.nextInt(28);
      final hour = 8 + _rnd.nextInt(12);
      final startTime = DateTime(now.year, now.month, day, hour, 0);
      final endTime = startTime.add(Duration(hours: 1 + _rnd.nextInt(2)));
      events.add(FamilyEvent(
        id: 'evt_$i',
        summary: titles[i],
        description: '',
        htmlDescription: null,
        location: null,
        startTime: startTime,
        endTime: endTime,
        allDay: false,
        startDate: null,
        endDate: null,
        calendars: [],
        color: null,
      ));
    }
    events.sort((a, b) => a.startTime.compareTo(b.startTime));
    return events;
  }

  FamilyEvent createEvent({
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    String? description,
    String? location,
    String? calendarId,
  }) {
    return FamilyEvent(
      id: 'evt_new_${DateTime.now().millisecondsSinceEpoch}',
      summary: title,
      description: description ?? '',
      startTime: startTime,
      endTime: endTime,
      allDay: false,
      calendars: calendarId != null ? [calendarId] : [],
    );
  }
}

final calendarServiceProvider = Provider<CalendarService>((ref) => CalendarService());

class CalendarNotifier extends AsyncNotifier<List<FamilyEvent>> {
  @override
  Future<List<FamilyEvent>> build() async {
    return ref.read(calendarServiceProvider).fetchEvents();
  }

  Future<void> refresh() async {
    state = AsyncData(await ref.read(calendarServiceProvider).fetchEvents(force: true));
  }

  Future<void> addEvent(FamilyEvent event) async {
    final created = ref.read(calendarServiceProvider).createEvent(
      title: event.summary,
      startTime: event.startTime,
      endTime: event.endTime,
      description: event.description,
    );
    state = AsyncData([...?state.value, created]);
  }
}

final calendarNotifierProvider = AsyncNotifierProvider<CalendarNotifier, List<FamilyEvent>>(
  CalendarNotifier.new,
);