import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/partials.dart';
import '../services/tasks_service.dart';
import '../core/theme.dart';

/// Displays a single task with a checkbox, title, and optional due date.
///
/// Tapping the checkbox toggles completion via [TasksService].
class TaskTile extends ConsumerWidget {
  final TaskItem task;
  final String listId;
  final VoidCallback? onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.listId,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isComplete = task.status == TaskStatus.completed;
    final isOverdue = task.due != null &&
        task.due!.isBefore(DateTime.now()) &&
        !isComplete;

    return ListTile(
      leading: Checkbox(
        value: isComplete,
        onChanged: (_) async {
          final notifier = ref.read(tasksNotifierProvider.notifier);
          try {
            notifier.toggleTask(listId, task.id);
          } catch (_) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to update task'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }
        },
        activeColor: Theme.of(context).colorScheme.primary,
        checkColor: Colors.white,
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: isComplete ? TextDecoration.lineThrough : TextDecoration.none,
          color: isComplete ? Theme.of(context).colorScheme.onSurface : null,
        ),
      ),
      subtitle: task.due != null
          ? Text(
              'Due: ${_formatDate(task.due!)}',
              style: TextStyle(
                fontSize: 12,
                color: isOverdue ? Colors.orange : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: onDelete != null
          ? IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: onDelete,
            )
          : null,
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) return 'Today';
    final tomorrow = now.add(const Duration(days: 1));
    if (d.year == tomorrow.year && d.month == tomorrow.month && d.day == tomorrow.day) return 'Tomorrow';
    return '${d.month}/${d.day}';
  }
}
