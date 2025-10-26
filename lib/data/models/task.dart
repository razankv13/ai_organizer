import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
abstract class Task with _$Task {
  const factory Task({
    required String id,
    required String noteId,
    required String title,
    String? description,
    required bool isCompleted,
    DateTime? dueDate,
    DateTime? reminderDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool hasNotified,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
