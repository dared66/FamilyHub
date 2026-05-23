part of 'partials.dart';

/// Represents a calendar event from Google Calendar.
///
/// Parses the Google Calendar API events resource and exposes
/// fields needed for the calendar and agenda views.
class FamilyEvent {
  /// Unique identifier for the event.
  final String id;

  /// Short summary/title of the event.
  final String summary;

  /// Plain-text description of the event.
  final String description;

  /// Rich HTML description of the event (may be null).
  final String? htmlDescription;

  /// Location where the event takes place (may be null).
  final String? location;

  /// Start time of the event.
  final DateTime startTime;

  /// End time of the event.
  final DateTime endTime;

  /// Whether the event spans the whole day.
  final bool allDay;

  /// Start date for all-day events (may be null).
  final DateTime? startDate;

  /// End date for all-day events (may be null).
  final DateTime? endDate;

  /// List of calendar IDs this event belongs to.
  final List<String> calendars;

  /// Display color for the event (may be null).
  final String? color;

  const FamilyEvent({
    required this.id,
    required this.summary,
    required this.description,
    this.htmlDescription,
    this.location,
    required this.startTime,
    required this.endTime,
    required this.allDay,
    this.startDate,
    this.endDate,
    this.calendars = const [],
    this.color,
  });

  /// Creates a [FamilyEvent] from a Google Calendar API events response map.
  ///
  /// Handles both instant (dateTime) and all-day (date) start/end fields.
  factory FamilyEvent.fromJson(Map<String, dynamic> json) {
    final start = json['start'] as Map<String, dynamic>? ?? {};
    final end = json['end'] as Map<String, dynamic>? ?? {};

    final startDateTime = start['dateTime'] as String?;
    final startDateStr = start['date'] as String?;
    final endDateTime = end['dateTime'] as String?;
    final endDateStr = end['date'] as String?;

    final isAllDay = startDateStr != null;

    DateTime startTime;
    DateTime endTime;

    if (startDateTime != null) {
      startTime = DateTime.tryParse(startDateTime) ?? DateTime.now();
    } else if (startDateStr != null) {
      startTime = DateTime.parse(startDateStr);
    } else {
      startTime = DateTime.now();
    }

    if (endDateTime != null) {
      endTime = DateTime.tryParse(endDateTime) ?? DateTime.now();
    } else if (endDateStr != null) {
      endTime = DateTime.parse(endDateStr);
    } else {
      endTime = DateTime.now();
    }

    // For all-day events, the end date is the day after the last day,
    // so subtract one day to get the actual end date.
    final actualEndDate = isAllDay && endDateStr != null
        ? DateTime.parse(endDateStr).subtract(const Duration(days: 1))
        : null;

    return FamilyEvent(
      id: json['id'] as String? ?? '',
      summary: json['summary'] as String? ?? 'Untitled Event',
      description: json['description'] as String? ?? '',
      htmlDescription: json['htmlDescription'] as String?,
      location: json['location'] as String?,
      startTime: startTime,
      endTime: endTime,
      allDay: isAllDay,
      startDate: startDateStr != null ? DateTime.parse(startDateStr) : null,
      endDate: actualEndDate,
      calendars: [],
      color: json['color'] as String?,
    );
  }

  /// Serializes the event back to a Google Calendar API-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'summary': summary,
      'description': description,
      'htmlDescription': htmlDescription,
      'location': location,
      if (!allDay)
        'start': {
          'dateTime': startTime.toUtc().toIso8601String(),
        }
      else
        'start': {
          'date': startDate?.toIso8601String() ?? startTime.toIso8601String(),
        },
      if (!allDay)
        'end': {
          'dateTime': endTime.toUtc().toIso8601String(),
        }
      else
        'end': {
          'date': endDate?.toIso8601String() ?? endTime.toIso8601String(),
        },
      'allDay': allDay,
      'calendars': calendars,
      'color': color,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FamilyEvent) return false;
    if (id != other.id) return false;
    if (summary != other.summary) return false;
    if (description != other.description) return false;
    if (htmlDescription != other.htmlDescription) return false;
    if (location != other.location) return false;
    if (startTime != other.startTime) return false;
    if (endTime != other.endTime) return false;
    if (allDay != other.allDay) return false;
    if (startDate != other.startDate) return false;
    if (endDate != other.endDate) return false;
    if (color != other.color) return false;
    if (calendars.length != other.calendars.length) return false;
    for (int i = 0; i < calendars.length; i++) {
      if (calendars[i] != other.calendars[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      summary,
      description,
      htmlDescription,
      location,
      startTime,
      endTime,
      allDay,
      startDate,
      endDate,
      color,
      Object.hashAll(calendars),
    );
  }

  /// Returns a copy of this event with the given fields replaced.
  FamilyEvent copyWith({
    String? id,
    String? summary,
    String? description,
    String? htmlDescription,
    String? location,
    DateTime? startTime,
    DateTime? endTime,
    bool? allDay,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? calendars,
    String? color,
  }) {
    return FamilyEvent(
      id: id ?? this.id,
      summary: summary ?? this.summary,
      description: description ?? this.description,
      htmlDescription: htmlDescription ?? this.htmlDescription,
      location: location ?? this.location,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      allDay: allDay ?? this.allDay,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      calendars: calendars ?? this.calendars,
      color: color ?? this.color,
    );
  }

  @override
  String toString() =>
      'FamilyEvent(id: $id, summary: $summary, allDay: $allDay, startTime: $startTime)';
}
