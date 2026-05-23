import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/partials.dart';

/// Mock TasksService — returns fake data immediately, no API calls.
class TasksService {
  final Map<String, List<TaskItem>> store = {};
  final Map<String, TaskList> listStore = {};

  TasksService() {
    listStore['chores'] = TaskList(id: 'chores', title: 'Chores');
    listStore['shopping'] = TaskList(id: 'shopping', title: 'Shopping');
    listStore['meal_plan'] = TaskList(id: 'meal_plan', title: 'Meal Plan');
    listStore['general'] = TaskList(id: 'general', title: 'General');

    final now = DateTime.now();
    store['chores'] = [
      TaskItem(id: 'ch_1', title: 'Take out trash', notes: null, due: now.add(const Duration(days: 1)), position: '1', status: TaskStatus.needsAction, created: now, updated: now),
      TaskItem(id: 'ch_2', title: 'Vacuum living room', notes: null, due: now.add(const Duration(days: 3)), position: '2', status: TaskStatus.needsAction, created: now, updated: now),
      TaskItem(id: 'ch_3', title: 'Clean kitchen counters', notes: null, due: null, position: '3', status: TaskStatus.completed, created: now, updated: now),
    ];
    store['shopping'] = [
      TaskItem(id: 'sh_1', title: 'Milk', notes: '2% organic', due: now.add(const Duration(hours: 6)), position: '1', status: TaskStatus.needsAction, created: now, updated: now),
      TaskItem(id: 'sh_2', title: 'Eggs', notes: '1 dozen', due: null, position: '2', status: TaskStatus.needsAction, created: now, updated: now),
      TaskItem(id: 'sh_3', title: 'Bread', notes: 'Whole wheat', due: null, position: '3', status: TaskStatus.completed, created: now, updated: now),
    ];
    store['meal_plan'] = [
      TaskItem(id: 'mp_1', title: 'Plan dinners for week', notes: null, due: now.add(const Duration(days: 1)), position: '1', status: TaskStatus.needsAction, created: now, updated: now),
      TaskItem(id: 'mp_2', title: 'Prep lunches Mon-Wed', notes: null, due: now.add(const Duration(days: 2)), position: '2', status: TaskStatus.needsAction, created: now, updated: now),
      TaskItem(id: 'mp_3', title: 'Marinade chicken', notes: null, due: null, position: '3', status: TaskStatus.completed, created: now, updated: now),
    ];
    store['general'] = [
      TaskItem(id: 'gn_1', title: 'Call mom', notes: 'Her birthday is coming up', due: now.add(const Duration(days: 7)), position: '1', status: TaskStatus.needsAction, created: now, updated: now),
      TaskItem(id: 'gn_2', title: 'Fix leaky faucet', notes: null, due: now.add(const Duration(days: 14)), position: '2', status: TaskStatus.needsAction, created: now, updated: now),
      TaskItem(id: 'gn_3', title: 'Schedule dentist', notes: null, due: null, position: '3', status: TaskStatus.completed, created: now, updated: now),
    ];
  }

  List<TaskList> getLists() => listStore.values.toList();
  List<TaskItem> getTasks(String listId) => List.from(store[listId] ?? []);

  TaskItem createTask({required String listId, required String title, String? notes, DateTime? due}) {
    final task = TaskItem(
      id: 'new_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      notes: notes,
      due: due,
      position: '${(store[listId]?.length ?? 0) + 1}',
      status: TaskStatus.needsAction,
      created: DateTime.now(),
      updated: DateTime.now(),
    );
    store.putIfAbsent(listId, () => []).add(task);
    return task;
  }

  void toggleTask(String listId, String taskId) {
    final list = store[listId];
    if (list == null) return;
    final idx = list.indexWhere((t) => t.id == taskId);
    if (idx < 0) return;
    final t = list[idx];
    list[idx] = TaskItem(
      id: t.id, title: t.title, notes: t.notes, due: t.due,
      position: t.position,
      status: t.status == TaskStatus.completed ? TaskStatus.needsAction : TaskStatus.completed,
      created: t.created, updated: DateTime.now(),
    );
  }

  void deleteTask(String listId, String taskId) {
    store[listId]?.removeWhere((t) => t.id == taskId);
  }
}

final tasksServiceProvider = Provider<TasksService>((ref) => TasksService());

class TasksNotifier extends AsyncNotifier<Map<String, List<TaskItem>>> {
  @override
  Future<Map<String, List<TaskItem>>> build() async {
    final svc = ref.read(tasksServiceProvider);
    return Map.from(svc.store);
  }

  Future<void> refresh() async {
    final svc = ref.read(tasksServiceProvider);
    state = AsyncData(Map.from(svc.store));
  }

  void toggleTask(String listId, String taskId) {
    final svc = ref.read(tasksServiceProvider);
    svc.toggleTask(listId, taskId);
    state = AsyncData(Map.from(svc.store));
  }

  void addTask(String listId, TaskItem task) {
    final svc = ref.read(tasksServiceProvider);
    svc.createTask(listId: listId, title: task.title, notes: task.notes, due: task.due);
    state = AsyncData(Map.from(svc.store));
  }
}

final tasksNotifierProvider = AsyncNotifierProvider<TasksNotifier, Map<String, List<TaskItem>>>(
  TasksNotifier.new,
);
