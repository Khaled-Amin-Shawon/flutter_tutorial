import 'package:flutter/material.dart';
import 'location_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Track',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LocationApp(),
    );
  }
}

class LocationApp extends StatefulWidget {
  const LocationApp({super.key});

  @override
  State<LocationApp> createState() => _LocationAppState();
}

class _LocationAppState extends State<LocationApp> {
  String _currentAddress = 'Fetching address...';
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();
      final address = await _locationService.getAddressFromPosition(position);

      setState(() {
        _currentAddress = address;
      });
    } catch (e) {
      setState(() {
        _currentAddress = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Track'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your Address:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              _currentAddress,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _fetchLocation,
              child: Text('Refresh Location'),
            ),
          ],
        ),
      ),
    );
  }
}
