import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/partials.dart';
import '../services/tasks_service.dart';
import '../services/weather_service.dart';
import '../widgets/add_task_sheet.dart';
import '../widgets/task_tile.dart';
import '../widgets/weather_strip.dart';
import '../widgets/add_task_sheet.dart';
import '../core/theme.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksNotifierProvider);
    
    return tasksAsync.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.task_alt, size: 64, color: Colors.white70),
                  const SizedBox(height: 16),
                  const Text(
                    'FAMILYHUB',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Connect Google Tasks to get started',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final weatherAsync = ref.watch(weatherNotifierProvider);
        final weather = weatherAsync;

        // Get the default lists
        final defaultLists = ['Chores', 'Shopping', 'Meal Plan', 'General'];
        
        // Create tabs for each default list
        final tabs = defaultLists.map((listTitle) {
          return Tab(text: listTitle);
        }).toList();

        // Get tasks for each default list
        final tasksByList = <String, List<TaskItem>>{};
        for (final listTitle in defaultLists) {
          tasksByList[listTitle] = tasks.entries
              .where((entry) => entry.value.any((task) => task.title == listTitle))
              .map((entry) => entry.value)
              .expand((tasks) => tasks)
              .toList();
        }

        // Determine which tab is active (first non-empty tab or first tab)
        int activeTab = 0;
        for (int i = 0; i < tabs.length; i++) {
          if (tasksByList[tabs[i].text!] != null && tasksByList[tabs[i].text!]!.isNotEmpty) {
            activeTab = i;
            break;
          }
        }

        return Scaffold(
          backgroundColor: AppTheme.darkTheme.colorScheme.background,
          appBar: AppBar(
            backgroundColor: AppTheme.darkTheme.colorScheme.background,
            title: const Text('Tasks'),
            elevation: 0,
          ),
          body: DefaultTabController(
            length: tabs.length,
            child: Column(
              children: [
                Container(
                  color: AppTheme.darkTheme.colorScheme.background,
                  child: TabBar(
                    isScrollable: true,
                    tabs: tabs,
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: tabs.asMap().entries.map((entry) {
                      final index = entry.key;
                      final listTitle = entry.value.text!;
                      final tasksForList = tasksByList[listTitle] ?? [];
                      
                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: tasksForList.length,
                        itemBuilder: (context, i) {
                          final task = tasksForList[i];
                          return TaskTile(
                            task: task,
                            listId: '',
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: Text('Loading tasks...'),
        ),
      ),
      error: (error, stack) => const Scaffold(
        body: Center(
          child: Text('Failed to load tasks'),
        ),
      ),
    );
  }
}