import 'package:hive/hive.dart';
import '../../features/tasks/data/task_model.dart';

class HiveBoxes {
  static Box<Task> get tasksBox => Hive.box<Task>('tasks');
}
