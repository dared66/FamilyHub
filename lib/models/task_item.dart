part of 'partials.dart';

/// Represents the completion status of a [TaskItem].
enum TaskStatus {
  /// Task is pending or in progress.
  needsAction,

  /// Task has been completed.
  completed,
}

/// A single task item within a task list.
///
/// Parses the Google Tasks API task resource and exposes
/// fields needed for task display and manipulation.
class TaskItem {
  /// Unique identifier for the task.
  final String id;

  /// Title of the task.
  final String title;

  /// Notes attached to the task (may be null).
  final String? notes;

  /// Due date/time of the task (may be null).
  final DateTime? due;

  /// Position string for ordering (may be null).
  final String? position;

  /// Completion status of the task.
  final TaskStatus status;

  /// Creation timestamp of the task.
  final DateTime created;

  /// Last update timestamp of the task.
  final DateTime updated;

  /// Web link to view the task in Google Tasks (may be null).
  final String? webContentLink;

  const TaskItem({
    required this.id,
    required this.title,
    this.notes,
    this.due,
    this.position,
    required this.status,
    required this.created,
    required this.updated,
    this.webContentLink,
  });

  /// Creates a [TaskItem] from a Google Tasks API task response map.
  factory TaskItem.fromJson(Map<String, dynamic> json) {
    final statusStr = json['status'] as String? ?? 'needsAction';
    final status =
        statusStr == 'completed' ? TaskStatus.completed : TaskStatus.needsAction;

    final links = json['links'] as List<dynamic>?;
    String? webContentLink;
    if (links != null && links.isNotEmpty) {
      final firstLink = links.first as Map<String, dynamic>;
      webContentLink = firstLink['link'] as String?;
    }
    webContentLink ??= json['webViewLink'] as String?;

    return TaskItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled Task',
      notes: json['notes'] as String?,
      due: json['due'] != null
          ? DateTime.tryParse(json['due'] as String)
          : null,
      position: json['position'] as String?,
      status: status,
      created: json['created'] != null
          ? DateTime.parse(json['created'] as String)
          : DateTime.now(),
      updated: json['updated'] != null
          ? DateTime.parse(json['updated'] as String)
          : DateTime.now(),
      webContentLink: webContentLink,
    );
  }

  /// Serializes the task back to a Google Tasks API-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'notes': notes,
      'due': due?.toUtc().toIso8601String(),
      'position': position,
      'status': status == TaskStatus.completed ? 'completed' : 'needsAction',
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
      'webContentLink': webContentLink,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TaskItem) return false;
    if (id != other.id) return false;
    if (title != other.title) return false;
    if (notes != other.notes) return false;
    if (due != other.due) return false;
    if (position != other.position) return false;
    if (status != other.status) return false;
    if (created != other.created) return false;
    if (updated != other.updated) return false;
    if (webContentLink != other.webContentLink) return false;
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      notes,
      due,
      position,
      status,
      created,
      updated,
      webContentLink,
    );
  }

  /// Returns a copy of this task with the given fields replaced.
  TaskItem copyWith({
    String? id,
    String? title,
    String? notes,
    DateTime? due,
    String? position,
    TaskStatus? status,
    DateTime? created,
    DateTime? updated,
    String? webContentLink,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      due: due ?? this.due,
      position: position ?? this.position,
      status: status ?? this.status,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      webContentLink: webContentLink ?? this.webContentLink,
    );
  }

  @override
  String toString() =>
      'TaskItem(id: $id, title: $title, status: $status, due: $due)';
}
