import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/task_model.dart';
import '../data/task_repository.dart';

final taskRepositoryProvider = Provider((ref) => TaskRepository());

class TaskNotifier extends StateNotifier<List<Task>> {
  final TaskRepository repository;

  TaskNotifier(this.repository) : super([]) {
    load();
  }

  Future<void> load() async {
    state = await repository.loadTasks();
  }

  Future<String?> addTask({
    required String title,
    required String? note,
    required DateTime scheduledAt,
  }) async {
    // Validate: scheduledAt must be in the future (allow 1 minute buffer for "just now")
    if (scheduledAt.isBefore(DateTime.now().subtract(const Duration(minutes: 1)))) {
      return 'invalid_time'; // localization key
    }

    final uuid = generateUuid();
    final notificationId = uuid.hashCode.abs();

    final task = Task(
      id: uuid,
      title: title,
      note: note,
      scheduledAt: scheduledAt, // Store original task time
      isDone: false,
      notificationId: notificationId,
    );

    await repository.addTask(task);
    
    // Schedule notifications (Repository handles logic for 30m and 10m)
    try {
      await repository.scheduleReminders(task);
    } catch (e) {
      debugPrint('Notification scheduling failed: $e');
    }

    state = [...state, task];
    state.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    return null; // success
  }

  Future<void> markDone(Task task, bool done) async {
    final updatedTask = task.copyWith(isDone: done);
    await repository.updateTask(updatedTask);

    if (done) {
      try {
        await repository.cancelReminders(task.notificationId);
      } catch (e) {
        debugPrint('Notification cancellation failed: $e');
      }
    }

    state = [
      for (final t in state)
        if (t.id == task.id) updatedTask else t,
    ];
  }

  Future<void> deleteTask(Task task) async {
    await repository.deleteTaskSafe(task);
    state = state.where((t) => t.id != task.id).toList();
  }

  Future<String?> rescheduleTask(Task task, DateTime newScheduledAt) async {
    // Validate: newScheduledAt must be in the future (allow 1 minute buffer)
    if (newScheduledAt.isBefore(DateTime.now().subtract(const Duration(minutes: 1)))) {
      return 'invalid_time';
    }

    // Delegate rescheduling to repository (handles cancel + update + reschedule both reminders)
    try {
      await repository.rescheduleTask(task, newScheduledAt);
    } catch (e) {
      debugPrint('Reschedule task failed: $e');
      // Even if repo fails, we might want to update local state if the DB write succeeded?
      // But repo transaction is monolithic enough.
    }
    
    // Update local state
    state = [
      for (final t in state)
        if (t.id == task.id) t.copyWith(scheduledAt: newScheduledAt) else t,
    ];
    state.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    return null; // success
  }
}

final tasksProvider =
    StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskNotifier(repository);
});

String generateUuid() {
  return DateTime.now().millisecondsSinceEpoch.toString() +
      (DateTime.now().microsecond).toString();
}
