import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:saig_app/src/models/search_response.dart';


class UploadProvider {

  final String _basePath = 'api.cloudinary.com';
  final String _cloudName = 'dmhk3tifm';
  final String _uploadPreset = 'sebpnwqa';
  final String _apiKey = '796339495941157';
  final String _apiSecret = 'hKS6oO8RmkQbduJgXq-5xWouDlY';
  final String _folder = 'postman_uploads';


  
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
      throw Exception('Failed to load response');
    }
    // print(response.body);
    

    // return response;

  }

  ///
  /// Subir imagen
  ///
  Future<String> uploadImage(PickedFile pickedFile) async {

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
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);


    if(resp.statusCode != 200 && resp.statusCode != 201) {
      print("Algo salio mal");
      return "Algo salio mal";
    }

    final respData = json.decode(resp.body);
    print(respData);

    return respData['secure_url'];
    
  }

}