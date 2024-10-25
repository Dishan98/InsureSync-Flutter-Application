import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
  // Check for location services
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled, handle it as needed
    return Future.error('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    // Request permission
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, handle it as needed
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are permanently denied, handle it as needed
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }

  // If permissions are granted, get the position
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}
