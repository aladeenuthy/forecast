import 'package:geolocator/geolocator.dart';

Future<Map<String, String>?> getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }
  final locData = await Geolocator.getCurrentPosition();
  return {
    'lat': locData.latitude.toString(),
    'long': locData.longitude.toString()
  };
}
