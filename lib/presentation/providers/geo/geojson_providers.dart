import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:saig_app/infrastructure/githubcontent/github_rawcontent_datasource.dart';
import 'package:saig_app/infrastructure/repositories/geojson_repository_impl.dart';
// import 'package:turf/distance.dart';

final geojsonGithubRepositoryProvider = Provider<GeojsonRepositoryImpl>((ref) 
  => GeojsonRepositoryImpl(datasource: GithubRawcontentDatasource())
);

final geojsonTargetIdProvider = StateProvider<String>((ref) {
  return 'autopista.json';
});


class GeojsonProvider {

  Future<String> getHelloWorld() async{

    print('getHelloWorld');

    // await Future.delayed(Duration(milliseconds: 2000));


    // final id = ref.watch(geojsonTargetIdProvider);
    // final repository = ref.watch(geojsonGithubRepositoryProvider);

    // String data = await repository.getFeatureCollectionById(id);


    return "HolaMundo";

  }



}


final geojsonStringProvider = FutureProvider.autoDispose<String>( (ref) async {

  final id = ref.watch(geojsonTargetIdProvider);
  final repository = ref.watch(geojsonGithubRepositoryProvider);

  String data = await repository.getFeatureCollectionById(id);
  print('[geojsonStringProvider] $data');


//   // distance(from, to)
  // final parsedJson = jsonDecode(data);
  // print(parsedJson);
  // FeatureCollection fc =  FeatureCollection.fromJson(parsedJson);

  // List<Feature> features = parsedJson['features'];
  
//   // List<Feature<Point>> features = fc.features;
//   // print('[Provider] - Se obtuvieron: ${features.length}');
//   print(features);

  return data;
});