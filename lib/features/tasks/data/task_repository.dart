import 'package:easy_localization/easy_localization.dart';
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
      await cancelReminders(task.notificationId);
    }
    await box.delete(taskId);
  }

  Future<void> deleteTaskSafe(Task task) async {
    final box = HiveBoxes.tasksBox;
    try {
      await cancelReminders(task.notificationId);
    } catch (e) {
      // Ignore notification cancel error
    }
    await box.delete(task.id);
  }

  Future<void> scheduleReminders(Task task) async {
    final baseId = task.id.hashCode.abs();
    final now = DateTime.now();

    // 1. Schedule 30 min reminder
    final time30 = task.scheduledAt.subtract(const Duration(minutes: 30));
    if (time30.isAfter(now)) {
      final body30 = 'task_reminder_body'.tr() + (task.note != null && task.note!.isNotEmpty ? '\n${task.note}' : '');
      await NotificationService.instance.schedule(
        id: baseId,
        title: task.title,
        body: body30,
        scheduledDate: time30,
      );
    }

    // 2. Schedule 10 min reminder
    final time10 = task.scheduledAt.subtract(const Duration(minutes: 10));
    if (time10.isAfter(now)) {
      final body10 = 'task_reminder_body_10'.tr() + (task.note != null && task.note!.isNotEmpty ? '\n${task.note}' : '');
      await NotificationService.instance.schedule(
        id: baseId + 1, // Offset ID for second notification
        title: task.title,
        body: body10,
        scheduledDate: time10,
      );
    }
  }

  Future<void> cancelReminders(int baseNotificationId) async {
    await NotificationService.instance.cancel(baseNotificationId);      // 30 min
    await NotificationService.instance.cancel(baseNotificationId + 1);  // 10 min
  }

  Future<void> rescheduleTask(Task task, DateTime newScheduledAt) async {
    final box = HiveBoxes.tasksBox;
    // Cancel old notifications
    await cancelReminders(task.notificationId);
    
    // Update task with new scheduled time
    final updatedTask = task.copyWith(scheduledAt: newScheduledAt);
    await box.put(task.id, updatedTask);
    
    // Schedule new reminders
    await scheduleReminders(updatedTask);
  }
}
