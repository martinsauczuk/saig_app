import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';


class UploadProvider {
  

  ///
  /// Subir imagen
  ///
  Future<String> uploadImage(PickedFile pickedFile) async {

    Uri url = Uri.parse('https://api.cloudinary.com/v1_1/dmhk3tifm/image/upload?upload_preset=sebpnwqa');

    final imagen = File(pickedFile.path);

    final mimeType = mime(imagen.path)!.split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath(
      'file', 
      imagen.path, 
      contentType: MediaType( mimeType[0], mimeType[1] )
    );
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