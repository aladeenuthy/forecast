import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<Map<String, double>?> getLocation() async {
  LocationPermission permission;

  // Test if location services are enabled.
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }
  final locData = await Geolocator.getCurrentPosition();
  return {'lat': locData.latitude, 'long': locData.longitude};
}

String generateLocationPreviewImage(double? latitude, double? longitude) {
  return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=AIzaSyCk8mxRi4Z3zAcuvOhJQlwk4ZjBe98y3wk';
}

Future<String> getAddress(String lat, String long) async {
  final addressResponse = await Dio().get(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=AIzaSyCk8mxRi4Z3zAcuvOhJQlwk4ZjBe98y3wk');
  Map<String, dynamic> addressResponseData = addressResponse.data;
  final address = addressResponseData['results'][1]['address_components'][1]
          ['short_name'] +
      ', ' +
      addressResponseData['results'][1]['address_components'][4]['short_name'];
  return address;
}

Future<bool> isConnectedToInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}
