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

class _GetUserCurrentLocationScreenState
    extends State<GetUserCurrentLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      )
    ;
  }
}
