import 'package:saig_app/domain/datasources/geojson_datasource.dart';
import 'package:saig_app/domain/repositories/geojson_repository.dart';

class GeojsonRepositoryImpl implements GeojsonRepository {
  final GeojsonDatasource datasource;

  GeojsonRepositoryImpl({required this.datasource});

  @override
  Future<String> getFeatureCollectionById(String id) {
    return datasource.getFeatureCollectionById(id);
  }

  @override
  Future<String> getFeatureCollectionIds() {
    return datasource.getFeatureCollectionIds();
  }
}
