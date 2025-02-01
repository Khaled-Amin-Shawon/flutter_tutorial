# flutter_tutorial

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Notification Service Devlog

This document outlines the steps taken to implement a notification service using the `flutter_local_notifications` package, including dynamic permission handling for both Android and iOS platforms.

## Features Implemented
1. **Notification Initialization**:
   - Initialized the `FlutterLocalNotificationsPlugin` with platform-specific settings for Android and iOS.
   - Added error handling to manage potential initialization issues.

2. **Dynamic Permission Request**:
   - Implemented a method to request notification permissions dynamically on iOS using `requestPermissions()`.
   - Enabled alert, badge, and sound permissions if they were previously denied.

3. **Notification Display**:
   - Created methods to configure and display notifications.
   - Ensured permissions are checked before displaying notifications.

## Key Code Snippets

### Initialization of Notifications
```dart
Future<void> initNotification() async {
  if (_initialized) return;

  const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: false, // We'll request permission dynamically
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  const initSettings = InitializationSettings(
    android: initSettingsAndroid,
    iOS: initSettingsIOS,
  );

  try {
    await _notificationPlugin.initialize(initSettings);
    _initialized = true;
  } catch (e) {
    print("Error initializing notifications: $e");
  }
}
```

### Requesting Notification Permissions
```dart
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
```

### Displaying Notifications with Permission Check
```dart
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
```

### Usage Example
```dart
void main() async {
  final notiService = NotiService();

  // Initialize notifications
  await notiService.initNotification();

  // Request permission and show a notification
  await notiService.showNotificationWithPermission(
    title: "Hello!",
    body: "This is a test notification.",
  );
}
```

## Platform-Specific Notes

### iOS
- Dynamic permission handling is implemented via `requestPermissions()`.
- Ensure you include appropriate permissions in your `Info.plist` file:

```xml
<key>UIBackgroundModes</key>
<array>
  <string>fetch</string>
  <string>remote-notification</string>
</array>
<key>NSUserNotificationUsageDescription</key>
<string>We need your permission to send notifications.</string>
```

### Android
- For Android 13 (API level 33) and above, explicit notification permission (`POST_NOTIFICATIONS`) must be requested. You can handle this with the `permission_handler` package.

### Example Manifest Entry for Android
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

## Working Days and Times
- **Working Days**: Monday to Friday
- **Working Hours**: 9:00 AM to 6:00 PM (Local Time)

## Future Improvements
1. **Add Support for Scheduled Notifications**:
   - Implement scheduling for notifications to trigger at specific times.
2. **Integrate Notification Categories**:
   - Add action buttons for notifications to enhance user interaction.
3. **Permission Check for Android 13+**:
   - Add code to handle notification permissions explicitly for Android 13 or higher.

---

This code and documentation are designed to be robust and adaptable for various Flutter projects requiring notification functionality. Feel free to fork and modify as needed!
