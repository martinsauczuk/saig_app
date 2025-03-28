import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';


abstract class FeaturesRepository {

  //
  //
  //
  Future<List<Feature>> getTargetFeaturePointsById(String id);

}
