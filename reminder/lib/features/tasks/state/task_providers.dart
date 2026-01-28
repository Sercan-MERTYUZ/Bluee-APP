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
    await repository.scheduleNotification(task, notificationAt);

    state = [...state, task];
    state.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    return null; // success
  }

  Future<void> markDone(Task task, bool done) async {
    final updatedTask = task.copyWith(isDone: done);
    await repository.updateTask(updatedTask);

    if (done) {
      await repository.cancelNotification(task.notificationId);
    }

    state = [
      for (final t in state)
        if (t.id == task.id) updatedTask else t,
    ];
  }

  Future<void> deleteTask(Task task) async {
    await repository.deleteTask(task.id);
    state = state.where((t) => t.id != task.id).toList();
  }

  Future<String?> rescheduleTask(Task task, DateTime newScheduledAt) async {
    // Calculate notification time: 30 minutes before new task time
    final newNotificationAt = newScheduledAt.subtract(const Duration(minutes: 30));

    // Validate: newNotificationAt must be in the future
    if (newNotificationAt.isBefore(DateTime.now()) || newNotificationAt.isAtSameMomentAs(DateTime.now())) {
      return 'invalid_time';
    }

    await repository.rescheduleTask(task, newScheduledAt, newNotificationAt);
    
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
