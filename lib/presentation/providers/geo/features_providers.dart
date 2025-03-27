import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/domain/repositories/features_repository.dart';
import 'package:saig_app/infrastructure/githubcontent/github_rawcontent_datasource.dart';
import 'package:saig_app/infrastructure/repositories/features_repository_impl.dart';

final featureProvider = Provider<FeaturesRepository> ((ref) {
  return FeaturesRepositoryImpl(datasource: GithubRawcontentDatasource());
});