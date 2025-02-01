import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Flutter%20Notification/Local%20Notification/noti_service.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  NotiService().initNotification();
  runApp(const NotificationApp());
}

class NotificationApp extends StatelessWidget {
  const NotificationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      home: const NotificationHome(),
    );
  }
}

class NotificationHome extends StatefulWidget {
  const NotificationHome({super.key});

  @override
  State<NotificationHome> createState() => _NotificationHomeState();
}

class _NotificationHomeState extends State<NotificationHome> {
  int Noti_id=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Notification')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            NotiService().showNotification(
              id: Noti_id,
              title: 'Flutter Notification Example no $Noti_id',
              body: 'This is a local notification no $Noti_id',
            );
            Noti_id++;
          },
          child: const Text('Show Notification'),
        ),
      ),
    );
  }
}
