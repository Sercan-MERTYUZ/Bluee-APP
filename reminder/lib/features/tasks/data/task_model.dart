import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? note;

  @HiveField(3)
  DateTime scheduledAt;

  @HiveField(4)
  bool isDone;

  @HiveField(5)
  int notificationId;

  Task({
    required this.id,
    required this.title,
    this.note,
    required this.scheduledAt,
    this.isDone = false,
    required this.notificationId,
  });

  Task copyWith({
    String? id,
    String? title,
    String? note,
    DateTime? scheduledAt,
    bool? isDone,
    int? notificationId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      isDone: isDone ?? this.isDone,
      notificationId: notificationId ?? this.notificationId,
    );
  }
}
