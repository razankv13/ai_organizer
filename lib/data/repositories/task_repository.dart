import 'package:ai_organizer/data/database/app_database.dart';
import 'package:ai_organizer/data/models/task.dart';

class TaskRepository {
  final AppDatabase _database;

  TaskRepository(this._database);

  /// Get all tasks for a specific note
  Future<List<Task>> getTasksForNote(String noteId) async {
    return await _database.getTasksForNote(noteId);
  }

  /// Get a task by ID
  Future<Task?> getTaskById(String id) async {
    return await _database.getTaskById(id);
  }

  /// Get all upcoming tasks (with reminders due before a certain date)
  Future<List<Task>> getUpcomingTasks(DateTime before) async {
    return await _database.getUpcomingTasks(before);
  }

  /// Get all tasks, optionally filtered by completion status
  Future<List<Task>> getAllTasks({bool? completed}) async {
    return await _database.getAllTasks(completed: completed);
  }

  /// Create a new task
  Future<void> createTask(Task task) async {
    await _database.insertTask(task);
  }

  /// Update an existing task
  Future<bool> updateTask(Task task) async {
    return await _database.updateTask(task);
  }

  /// Delete a task
  Future<void> deleteTask(String id) async {
    await _database.deleteTask(id);
  }

  /// Toggle task completion status
  Future<void> toggleTaskCompletion(String id) async {
    await _database.toggleTaskCompletion(id);
  }

  /// Delete all tasks for a note
  Future<void> deleteTasksForNote(String noteId) async {
    await _database.deleteTasksForNote(noteId);
  }

  /// Get count of incomplete tasks for a note
  Future<int> getIncompleteTaskCount(String noteId) async {
    return await _database.getIncompleteTaskCount(noteId);
  }

  /// Get tasks due today
  Future<List<Task>> getTasksDueToday() async {
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return await _database.getUpcomingTasks(endOfDay);
  }

  /// Get overdue tasks (incomplete tasks with due date in the past)
  Future<List<Task>> getOverdueTasks() async {
    final allTasks = await _database.getAllTasks(completed: false);
    final now = DateTime.now();
    return allTasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.isBefore(now);
    }).toList();
  }
}
