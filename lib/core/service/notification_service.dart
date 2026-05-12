import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // ── Initialize ────────────────────────────────────────────────────────────
  static Future<void> initialize() async {
    // Timezone init
    tz.initializeTimeZones();
    // ✅ Ye 2 lines lagao
    final TimezoneInfo tzInfo = await FlutterTimezone.getLocalTimezone();
    final String timeZoneName = tzInfo.identifier; // ya tzInfo.id hoga
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Local notifications setup
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(android: android, iOS: ios);
    await _local.initialize(settings);

    // Request permissions specifically for Android 13+ and exact alarms
    final androidPlugin = _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      // Even with USE_EXACT_ALARM, requesting it ensures stability
      await androidPlugin.requestExactAlarmsPermission();
    }

    // FCM permission
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // Android notification channel
    const channel = AndroidNotificationChannel(
      'class_reminders',
      'Class Reminders',
      description: 'Notifications for upcoming classes',
      importance: Importance.max,
    );
    await androidPlugin?.createNotificationChannel(channel);

    // FCM foreground handler
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification != null) {
        _local.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'class_reminders',
              'Class Reminders',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: DarwinNotificationDetails(),
          ),
        );
      }
    });
  }

  // ── Get FCM Token (save to Firestore for this user) ───────────────────────
  static Future<String?> getFCMToken() async {
    return await _fcm.getToken();
  }

  // ── Schedule 30 min before notification ───────────────────────────────────
  static Future<void> scheduleClassReminder({
    required int notificationId,
    required String channelName, // other person name
    required DateTime classTime,
    required bool isTeacher,
  }) async {
    final reminderTime = classTime.subtract(const Duration(minutes: 30));

    // Agar 30 min pehle already guzar gaya to mat schedule karo
    if (reminderTime.isBefore(DateTime.now())) return;

    final title = '📚 Class Starting Soon!';
    final body =
        'Your class with $channelName starts in 30 minutes. Get ready!';

    // Ensure safe positive 32-bit ID for Android
    final int safeId = notificationId & 0x7FFFFFFF;

    try {
      await _local.zonedSchedule(
        safeId,
        title,
        body,
        tz.TZDateTime.from(reminderTime, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'class_reminders',
            'Class Reminders',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            styleInformation: BigTextStyleInformation(body),
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      print('Notification schedule error: $e');
    }
  }

  // ── Cancel notification ───────────────────────────────────────────────────
  static Future<void> cancelNotification(int id) async {
    await _local.cancel(id);
  }

  // ── Cancel all notifications ──────────────────────────────────────────────
  static Future<void> cancelAll() async {
    await _local.cancelAll();
  }

  // ── Show instant notification ─────────────────────────────────────────────
  static Future<void> showNow({
    required String title,
    required String body,
  }) async {
    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'class_reminders',
          'Class Reminders',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
