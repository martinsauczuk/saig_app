import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';


final geoPointsProvider = FutureProvider<List<Point>>((ref) async {
  
  await Future.delayed(Duration(milliseconds: 300));
  
  return [
    Point( coordinates: Position(-34.70678595493514,-58.279141706953254) )
  ];


});


final circleRadiusProvider = StateProvider<double>((ref) {
  return 20.0;
});


final locationBufferFeatureProvider = StreamProvider.autoDispose<Feature>((ref) async* {

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  bool serviceEnabled;
  geolocator.LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    throw Future.error('Location services are disabled.');
  }

  permission = await geolocator.Geolocator.checkPermission();
  if (permission == geolocator.LocationPermission.denied) {
    permission = await geolocator.Geolocator.requestPermission();
    if (permission == geolocator.LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      throw Future.error('Location permissions are denied');
    }
  }
  
  if (permission == geolocator.LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    throw Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  double radiusInMeters = ref.watch(circleRadiusProvider);


  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  await for( final geolocator.Position geolocatorPosition in geolocator.Geolocator.getPositionStream() ){
    
    // const double radiusInKm = 0.1;

    double radiusInKm =  radiusInMeters / 1000;

    Position positionCenter = Position( geolocatorPosition.longitude, geolocatorPosition.latitude);
    const int points = 64;
    // List<Point> geopoints = List.empty(growable: true);

    List<Position> coordinates = [];
    double distanceX = radiusInKm / (111.320 * cos(geolocatorPosition.latitude * pi / 180));
    double distanceY = radiusInKm / 110.574;

    double theta, x, y;
    for (var i = 0; i < points; i++) {
      theta = (i / points) * (2 * pi);
      x = distanceX * cos(theta);
      y = distanceY * sin(theta);
      coordinates.add(Position( positionCenter.lng + x, positionCenter.lat + y) );
    }

    // return Polygon(coordinates: [coordinates]);
    // return lineString;
    yield Feature(
      id: 'location_buffer',
      geometry: Polygon(coordinates: [coordinates])
    );

  }

});
