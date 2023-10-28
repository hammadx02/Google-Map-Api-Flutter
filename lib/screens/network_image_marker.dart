import 'dart:async';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NetworkImageMarkerScreen extends StatefulWidget {
  const NetworkImageMarkerScreen({super.key});

  @override
  State<NetworkImageMarkerScreen> createState() =>
      _NetworkImageMarkerScreenState();
}

class _NetworkImageMarkerScreenState extends State<NetworkImageMarkerScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  Uint8List? markerImage;
  final List<Marker> _markers = <Marker>[];
  final List<LatLng> _latLang = <LatLng>[
    const LatLng(33.6941, 72.9734),
    const LatLng(33.7008, 72.9682),
    const LatLng(33.6992, 72.9744),
    const LatLng(33.6939, 72.9771),
    const LatLng(33.6910, 72.9807),
    const LatLng(33.7036, 72.9785),
  ];

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.6910, 72.98072),
    zoom: 15,
  );

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    for (int i = 0; i < _latLang.length; i++) {
      Uint8List? image = await _loadNetworkImage(
          'https://images.bitmoji.com/3d/avatar/201714142-99447061956_1-s5-v1.webp');
      final ui.Codec markerImageCodec = await instantiateImageCodec(
        image!.buffer.asUint8List(),
        targetHeight: 100,
        targetWidth: 100,
      );
      final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
      final ByteData? byteData = await frameInfo.image.toByteData(
        format: ImageByteFormat.png,
      );

      final Uint8List resizedMarkerImageBytes = byteData!.buffer.asUint8List();

      _markers.add(
        Marker(
          markerId: MarkerId(
            i.toString(),
          ),
          position: _latLang[i],
          icon: BitmapDescriptor.fromBytes(resizedMarkerImageBytes),
          anchor: Offset(.1, .1),
          infoWindow: InfoWindow(
            title: 'Title of marker' + i.toString(),
          ),
        ),
      );
      setState(() {});
    }
  }

  Future<Uint8List?> _loadNetworkImage(String path) async {
    final completer = Completer<ImageInfo>();
    var img = NetworkImage(path);
    img
        .resolve(
          const ImageConfiguration(
            size: Size.fromHeight(10),
          ),
        )
        .addListener(
          ImageStreamListener(
            (info, _) => completer.complete(info),
          ),
        );
    final imageInfo = await completer.future;
    final byteData = await imageInfo.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          markers: Set<Marker>.of(_markers),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
