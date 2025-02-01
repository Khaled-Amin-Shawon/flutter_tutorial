import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiService {
  final _notificationPlugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  bool get initialized => _initialized;

  // Initialize the notification plugin
  Future<void> initNotification() async {
    if (_initialized) return;

    // Android settings
    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false, // We'll request permission dynamically
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    // Initialization Settings
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    try {
      // Initialize the plugin
      await _notificationPlugin.initialize(initSettings);
      _initialized = true;
    } catch (e) {
      // Handle initialization errors
      print("Error initializing notifications: $e");
    }
  }

  // Request notification permission
  Future<bool> requestPermission() async {
    try {
      final bool? granted = await _notificationPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      if (granted == true) {
        print("Notification permissions granted.");
      } else {
        print("Notification permissions denied.");
      }

      return granted ?? false;
    } catch (e) {
      print("Error requesting notification permissions: $e");
      return false;
    }
  }

  // Notification Details setup
  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notification',
        channelDescription: 'Daily Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // Show Notification
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    try {
      await _notificationPlugin.show(
        id,
        title,
        body,
        _notificationDetails(),
      );
    } catch (e) {
      print("Error showing notification: $e");
    }
  }

  // Check and request permission before showing a notification
  Future<void> showNotificationWithPermission({
    int id = 0,
    String? title,
    String? body,
  }) async {
    final bool hasPermission = await requestPermission();
    if (hasPermission) {
      await showNotification(id: id, title: title, body: body);
    } else {
      print("Notification not shown: Permission denied.");
    }
  }
}
