import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late tz.Location _localTimezone;

  Future<void> init() async {
    // Initialize Android
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@drawable/ic_notification');

    // Initialize iOS
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    // Request iOS permissions
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Request Android permissions
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final notifGranted = await androidImplementation?.requestNotificationsPermission();
    final alarmGranted = await androidImplementation?.requestExactAlarmsPermission();
    debugPrint('[NotificationService] notifPermission=$notifGranted, alarmPermission=$alarmGranted');

    // Detect and use device local timezone
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    _localTimezone = tz.getLocation(timezoneInfo.identifier);
    tz.setLocalLocation(_localTimezone);
    debugPrint('[NotificationService] Timezone set to: ${timezoneInfo.identifier}');
  }

  Future<int> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    final tz.TZDateTime tzScheduledDate = tz.TZDateTime(
      _localTimezone,
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      scheduledDate.hour,
      scheduledDate.minute,
      scheduledDate.second,
    );

    final now = tz.TZDateTime.now(_localTimezone);
    debugPrint('[NotificationService] Scheduling id=$id title="$title"');
    debugPrint('[NotificationService] Now:       $now');
    debugPrint('[NotificationService] Scheduled: $tzScheduledDate');

    if (tzScheduledDate.isBefore(now)) {
      debugPrint('[NotificationService] ⚠️ Scheduled time is in the past! Skipping.');
      return id;
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminders_channel',
          'Reminders',
          channelDescription: 'Notification channel for reminders',
          importance: Importance.max,
          priority: Priority.max,
          enableVibration: true,
          playSound: true,
          icon: '@drawable/ic_notification',
          largeIcon: DrawableResourceAndroidBitmap('@drawable/ic_notification_large'),
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    debugPrint('[NotificationService] ✅ Notification scheduled successfully id=$id');
    return id;
  }

  Future<void> cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
    debugPrint('[NotificationService] Cancelled notification id=$id');
  }
}
