import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationTab extends StatelessWidget {
  const LocationTab({Key? key}) : super(key: key);
  static final CameraPosition _initialPosition = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-0.28333 ,36.06667),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _initialPosition,
      mapType: MapType.hybrid,
    );
  }
}
