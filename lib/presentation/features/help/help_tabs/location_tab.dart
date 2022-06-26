import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  runApp(const LocationTab());
}

class LocationTab extends StatefulWidget {
  const LocationTab({Key? key}) : super(key: key);

  @override
  State<LocationTab> createState() => MapSampleState();
}

class MapSampleState extends State<LocationTab> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _initialCameraPosition = CameraPosition(
    tilt: 45,
    target: LatLng(-0.36932651926935073, 35.9313568419356),
    zoom: 20.0,
  );

  static const CameraPosition _egertonntcc = CameraPosition(
    bearing: 90,
    target: LatLng(-0.28896128588051473, 36.05793424851361),
    tilt: 45,
    zoom: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        tiltGesturesEnabled: true,
        buildingsEnabled: true,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _gotoNTCC,
        label: const Text('NTCC'),
        icon: const Icon(Icons.school_outlined),
      ),
    );
  }

  Future<void> _gotoNTCC() async {
    final GoogleMapController mapController = await _controller.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(_egertonntcc));
  }
}

//Dean Of Sudent's location -0.36932651926935073, 35.9313568419356
//Counselling's department -0.36973278363331785, 35.93140758698434
//Egerton Town Campus -0.28896128588051473, 36.05793424851361