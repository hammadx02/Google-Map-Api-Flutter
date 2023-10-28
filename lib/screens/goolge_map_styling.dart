import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoolgeMapStylingScreen extends StatefulWidget {
  const GoolgeMapStylingScreen({Key? key}) : super(key: key);

  @override
  _GoolgeMapStylingScreenState createState() => _GoolgeMapStylingScreenState();
}

class _GoolgeMapStylingScreenState extends State<GoolgeMapStylingScreen> {
  String mapStyle = '';

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.6941, 72.9734),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();

    DefaultAssetBundle.of(context).loadString('images/map_style.json').then(
      (string) {
        mapStyle = string;
      },
    ).catchError(
      (error) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          // This button presents popup menu items.
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  _controller.future.then(
                    (value) {
                      DefaultAssetBundle.of(context)
                          .loadString('images/map_style.json')
                          .then(
                        (string) {
                          setState(() {});
                          value.setMapStyle(string);
                        },
                      );
                    },
                  ).catchError(
                    (error) {
                      print("error" + error.toString());
                    },
                  );
                },
                value: 1,
                child: const Text("Retro"),
              ),
              PopupMenuItem(
                onTap: () async {
                  _controller.future.then(
                    (value) {
                      DefaultAssetBundle.of(context)
                          .loadString('images/night_style.json')
                          .then(
                        (string) {
                          setState(() {});
                          value.setMapStyle(string);
                        },
                      );
                    },
                  ).catchError(
                    (error) {
                      print("error" + error.toString());
                    },
                  );
                },
                value: 2,
                child: const Text("Night"),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            controller.setMapStyle(mapStyle);
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
