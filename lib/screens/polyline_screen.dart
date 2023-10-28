import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineScreen extends StatefulWidget {
  const PolylineScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PolylineScreenState createState() => _PolylineScreenState();
}

class _PolylineScreenState extends State<PolylineScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(8.984744630984105, -79.51568584889174),
    zoom: 14,
  );
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  List<LatLng> latlng = [
    const LatLng(9.000471, -79.495544),
    const LatLng(8.999406, -79.495831),
    const LatLng(8.998838, -79.494680),
    const LatLng(8.997630, -79.493314),
    const LatLng(8.995286, -79.495831),
    const LatLng(8.994078, -79.496335),
    const LatLng(8.992941, -79.495615),
    const LatLng(8.990029, -79.497701),
    const LatLng(8.985198, -79.502664),
    const LatLng(8.981359, -79.506608),
    const LatLng(8.969308, -79.514766),
    const LatLng(8.965132, -79.518738),
    const LatLng(8.979038, -79.529805),
    const LatLng(8.995424, -79.520294),
    const LatLng(9.000471, -79.495544),
  ];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < latlng.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId(
            i.toString(),
          ),
          position: latlng[i],
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(title: 'Title of marker'),
        ),
      );
      setState(() {});

      _polyline.add(
        Polyline(
          polylineId: const PolylineId('1'),
          points: latlng,
          color: Colors.blueAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        myLocationButtonEnabled: true,
        myLocationEnabled: false,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
