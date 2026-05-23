import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/partials.dart';
import '../services/calendar_service.dart';

/// Calendar page — clearly visible event list from mock data.
class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(calendarNotifierProvider);

    return Container(
      color: const Color(0xFFF5F5F5),
      child: eventsAsync.when(
        data: (events) => Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              color: const Color(0xFF1A73E8),
              width: double.infinity,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('FAMILYHUB', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('May 2026', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                const SizedBox(height: 8),
                Text('${events.length} events this month', style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ]),
            ),
            // Event list
            Expanded(
              child: events.isEmpty
                ? const Center(child: Text('No events', style: TextStyle(fontSize: 18, color: Colors.grey)))
                : ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    itemCount: events.length,
                    itemBuilder: (_, i) {
                      final e = events[i];
                      final timeStr = '${e.startTime.hour.toString().padLeft(2, '0')}:${e.startTime.minute.toString().padLeft(2, '0')}';
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Tapped: ${e.summary} at ${e.startTime.hour}:${e.startTime.minute.toString().padLeft(2, '0')}'),
                                margin: EdgeInsets.only(bottom: 56),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF1A73E8),
                            child: Text(timeStr, style: const TextStyle(color: Colors.white, fontSize: 11)),
                          ),
                          title: Text(e.summary, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text('${e.startTime.month}/${e.startTime.day}'),
                          trailing: e.calendars.isNotEmpty
                              ? Chip(label: Text(e.calendars.first, style: const TextStyle(fontSize: 11)))
                              : null,
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
