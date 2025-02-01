import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> getAddressFromPosition(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Extract fields in the desired format
        String name = place.name ?? '';
        String subLocality = place.subLocality ?? '';
        String locality = place.locality ?? '';
        String subAdministrativeArea = place.subAdministrativeArea ?? '';
        String administrativeArea = place.administrativeArea ?? '';
        String country = place.country ?? '';

        // Format the address
        return '$name, $subLocality, $locality, $subAdministrativeArea, $administrativeArea, $country'.trim().replaceAll(RegExp(r', ,'), ',');
      } else {
        return 'No address available';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
