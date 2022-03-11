import 'package:flutter/material.dart';
import 'package:forecast/utils/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  final double lat;
  final double long;
  const MapScreen({Key? key, required this.lat, required this.long})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
            title: const Text("Location"),
            backgroundColor: primaryColor,
          ),
      body: GoogleMap(
        markers: {
          Marker(
              markerId: const MarkerId('m1'),
              position: LatLng(lat, long))
        },
        initialCameraPosition:
            CameraPosition(target: LatLng(lat, long)),
      ),
    );
  }
}
