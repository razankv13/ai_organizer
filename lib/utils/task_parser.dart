/// Represents a task found in note content
class TaskMatch {
  final String text;
  final bool isCompleted;
  final int startIndex;
  final int endIndex;
  final String fullMatch;

  TaskMatch({
    required this.text,
    required this.isCompleted,
    required this.startIndex,
    required this.endIndex,
    required this.fullMatch,
  });
}

/// Utility class for parsing markdown-style task checkboxes from note content
class TaskParser {
  /// Regular expressions for matching task patterns
  static final RegExp _uncheckedTaskPattern = RegExp(
    r'^\s*[-*]\s*\[ \]\s+(.+)$',
    multiLine: true,
  );

  static final RegExp _checkedTaskPattern = RegExp(
    r'^\s*[-*]\s*\[x\]\s+(.+)$',
    multiLine: true,
    caseSensitive: false,
  );

  static final RegExp _allTaskPattern = RegExp(
    r'^\s*[-*]\s*\[([ x])\]\s+(.+)$',
    multiLine: true,
    caseSensitive: false,
  );

  /// Parse all tasks from note content
  /// Returns a list of TaskMatch objects representing each task found
  static List<TaskMatch> parseTasksFromContent(String content) {
    final tasks = <TaskMatch>[];

    for (final match in _allTaskPattern.allMatches(content)) {
      final checkbox = match.group(1)?.toLowerCase() ?? ' ';
      final taskText = match.group(2)?.trim() ?? '';

      if (taskText.isNotEmpty) {
        tasks.add(TaskMatch(
          text: taskText,
          isCompleted: checkbox == 'x',
          startIndex: match.start,
          endIndex: match.end,
          fullMatch: match.group(0) ?? '',
        ));
      }
    }

    return tasks;
  }

  /// Count incomplete tasks in content
  static int countIncompleteTasks(String content) {
    return _uncheckedTaskPattern.allMatches(content).length;
  }

  /// Count completed tasks in content
  static int countCompletedTasks(String content) {
    return _checkedTaskPattern.allMatches(content).length;
  }

  /// Count all tasks in content
  static int countAllTasks(String content) {
    return _allTaskPattern.allMatches(content).length;
  }

  /// Check if content contains any tasks
  static bool hasTasks(String content) {
    return _allTaskPattern.hasMatch(content);
  }

  /// Toggle a task's completion status at a specific index
  /// Returns the updated content
  static String toggleTaskAtIndex(String content, int taskIndex) {
    final tasks = parseTasksFromContent(content);

    if (taskIndex < 0 || taskIndex >= tasks.length) {
      return content;
    }

    final task = tasks[taskIndex];
    final newCheckbox = task.isCompleted ? '[ ]' : '[x]';
    final newLine = task.fullMatch.replaceFirst(
      RegExp(r'\[([ x])\]', caseSensitive: false),
      newCheckbox,
    );

    return content.replaceRange(
      task.startIndex,
      task.endIndex,
      newLine,
    );
  }

  /// Convert a plain text task into markdown format
  /// Example: "Buy groceries" -> "- [ ] Buy groceries"
  static String formatAsTask(String text, {bool isCompleted = false}) {
    final checkbox = isCompleted ? '[x]' : '[ ]';
    return '- $checkbox $text';
  }

  /// Extract plain text from a markdown task line
  /// Example: "- [ ] Buy groceries" -> "Buy groceries"
  static String extractTaskText(String taskLine) {
    final match = _allTaskPattern.firstMatch(taskLine);
    return match?.group(2)?.trim() ?? taskLine.trim();
  }

  /// Check if a specific line is a task
  static bool isTaskLine(String line) {
    return _allTaskPattern.hasMatch(line);
  }

  /// Find task at cursor position
  /// Returns the task index if cursor is on a task line, null otherwise
  static int? findTaskAtPosition(String content, int cursorPosition) {
    final tasks = parseTasksFromContent(content);

    for (var i = 0; i < tasks.length; i++) {
      final task = tasks[i];
      if (cursorPosition >= task.startIndex && cursorPosition <= task.endIndex) {
        return i;
      }
    }

    return null;
  }

  /// Get task completion percentage
  static double getCompletionPercentage(String content) {
    final total = countAllTasks(content);
    if (total == 0) return 0.0;

    final completed = countCompletedTasks(content);
    return (completed / total) * 100;
  }

  /// Convert content with inline tasks to separate task list
  /// Useful for extracting tasks to create Task models
  static List<Map<String, dynamic>> extractTasksForDatabase(String content) {
    final tasks = parseTasksFromContent(content);

    return tasks.map((task) {
      return {
        'title': task.text,
        'isCompleted': task.isCompleted,
      };
    }).toList();
  }

  /// Update content to reflect task completion from database
  /// Synchronizes markdown checkboxes with actual task states
  static String syncTasksWithDatabase(
    String content,
    List<Map<String, bool>> taskStates,
  ) {
    final tasks = parseTasksFromContent(content);

    if (tasks.length != taskStates.length) {
      return content;
    }

    var updatedContent = content;
    var offset = 0;

    for (var i = 0; i < tasks.length; i++) {
      final task = tasks[i];
      final shouldBeCompleted = taskStates[i]['isCompleted'] ?? false;

      if (task.isCompleted != shouldBeCompleted) {
        final newCheckbox = shouldBeCompleted ? '[x]' : '[ ]';
        final newLine = task.fullMatch.replaceFirst(
          RegExp(r'\[([ x])\]', caseSensitive: false),
          newCheckbox,
        );

        final startWithOffset = task.startIndex + offset;
        final endWithOffset = task.endIndex + offset;

        updatedContent = updatedContent.replaceRange(
          startWithOffset,
          endWithOffset,
          newLine,
        );

        offset += newLine.length - (task.endIndex - task.startIndex);
      }
    }

    return updatedContent;
  }
}
