import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app.dart';
import 'core/notifications/notification_service.dart';
import 'features/tasks/data/task_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize localization
  await EasyLocalization.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');

  // Initialize timezone
  tz.initializeTimeZones();

  // Initialize notifications
  await NotificationService.instance.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('tr')],
      startLocale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      child: const ProviderScope(
        child: RemindersApp(),
      ),
    ),
  );
}
