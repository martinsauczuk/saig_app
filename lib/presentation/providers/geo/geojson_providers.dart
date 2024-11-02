import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/infrastructure/githubcontent/github_rawcontent_datasource.dart';
import 'package:saig_app/infrastructure/repositories/geojson_repository_impl.dart';

final geojsonGithubRepositoryProvider = Provider<GeojsonRepositoryImpl>((ref) 
  => GeojsonRepositoryImpl(datasource: GithubRawcontentDatasource())
);

