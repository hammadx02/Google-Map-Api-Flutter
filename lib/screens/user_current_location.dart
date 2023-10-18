// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetUserCurrentLocationScreen extends StatefulWidget {
  const GetUserCurrentLocationScreen({super.key});

  @override
  State<GetUserCurrentLocationScreen> createState() =>
      _GetUserCurrentLocationScreenState();
}

final Completer<GoogleMapController> _controller = Completer();

Future<Position> _getUserCurrentLocation() async {
  await Geolocator.requestPermission()
      .then(
    (value) {},
  )
      .onError(
    (error, stackTrace) {
      print(
        error.toString(),
      );
    },
  );
  return await Geolocator.getCurrentPosition();
}

const CameraPosition _kGooglePlex = CameraPosition(
  target: LatLng(
    34.0009,
    71.5444,
  ),
  zoom: 14.4746,
);

final List<Marker> _marker = [];
final List<Marker> _list = [
  Marker(
    markerId: MarkerId('1'),
    position: LatLng(
      33.7077,
      73.0498,
    ),
    infoWindow: InfoWindow(
      title: 'My Current Location',
    ),
  ),
];

class _GetUserCurrentLocationScreenState
    extends State<GetUserCurrentLocationScreen> {
  loadUserCurrentLocation() {
    _getUserCurrentLocation().then(
      (value) async {
        _marker.add(
          Marker(
            markerId: MarkerId('2'),
            position: LatLng(value.latitude, value.latitude),
            infoWindow: InfoWindow(
              title: 'My location',
            ),
          ),
        );
        CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.latitude),
          zoom: 14,
        );
        final GoogleMapController controller = await _controller.future;

        controller
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    initState() {
      super.initState();
      loadUserCurrentLocation();
    }

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        // trafficEnabled: true,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(_marker),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _getUserCurrentLocation().then(
            (value) async {
              _marker.add(
                Marker(
                  markerId: MarkerId('2'),
                  position: LatLng(value.latitude, value.latitude),
                  infoWindow: InfoWindow(
                    title: 'My location',
                  ),
                ),
              );
              CameraPosition cameraPosition = CameraPosition(
                target: LatLng(value.latitude, value.latitude),
                zoom: 14,
              );
              final GoogleMapController controller = await _controller.future;

              controller.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition));
              setState(() {});
            },
          );
        },
        child: const Icon(
          Icons.location_on_rounded,
        ),
      ),
    );
  }
}
