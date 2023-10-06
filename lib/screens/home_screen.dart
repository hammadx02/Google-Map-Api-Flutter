import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Completer<GoogleMapController> _controller = Completer();

const CameraPosition _kGooglePlex = CameraPosition(
  target: LatLng(
    34.0009,
    71.5444,
  ),
  zoom: 14.4746,
);

final List<Marker> _marker = [];
const List<Marker> _list = [
  Marker(
    markerId: MarkerId('1'),
    position: LatLng(
      34.0009,
      71.5444,
    ),
    infoWindow: InfoWindow(
      title: 'My Location',
    ),
  ),
];

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _marker.addAll(_list);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          // trafficEnabled: true,
          mapType: MapType.hybrid,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set.of(_marker),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            GoogleMapController controller = await _controller.future;
            controller.animateCamera(
              CameraUpdate.newCameraPosition(
                const CameraPosition(
                  target: LatLng(
                    34.0009,
                    71.5444,
                  ),
                  zoom: 14,
                ),
              ),
            );
            setState(() {});
          },
          child: const Icon(
            Icons.location_on_rounded,
          ),
        ),
      ),
    );
  }
}
