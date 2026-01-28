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
    // Calculate notification time: 30 minutes before task time
    final notificationAt = scheduledAt.subtract(const Duration(minutes: 30));

    // Validate: notificationAt must be in the future (cannot be in past or now)
    if (notificationAt.isBefore(DateTime.now()) || notificationAt.isAtSameMomentAs(DateTime.now())) {
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
    
    // Schedule notification for 30 minutes before task time
    try {
      await repository.scheduleNotification(task, notificationAt);
    } catch (e) {
      debugPrint('Notification scheduling failed: $e');
      // Continue execution even if notification fails
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
        await repository.cancelNotification(task.notificationId);
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
    try {
      await repository.deleteTask(task.id);
    } catch (e) {
      // Even if deleting fails (e.g. notification cancel error inside), we should update state?
      // Repository.deleteTask handles notification cancel internally. 
      // If that throws, we might miss Hive delete.
      // Better to rely on repository ensuring Hive delete happens.
      // Let's assume repository.deleteTask is safe-ish or we catch here.
      debugPrint('Delete task failed: $e');
      // If hive delete failed, we probably shouldn't remove from state, OR we should force sync.
      // For now, let's rethrow or handle?
      // User complaint is "ui freeze", so let's allow state update if relevant.
    }
    // But repository.deleteTask includes Hive delete. If that fails, data is still there.
    // Let's modify repository instead for delete safety.
    
    // Actually, looking at repo code:
    // await NotificationService.instance.cancel(task.notificationId);
    // await box.delete(taskId);
    // Be safer:
    await repository.deleteTaskSafe(task);
    state = state.where((t) => t.id != task.id).toList();
  }

  Future<String?> rescheduleTask(Task task, DateTime newScheduledAt) async {
    // Calculate notification time: 30 minutes before new task time
    final newNotificationAt = newScheduledAt.subtract(const Duration(minutes: 30));

    // Validate: newNotificationAt must be in the future
    if (newNotificationAt.isBefore(DateTime.now()) || newNotificationAt.isAtSameMomentAs(DateTime.now())) {
      return 'invalid_time';
    }

    // We handle repository update separately to ensure state updates even if notification fails
    // await repository.rescheduleTask(task, newScheduledAt, newNotificationAt); BUT custom impl below:
    
    // 1. Cancel old notification (ignore error)
    try {
      await repository.cancelNotification(task.notificationId);
    } catch (e) {
      debugPrint('Cancel notification failed: $e');
    }

    // 2. Update task in DB
    final updatedTask = task.copyWith(scheduledAt: newScheduledAt);
    await repository.updateTask(updatedTask);

    // 3. Schedule new notification (ignore error)
    try {
      await repository.scheduleNotification(updatedTask, newNotificationAt);
    } catch (e) {
      debugPrint('Schedule notification failed: $e');
    }
    
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
