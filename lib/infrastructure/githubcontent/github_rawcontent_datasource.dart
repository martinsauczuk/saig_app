import 'package:saig_app/config/githubrawcontent/githubrawcontent_config.dart';
import 'package:saig_app/domain/datasources/geojson_datasource.dart';
import 'package:http/http.dart' as http;


class GithubRawcontentDatasource implements GeojsonDatasource{
  

  // Constantes para el servicio
  final String _basePath = GithubrawcontentConfig.basePath;
  final String _repositoryPath = GithubrawcontentConfig.repositoryPath;


  @override
  Future<String> getFeatureCollectionById(String id) async {
    
    final uri = Uri.https(_basePath, '$_repositoryPath/$id');
    final response = await http.get(uri);

    if(response.statusCode == 200) {
      return response.body;
    } else {
      return "{ }";
    }

  }
  
  @override
  Future<String> getFeatureCollectionIds() {
    // TODO: implement getFeatureCollectionIds
    throw UnimplementedError();
  }


  
}