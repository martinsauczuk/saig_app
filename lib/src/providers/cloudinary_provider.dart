import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:saig_app/src/models/search_response.dart';


class CloudinaryProvider {

  final String _basePath = 'api.cloudinary.com';

  // final String _cloudName = 'dmhk3tifm';
  final String _cloudName = 'saig';
  
  // final String _uploadPreset = 'sebpnwqa';
  final String _uploadPreset = 'fwaycgn1';

  // final String _apiKey = '796339495941157';
  final String _apiKey = '618569586983735';

  // final String _apiSecret = 'hKS6oO8RmkQbduJgXq-5xWouDlY';
  final String _apiSecret = 'QICgLfzwYPkvnMy2Xk2PH4SdgHM';
    
  // final String _folder = 'postman_uploads';
  final String _folder = 'AndroidAppV1';


  ///
  /// Obtener todas las imagenes de Cloudinay
  ///
  Future<SearchResponse> getAllImages() async {

    final Uri uri = Uri.https('$_basePath', '/v1_1/$_cloudName/resources/search', {
      'expression': 'resource_type:image AND folder:$_folder',
      'with_field': 'metadata',
    });

    print(uri.toString());

    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Basic ' + base64Encode(utf8.encode('$_apiKey:$_apiSecret'))
      },
    );

    if( response.statusCode == HttpStatus.ok ) {
      return SearchResponse.fromJson( jsonDecode(response.body) );
    } else {
      print( response.statusCode );
      throw Exception('Failed to load response');
    }
  }

  ///
  /// Subir imagen
  /// Con archivo y coordenadas
  ///
  Future<String> uploadImage(PickedFile pickedFile, double lat, double lng, String descripcion) async {

    String coord_lat = lat.toString();
    String coord_lng = lng.toString();

    // Validacion a mejorar con form
    if( descripcion.isEmpty ) {
      descripcion = 'Imagen sin descripción';
    }

    final Uri uri = Uri.https('$_basePath', '/v1_1/$_cloudName/image/upload', {
      'upload_preset' : '$_uploadPreset'
    });

    final imagen = File(pickedFile.path);

    final mimeType = mime(imagen.path)!.split('/');

    final imageUploadRequest = new http.MultipartRequest('POST', uri);

    final file = await http.MultipartFile.fromPath(
      'file', 
      imagen.path, 
      contentType: MediaType( mimeType[0], mimeType[1] )
    );
    imageUploadRequest.fields['folder'] = 'postman_uploads';
    imageUploadRequest.fields['metadata'] = 'coord_lat=$coord_lat|coord_lng=$coord_lng|desc=$descripcion';
    
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);


    if(resp.statusCode != 200 && resp.statusCode != 201) {
      print("Error al subir imagen");
      print(resp.body);
      // return "Algo salio mal";
      throw Exception('error al subir');
    }

    final respData = json.decode(resp.body);
    // print(respData);

    return respData['public_id'];
    
  }

  ///
  /// Arma el string con la URL de la miniatura
  ///
  String getThumbUrl(Resource resource) {

    return 'https://res.cloudinary.com/$_cloudName/image/upload/c_thumb,w_200,g_face/${resource.publicId}.${resource.format}';

  }

}