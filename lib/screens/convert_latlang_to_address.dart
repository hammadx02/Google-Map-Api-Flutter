import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_geocoder/model.dart';

class ConvertLatLangToAddress extends StatefulWidget {
  const ConvertLatLangToAddress({super.key});

  @override
  State<ConvertLatLangToAddress> createState() =>
      _ConvertLatLangToAddressState();
}

String stAddressOne = '';
String stAddressTwo = '';

class _ConvertLatLangToAddressState extends State<ConvertLatLangToAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(stAddressOne),
            const SizedBox(
              height: 10,
            ),
            Text(stAddressTwo),
            GestureDetector(
              onTap: () async {
                //from query
                final query = 'Deans Trade Center Peshawar Pakistan';
                var addressSecond =
                    await Geocoder.local.findAddressesFromQuery(query);
                var second = addressSecond.first;

                // from coordinates
                final coordinates = Coordinates(34.0009, 71.5444);
                var addressFirst = await Geocoder.local
                    .findAddressesFromCoordinates(coordinates);
                var first = addressFirst.first;
                // print('Address: ' +
                //     first.countryName.toString() +
                //     first.adminArea.toString());

                setState(() {
                  stAddressOne =
                      first.countryName.toString() + first.adminArea.toString();
                  stAddressTwo = second.coordinates.toString();
                });
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'Convert',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
