import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/data/models/calendar_event.dart';
import 'package:ai_organizer/data/models/task.dart';
import 'package:ai_organizer/providers/calendar_provider.dart';
import 'package:ai_organizer/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarViewScreen extends ConsumerStatefulWidget {
  const CalendarViewScreen({super.key});

  @override
  ConsumerState<CalendarViewScreen> createState() => _CalendarViewScreenState();
}

class _CalendarViewScreenState extends ConsumerState<CalendarViewScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    // Extract theme data
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Get tasks with due dates
    final tasksAsync = ref.watch(allTasksProvider);

    // Get calendar events for current month
    final startOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final endOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    final eventsAsync = ref.watch(
      calendarEventsProvider(DateRange(start: startOfMonth, end: endOfMonth)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to calendar settings
              // This will be added when we integrate navigation
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar widget
          tasksAsync.when(
            data: (tasks) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                  vertical: AppSpacing.sm,
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: _calendarFormat,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  eventLoader: (day) {
                    // Get tasks for this day
                    final dayTasks = tasks.where((task) {
                      if (task.dueDate == null) return false;
                      return isSameDay(task.dueDate, day);
                    }).toList();

                    return dayTasks;
                  },
                  headerStyle: HeaderStyle(
                    titleTextStyle: textTheme.titleLarge!,
                    formatButtonTextStyle: textTheme.labelMedium!.copyWith(
                      color: colorScheme.primary,
                    ),
                    formatButtonDecoration: BoxDecoration(
                      border: Border.all(color: colorScheme.outline),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: colorScheme.onSurface,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: textTheme.labelSmall!.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    weekendStyle: textTheme.labelSmall!.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    // Default day styling
                    defaultTextStyle: textTheme.bodyMedium!.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    weekendTextStyle: textTheme.bodyMedium!.copyWith(
                      color: colorScheme.onSurface,
                    ),

                    // Selected day styling
                    selectedDecoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: textTheme.bodyMedium!.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),

                    // Today styling
                    todayDecoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: textTheme.bodyMedium!.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),

                    // Outside days (other months)
                    outsideTextStyle: textTheme.bodyMedium!.copyWith(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                    ),

                    // Markers (event indicators)
                    markersMaxCount: 3,
                    markerDecoration: BoxDecoration(
                      color: colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    markerSize: 6.0,
                    markerMargin: const EdgeInsets.symmetric(horizontal: 0.5),

                    // Cell padding
                    cellMargin: const EdgeInsets.all(AppSpacing.xxs),
                  ),
                ),
              );
            },
            loading: () => Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ),
            error: (error, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'Error: $error',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          Divider(
            height: 1,
            color: colorScheme.outlineVariant,
          ),

          // Events and tasks for selected day
          Expanded(
            child: _buildDayEvents(tasksAsync, eventsAsync),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create new task/event
          _showCreateEventDialog();
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4.0,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDayEvents(
    AsyncValue<List<Task>> tasksAsync,
    AsyncValue<List<CalendarEvent>> eventsAsync,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_selectedDay == null) {
      return Center(
        child: Text(
          'Select a day to see events and tasks',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return tasksAsync.when(
      data: (tasks) {
        final dayTasks = tasks.where((task) {
          if (task.dueDate == null) return false;
          return isSameDay(task.dueDate, _selectedDay);
        }).toList();

        return eventsAsync.when(
          data: (events) {
            final dayEvents = events.where((event) {
              if (event.startTime == null) return false;
              return isSameDay(event.startTime, _selectedDay);
            }).toList();

            if (dayTasks.isEmpty && dayEvents.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxxl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 64,
                        color: colorScheme.outlineVariant,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        'No events or tasks',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'No events or tasks scheduled for this day',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
                vertical: AppSpacing.screenVertical,
              ),
              children: [
                if (dayTasks.isNotEmpty) ...[
                  Text(
                    'Tasks (${dayTasks.length})',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...dayTasks.map((task) => _buildTaskCard(task, colorScheme, textTheme)),
                  const SizedBox(height: AppSpacing.xl),
                ],
                if (dayEvents.isNotEmpty) ...[
                  Text(
                    'Calendar Events (${dayEvents.length})',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...dayEvents.map((event) => _buildEventCard(event, colorScheme, textTheme)),
                ],
              ],
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(
                'Error loading events: $error',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            'Error loading tasks: $error',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task, ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.cardMargin),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to task detail
          },
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              children: [
                // Checkbox icon
                Icon(
                  task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                  color: task.isCompleted
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  size: AppSpacing.iconSize,
                ),
                const SizedBox(width: AppSpacing.md),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: textTheme.titleMedium?.copyWith(
                          color: task.isCompleted
                              ? colorScheme.onSurfaceVariant
                              : colorScheme.onSurface,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      if (task.description != null && task.description!.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          task.description!,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Time
                if (task.dueDate != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    _formatTime(task.dueDate!),
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(CalendarEvent event, ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.cardMargin),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to event detail or edit
          },
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event icon
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                  ),
                  child: Icon(
                    Icons.event,
                    color: colorScheme.secondary,
                    size: AppSpacing.iconSize,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        event.title,
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),

                      // Description
                      if (event.description != null && event.description!.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          event.description!,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      // Time
                      if (event.startTime != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: AppSpacing.xxs),
                            Text(
                              '${_formatTime(event.startTime!)}${event.endTime != null ? ' - ${_formatTime(event.endTime!)}' : ''}',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],

                      // Location
                      if (event.location != null && event.location!.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: AppSpacing.xxs),
                            Expanded(
                              child: Text(
                                event.location!,
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _showCreateEventDialog() async {
    // TODO: Implement create event dialog
    // This would allow users to create new tasks or calendar events
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create event dialog - To be implemented')),
    );
  }
}
