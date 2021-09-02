import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationTab extends StatelessWidget {

  LocationTab({Key? key}) : super(key: key);
  late final GoogleMapController mapController;
  final CameraPosition _initialPosition = CameraPosition(
    bearing: 90,
    target: const LatLng(20.5937, 78.9629),
    tilt: 45,
    zoom: 4,
  );

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: this._initialPosition,
    );
  }
}
