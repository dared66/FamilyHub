import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/partials.dart';
import '../core/theme.dart';
import '../core/const.dart';
import 'event_card.dart';

/// Scrollable agenda list for a selected date.
class AgendaList extends StatelessWidget {
  final DateTime date;
  final List<FamilyEvent> events;

  const AgendaList({super.key, required this.date, required this.events});

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat.EEEE().format(date);
    final shortDate = DateFormat.MMMEd().format(date);

    // Sort: all-day first, then by start time
    final sorted = List<FamilyEvent>.from(events)
      ..sort((a, b) {
        if (a.allDay && !b.allDay) return -1;
        if (!a.allDay && b.allDay) return 1;
        return a.startTime.compareTo(b.startTime);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            '$formatted, $shortDate',
            style: AppTheme.darkTheme.textTheme.titleLarge
                ?.copyWith(color: textPrimary),
          ),
        ),
        if (sorted.isEmpty)
          const Expanded(
            child: Center(
              child: Text(
                'No events',
                style: TextStyle(color: textSecondary, fontSize: 16),
              ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: sorted.length,
            itemBuilder: (ctx, i) {
              return EventCard(event: sorted[i]);
            },
          ),
        ),
      ],
    );
  }
}
