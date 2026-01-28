import '../../../core/notifications/notification_service.dart';
import '../../../core/storage/hive_boxes.dart';
import 'task_model.dart';

class TaskRepository {
  Future<List<Task>> loadTasks() async {
    final box = HiveBoxes.tasksBox;
    final tasks = box.values.toList();
    tasks.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return tasks;
  }

  Future<void> addTask(Task task) async {
    final box = HiveBoxes.tasksBox;
    await box.put(task.id, task);
  }

  Future<void> updateTask(Task task) async {
    final box = HiveBoxes.tasksBox;
    await box.put(task.id, task);
  }

  Future<void> deleteTask(String taskId) async {
    final box = HiveBoxes.tasksBox;
    final task = box.get(taskId);
    if (task != null) {
      await NotificationService.instance.cancel(task.notificationId);
    }
    await box.delete(taskId);
  }

  Future<void> deleteTaskSafe(Task task) async {
    final box = HiveBoxes.tasksBox;
    try {
      await NotificationService.instance.cancel(task.notificationId);
    } catch (e) {
      // Ignore notification cancel error
    }
    await box.delete(task.id);
  }

  Future<void> scheduleNotification(Task task, DateTime notificationAt) async {
    final notificationId = task.id.hashCode.abs();
    await NotificationService.instance.schedule(
      id: notificationId,
      title: task.title,
      body: task.note ?? 'Reminder',
      scheduledDate: notificationAt, // Fire 30 minutes before task time
    );
  }

  Future<void> cancelNotification(int notificationId) async {
    await NotificationService.instance.cancel(notificationId);
  }

  Future<void> rescheduleTask(Task task, DateTime newScheduledAt, DateTime newNotificationAt) async {
    final box = HiveBoxes.tasksBox;
    // Cancel old notification
    await NotificationService.instance.cancel(task.notificationId);
    // Update task with new scheduled time
    final updatedTask = task.copyWith(scheduledAt: newScheduledAt);
    await box.put(task.id, updatedTask);
    // Schedule new notification (30 minutes before new task time)
    await scheduleNotification(updatedTask, newNotificationAt);
  }
}
