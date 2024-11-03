import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/infrastructure/githubcontent/github_rawcontent_datasource.dart';
import 'package:saig_app/infrastructure/repositories/geojson_repository_impl.dart';

final geojsonGithubRepositoryProvider = Provider<GeojsonRepositoryImpl>((ref) 
  => GeojsonRepositoryImpl(datasource: GithubRawcontentDatasource())
);

final geojsonTargetIdProvider = StateProvider<String>((ref) {
  return 'autopista.json';
});

final geojsonStringProvider = FutureProvider<String>( (ref) async {

  final id = ref.watch(geojsonTargetIdProvider);
  final repository = ref.watch(geojsonGithubRepositoryProvider);

  return repository.getFeatureCollectionById(id);

});