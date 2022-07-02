import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rada_egerton/data/services/news_location_service.dart';

import '../../../../data/entities/locationDto.dart';

void main() {
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  runApp(const LocationTab());
}

class LocationTab extends StatefulWidget {
  const LocationTab({Key? key}) : super(key: key);

  @override
  State<LocationTab> createState() => _LocationTabState();
}

class _LocationTabState extends State<LocationTab> {
  final locationService = NewsAndLocationServiceProvider();
  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController mapController) async {
    final helpOffices = await locationService.fetchLocationPins();
    final helpOfficesLocations =
        helpOffices.fold<List<Location>>((l) => l.locations, (r) => []);
    setState(() {
      _markers.clear();
      for (final office in helpOfficesLocations) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(
            double.parse(office.latitude),
            double.parse(office.longitude),
          ),
          infoWindow: InfoWindow(title: office.name),
        );
        _markers[office.name] = marker;
      }
    });
  }

  static const CameraPosition _initialCameraPosition = CameraPosition(
    tilt: 45,
    target: LatLng(-0.36932651926935073, 35.9313568419356),
    zoom: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapToolbarEnabled: true,
      buildingsEnabled: true,
      compassEnabled: true,
      myLocationEnabled: true,
      initialCameraPosition: _initialCameraPosition,
      onMapCreated: _onMapCreated,
      markers: _markers.values.toSet(),
    );
  }
}
//todo: hardcode the marker values until a simple fetching solution is made possible

// class LocationTab extends StatefulWidget {
//   const LocationTab({Key? key}) : super(key: key);

//   @override
//   State<LocationTab> createState() => MapSampleState();
// }

// class MapSampleState extends State<LocationTab> {
//   final Completer<GoogleMapController> _controller = Completer();


//   static const CameraPosition _egertonntcc = CameraPosition(
//     bearing: 90,
//     target: LatLng(-0.28896128588051473, 36.05793424851361),
//     tilt: 45,
//     zoom: 20.0,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.normal,
//         zoomGesturesEnabled: true,
//         tiltGesturesEnabled: true,
//         buildingsEnabled: true,
//         gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
//           Factory<OneSequenceGestureRecognizer>(
//             () => EagerGestureRecognizer(),
//           ),
//         },
//         initialCameraPosition: _initialCameraPosition,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _gotoNTCC,
//         label: const Text('NTCC'),
//         icon: const Icon(Icons.school_outlined),
//       ),
//     );
//   }

//   Future<void> _gotoNTCC() async {
//     final GoogleMapController mapController = await _controller.future;
//     mapController.animateCamera(CameraUpdate.newCameraPosition(_egertonntcc));
//   }
// }
