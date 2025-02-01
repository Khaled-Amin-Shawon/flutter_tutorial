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

# DevLog: Location Tracker App
## Date 01/02/2025


## Introduction

The **Location Tracker App** is a Flutter-based mobile application designed to retrieve and display the user's current location in a human-readable format. It leverages Flutter's cross-platform capabilities and integrates location services through the `geolocator` and `geocoding` packages. The primary goal is to provide an intuitive and reliable solution for location-based requirements such as tracking, navigation, or address verification.

---

## Features

### Core Functionality
- **Fetch Current Location:**
  - Retrieves GPS coordinates with high accuracy.
  - Supports error handling for disabled location services and denied permissions.

- **Readable Address Conversion:**
  - Converts latitude and longitude into a detailed address, including:
    - Street name
    - Sub-locality
    - Locality (e.g., city or town)
    - Administrative area (e.g., district or division)
    - Country

### User-Centric Design
- **Error Handling:**
  - Displays meaningful messages when location services are unavailable or permissions are denied.
- **Modular Codebase:**
  - Designed for easy integration into larger apps or extended functionalities.

---

## Development Process

### Phase 1: Setting Up Location Services
1. Integrated the `geolocator` package to access device GPS.
2. Implemented permission checks for location services:
   - Checked if services are enabled.
   - Requested permissions when necessary.
   - Handled scenarios where permissions are permanently denied.

### Phase 2: Reverse Geocoding
1. Integrated the `geocoding` package to convert GPS coordinates to an address.
2. Extracted meaningful fields from the `Placemark` object:
   - **`name`**: Landmark or building name.
   - **`subLocality`**: Neighborhood or village.
   - **`locality`**: City or town.
   - **`administrativeArea`**: District or state.
   - **`country`**: Country name.
3. Ensured the formatted output avoided cryptic codes (e.g., `28CP+2V2`).

### Phase 3: UI Development
1. Built a simple, responsive UI using Flutter’s Material Design components.
2. Displayed the current address in a clear and minimalistic layout.
3. Added error messages for a better user experience.

---

## Challenges & Solutions

### 1. Handling Unreadable Address Formats
**Challenge:** The `Placemark` object often returned cryptic location codes (e.g., `28CP+2V2`).
**Solution:** Extracted and formatted meaningful fields to display human-readable addresses such as "Baserhat, Chelegagi, Dinajpur Sadar, Dinajpur, Rangpur Division, Bangladesh."

### 2. Permissions Management
**Challenge:** Managing scenarios where users deny permissions or disable location services.
**Solution:** Added robust error-handling logic and user-friendly prompts to guide users in enabling permissions.

### 3. Accuracy Issues
**Challenge:** Inconsistent results due to low GPS accuracy.
**Solution:** Used `LocationAccuracy.high` for precise location data.

---

## Tech Stack

### Frontend
- **Framework:** Flutter (Dart)
- **UI:** Material Design

### Packages
- **`geolocator`:** For accessing device GPS and fetching coordinates.
- **`geocoding`:** For converting coordinates into a readable address format.

---

## Code Highlights

### Location Service Implementation
```dart
Future<Position> getCurrentPosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions are permanently denied.');
  }

  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}
```

### Address Formatting
```dart
Future<String> getAddressFromPosition(Position position) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      return '${place.name}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}'
          .replaceAll(RegExp(r', ,'), ',')
          .trim();
    } else {
      return 'No address available';
    }
  } catch (e) {
    return 'Error: $e';
  }
}
```

---

## Future Improvements

1. **Real-Time Tracking:**
   - Implement continuous tracking with live updates on the map.

2. **Offline Support:**
   - Cache fetched addresses for offline usage.

3. **Localization:**
   - Provide addresses in local languages (e.g., Bangla).

4. **Interactive Features:**
   - Add Google Maps integration for visual representation.
   - Enable users to search for specific locations.

5. **Advanced Address Details:**
   - Include nearby landmarks for better contextual information.

---

## Conclusion
The **Location Tracker App** is a lightweight and scalable solution for location-based needs. Its modular architecture and user-friendly design make it a great starting point for more complex projects like delivery tracking, navigation systems, or location-based services. The app can be enhanced further with features like real-time tracking and localization to serve broader use cases.

---

Let me know if you need additional features or optimizations for this app! 🚀
