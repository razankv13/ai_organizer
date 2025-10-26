import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_organizer/data/models/task.dart';
import 'package:ai_organizer/data/repositories/task_repository.dart';
import 'package:ai_organizer/providers/database_provider.dart';

/// Provider for task repository
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return TaskRepository(database);
});

/// Get all tasks for a specific note
final tasksForNoteProvider = FutureProvider.family<List<Task>, String>((ref, noteId) async {
  final repository = ref.watch(taskRepositoryProvider);
  return await repository.getTasksForNote(noteId);
});

/// Get a task by ID
final taskByIdProvider = FutureProvider.family<Task?, String>((ref, id) async {
  final repository = ref.watch(taskRepositoryProvider);
  return await repository.getTaskById(id);
});

/// Get upcoming tasks (with reminders)
final upcomingTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  final oneWeekFromNow = DateTime.now().add(const Duration(days: 7));
  return await repository.getUpcomingTasks(oneWeekFromNow);
});

/// Get all tasks (both completed and incomplete)
final allTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  return await repository.getAllTasks();
});

/// Get all incomplete tasks
final incompleteTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  return await repository.getAllTasks(completed: false);
});

/// Get all completed tasks
final completedTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  return await repository.getAllTasks(completed: true);
});

/// Get tasks due today
final tasksDueTodayProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  return await repository.getTasksDueToday();
});

/// Get overdue tasks
final overdueTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  return await repository.getOverdueTasks();
});

/// Get incomplete task count for a note
final incompleteTaskCountProvider = FutureProvider.family<int, String>((ref, noteId) async {
  final repository = ref.watch(taskRepositoryProvider);
  return await repository.getIncompleteTaskCount(noteId);
});

/// Actions class for task mutations
class TaskActions {
  TaskActions(this._ref);

  final Ref _ref;

  TaskRepository get _repository => _ref.read(taskRepositoryProvider);

  /// Create a new task
  Future<void> createTask(Task task) async {
    await _repository.createTask(task);
    _invalidateTaskProviders();
  }

  /// Update an existing task
  Future<bool> updateTask(Task task) async {
    final result = await _repository.updateTask(task);
    if (result) {
      _invalidateTaskProviders();
    }
    return result;
  }

  /// Delete a task
  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    _invalidateTaskProviders();
  }

  /// Toggle task completion status
  Future<void> toggleTaskCompletion(String id) async {
    await _repository.toggleTaskCompletion(id);
    _invalidateTaskProviders();
  }

  /// Delete all tasks for a note
  Future<void> deleteTasksForNote(String noteId) async {
    await _repository.deleteTasksForNote(noteId);
    _invalidateTaskProviders();
  }

  /// Invalidate task providers to refresh data
  void _invalidateTaskProviders() {
    _ref.invalidate(allTasksProvider);
    _ref.invalidate(upcomingTasksProvider);
    _ref.invalidate(incompleteTasksProvider);
    _ref.invalidate(completedTasksProvider);
    _ref.invalidate(tasksDueTodayProvider);
    _ref.invalidate(overdueTasksProvider);
    // Note: tasksForNoteProvider and taskByIdProvider are family providers
    // and will be automatically refreshed when accessed
  }
}

/// Provider for task actions
final taskActionsProvider = Provider<TaskActions>((ref) {
  return TaskActions(ref);
});
