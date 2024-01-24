import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:saig_app/presentation/menu_widget.dart';

class LocationPlaygroundScreen extends StatefulWidget {

  const LocationPlaygroundScreen({super.key});

  @override
  State<LocationPlaygroundScreen> createState() => _LocationPlaygroundScreenState();

}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}


class _LocationPlaygroundScreenState extends State<LocationPlaygroundScreen> {

  late Future<Position> position;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de GPS')),
      drawer: const MenuWidget(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: IconButton(
              iconSize: 72,
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  position = _determinePosition();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FutureBuilder<Position>(
                  future: position,
                  builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
                    if (snapshot.hasData) {
                      Position position = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Longitude: ${position.longitude}'),
                          Text('Latitude: ${position.latitude}'),
                          Text('Timestamp: ${position.timestamp}'),
                          Text('Accuracy: ${position.accuracy}'),
                          Text('Altitude: ${position.altitude}'),
                          Text('Floor: ${position.floor}'),
                          Text('Heading: ${position.heading}'),
                          Text('Speed: ${position.speed}'),
                          Text('SpeedAccuracy: ${position.speedAccuracy}'),
                          Text('isMocked: ${position.isMocked}')
                        ],
                      );
                    }

                    if(snapshot.hasError) {
                      return Center(
                        child: Text( snapshot.error.toString() )
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator()
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    position = _determinePosition();


    // _determinePosition();
    // Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
