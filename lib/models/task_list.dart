part of 'partials.dart';

/// A Google Tasks task list that contains [TaskItem]s.
///
/// Parses the Google Tasks API taskLists response and exposes
/// fields needed for list display and management.
class TaskList {
  /// Unique identifier for the task list.
  final String id;

  /// Display title of the task list.
  final String title;

  /// Summary/description of the task list (may be null).
  final String? summary;

  /// Description of the task list (may be null).
  final String? description;

  /// Ordinal value used for ordering the list (may be null).
  final int? ordinal;

  /// Self-link URI for the task list (may be null).
  final String? selfLink;

  const TaskList({
    required this.id,
    required this.title,
    this.summary,
    this.description,
    this.ordinal,
    this.selfLink,
  });

  /// Creates a [TaskList] from a Google Tasks API taskList resource.
  factory TaskList.fromJson(Map<String, dynamic> json) {
    final ordinalValue = json['ordinal'] as String?;
    int? parsedOrdinal;
    if (ordinalValue != null) {
      parsedOrdinal = int.tryParse(ordinalValue);
    }

    return TaskList(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'My Tasks',
      summary: json['summary'] as String?,
      description: json['description'] as String?,
      ordinal: parsedOrdinal,
      selfLink: json['selfLink'] as String?,
    );
  }

  /// Serializes the task list back to a Google Tasks API-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'description': description,
      'ordinal': ordinal?.toString(),
      'selfLink': selfLink,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TaskList) return false;
    if (id != other.id) return false;
    if (title != other.title) return false;
    if (summary != other.summary) return false;
    if (description != other.description) return false;
    if (ordinal != other.ordinal) return false;
    if (selfLink != other.selfLink) return false;
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      summary,
      description,
      ordinal,
      selfLink,
    );
  }

  @override
  String toString() =>
      'TaskList(id: $id, title: $title, ordinal: $ordinal)';
}
