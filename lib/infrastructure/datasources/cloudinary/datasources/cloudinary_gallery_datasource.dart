import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:saig_app/config/cloudinary/cloudinary_config.dart';

import 'package:saig_app/domain/datasources/gallery_datasource.dart';
import 'package:saig_app/domain/entities/gallery_item.dart';
import 'package:saig_app/infrastructure/datasources/cloudinary/cloudinary_mapper.dart';
import 'package:saig_app/infrastructure/datasources/cloudinary/models/cloudinary_resource.dart';
import 'package:saig_app/infrastructure/datasources/cloudinary/models/cloudinary_search_response.dart';

class CloudinaryGalleryDatasource implements GalleryDatasource {
  
  // Constantes para el servicio
  final String _basePath = CloudinaryConfig.basePath;
  final String _cloudName = CloudinaryConfig.cloudinaryCloudName;
  final String _apiKey = CloudinaryConfig.apiKey;
  final String _apiSecret = CloudinaryConfig.apiSecret;
  final String _folder = CloudinaryConfig.folder;
  final int _maxResults = CloudinaryConfig.maxResults;



  @override
  Future<List<GalleryItem>> getAllItems() async {

    final response = await getAllImages();

    final resources = response.resources;

    return resources
      .map((resource) => CloudinaryMapper.resourceToEntity(resource) )
      .toList();

  }


  ///
  /// Obtener todas las imagenes de Cloudinary
  ///
  Future<CloudinarySearchResponse> getAllImages() async {
    
    final Uri uri = Uri.https( _basePath, '/v1_1/$_cloudName/resources/search', {
      'expression': 'resource_type:image AND folder:$_folder',
      'with_field': 'metadata',
      'max_results': '$_maxResults'
    });

    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader:
            'Basic ${base64Encode(utf8.encode('$_apiKey:$_apiSecret'))}'
      },
    );

    if (response.statusCode == HttpStatus.ok) {
      return CloudinarySearchResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load response');
    }
  }

  
  ///
  /// Arma el string con la URL de la miniatura
  ///
  String getThumbUrl(CloudinaryResource resource) {
    return 'https://res.cloudinary.com/$_cloudName/image/upload/c_thumb,w_200/${resource.publicId}.${resource.format}';
  }

}
