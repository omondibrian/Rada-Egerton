// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class LocationTab extends StatelessWidget {

//   LocationTab({Key? key}) : super(key: key);
//   late final GoogleMapController mapController;
//   final CameraPosition _initialPosition = CameraPosition(
//     bearing: 90,
//     target: const LatLng(20.5937, 78.9629),
//     tilt: 45,
//     zoom: 4,
//   );

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GoogleMap(
//       onMapCreated: _onMapCreated,
//       initialCameraPosition: this._initialPosition,
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// void main() => runApp(LocationTab());

class LocationTab extends StatefulWidget {
  @override
  State<LocationTab> createState() => MapSampleState();
}

class MapSampleState extends State<LocationTab> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(3, 37),
    zoom: 4,
  );

  static final CameraPosition _kLake = CameraPosition(
    bearing: 90,
    target: const LatLng(20.5937, 78.9629),
    tilt: 45,
    zoom: 1,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
