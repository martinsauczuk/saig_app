import 'dart:convert';
import 'package:http/http.dart' as http;

class UploadProvider {
  
  final String _url = 'https://api.cloudinary.com/v1_1/dmhk3tifm/image/upload';

  ///
  /// Subir imagen
  ///
  Future<http.Response> uploadImage() {

    Uri uri = Uri.parse('https://jsonplaceholder.typicode.com/albums');

    final resp = http.post(uri,
      headers: <String, String> {
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, String> {
        'title': 'hola mundo'
      }),
   
    );

    return resp;
    
  }

}