import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:saig_app/domain/repositories/features_repository.dart';
import 'package:saig_app/infrastructure/githubcontent/github_rawcontent_datasource.dart';
import 'package:saig_app/infrastructure/repositories/features_repository_impl.dart';
import 'package:saig_app/presentation/providers/providers.dart';

///
/// Circle radio
///
final circleRadiusProvider = StateProvider<double>((ref) {
  return 20.0;
});


///
/// Circle radio
///
final targetsInRadioCounterProvider = StateProvider<int>((ref) {
  return 0;
});


///
/// FeaturesRepository
///
final featureProvider = Provider<FeaturesRepository> ((ref) {
  return FeaturesRepositoryImpl(datasource: GithubRawcontentDatasource());
});


///
/// Circle buffer
///
final locationBufferFeatureProvider = StreamProvider<Feature>((ref) async* {

  final positionAsync = ref.watch(positionValueProvider);
  final radiusInMeters = ref.watch(circleRadiusProvider);


  List<Position> coordinates = [];
  positionAsync.whenData((geolocatorPosition) {
    
    double radiusInKm =  radiusInMeters / 1000;

    Position positionCenter = Position( geolocatorPosition.lng, geolocatorPosition.lat);
    const int points = 64;

    double distanceX = radiusInKm / (111.320 * cos(geolocatorPosition.lat * pi / 180));
    double distanceY = radiusInKm / 110.574;

    double theta, x, y;
    for (var i = 0; i < points; i++) {
      theta = (i / points) * (2 * pi);
      x = distanceX * cos(theta);
      y = distanceY * sin(theta);
      coordinates.add(Position( positionCenter.lng + x, positionCenter.lat + y) );
    }
    coordinates.add(coordinates[0]);
  });

  yield Feature(
    id: 'location_buffer',
    geometry: Polygon(coordinates: [coordinates])
  );

});
