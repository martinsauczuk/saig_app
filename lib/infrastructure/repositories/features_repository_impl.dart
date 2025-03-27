import 'dart:convert';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:saig_app/domain/datasources/geojson_datasource.dart';
import 'package:saig_app/domain/repositories/features_repository.dart';

class FeaturesRepositoryImpl implements FeaturesRepository {
  final GeojsonDatasource datasource;

  FeaturesRepositoryImpl({required this.datasource});

  @override
  Future<List<Feature>> getTargetFeaturePointsById(String id) async {
    String featuresString =
        await datasource.getFeatureCollectionById(id);
    Map<String, dynamic> featuresMap = jsonDecode(featuresString);

    List<dynamic> featuresList = featuresMap['features'] as List<dynamic>;

    final List<Feature> features = featuresList.map((featureMap) {
      Feature feature = Feature.fromJson(featureMap);
      List<num> coordNum = (featureMap['geometry']['coordinates'] as List)
          .map((item) => item as num)
          .toList();
      feature.geometry = Point(coordinates: Position.of(coordNum));
      return feature;
    }).toList();

    return features;
  }
}
