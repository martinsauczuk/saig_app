// import 'dart:convert';
// import 'dart:io';

// class CloudinaryDatasource {
//   // Constantes para el servicio
//   final String _basePath = dotenv.env['BASE_PATH'].toString();
//   final String _cloudName = dotenv.env['CLOUD_NAME'].toString();
//   final String _uploadPreset = dotenv.env['UPLOAD_PRESET'].toString();
//   final String _apiKey = dotenv.env['API_KEY'].toString();
//   final String _apiSecret = dotenv.env['API_SECRET'].toString();
//   final String _folder = dotenv.env['FOLDER'].toString();

//   ///
//   /// Obtener todas las imagenes de Cloudinay
//   ///
//   Future<SearchResponse> getAllImages() async {
//     final Uri uri =
//         Uri.https('$_basePath', '/v1_1/$_cloudName/resources/search', {
//       'expression': 'resource_type:image AND folder:$_folder',
//       'with_field': 'metadata',
//       'max_results': '500'
//     });

//     print(uri.toString());

//     final response = await http.get(
//       uri,
//       headers: {
//         HttpHeaders.authorizationHeader:
//             'Basic ' + base64Encode(utf8.encode('$_apiKey:$_apiSecret'))
//       },
//     );

//     if (response.statusCode == HttpStatus.ok) {
//       return SearchResponse.fromJson(jsonDecode(response.body));
//     } else {
//       print(response.statusCode);
//       throw Exception('Failed to load response');
//     }
//   }

//   ///
//   /// Subir imagen con archivo y metadata
//   ///
//   Future<String> uploadItem(UploadItemModel item) async {
//   // Future<String> uploadItem(
//   //     File imagen, double lat, double lng, String descripcion, double accelerometerX, double accelerometerY, double accelerometerZ) async {
//     // String coordLat = lat.toString();
//     // String coordLng = lng.toString();

//     // Validacion a mejorar con form
//     String descripcion;
//     if (item.descripcion!.isEmpty) {
//       descripcion = 'Imagen sin descripción';
//     } else {
//       descripcion = item.descripcion!;
//     }

//     final Uri uri = Uri.https('$_basePath', '/v1_1/$_cloudName/image/upload',
//         {'upload_preset': '$_uploadPreset'});

//     // final imagen = File(path);

//     final mimeType = mime(item.path)!.split('/');

//     final imageUploadRequest = new http.MultipartRequest('POST', uri);

//     final file = await http.MultipartFile.fromPath('file', item.path!,
//         contentType: MediaType(mimeType[0], mimeType[1]));
//     imageUploadRequest.fields['metadata'] =
//         '''
//           coord_lat=${item.lat}|
//           coord_lng=${item.lng}|
//           desc=$descripcion|
//           accelerometerX=${item.accelerometerX}|
//           accelerometerY=${item.accelerometerY}|
//           accelerometerZ=${item.accelerometerZ}|
//           magnetometerX=${item.magnetometerX}|
//           magnetometerY=${item.magnetometerY}|
//           magnetometerZ=${item.magnetometerZ}|
//           accuracy=${item.accuracy}|
//           heading=${item.heading}|
//           altitude=${item.altitude}|
//           speed=${item.speed}|
//           speedAccuracy=${item.speedAccuracy}|
//           timestamp=${item.timestamp}
//         ''';

//     imageUploadRequest.files.add(file);

//     final streamResponse = await imageUploadRequest.send();
//     final resp = await http.Response.fromStream(streamResponse);

//     if (resp.statusCode != 200 && resp.statusCode != 201) {
//       print("Error al subir imagen");
//       print(resp.body);

//       // return "Algo salio mal";
//       throw Exception('error al subir');
//     }

//     final respData = json.decode(resp.body);

//     print('upload ok');
//     final publicId = respData['public_id'];

//     return publicId;
//   }

//   ///
//   /// Arma el string con la URL de la miniatura
//   ///
//   String getThumbUrl(Resource resource) {
//     return 'https://res.cloudinary.com/$_cloudName/image/upload/c_thumb,w_200/${resource.publicId}.${resource.format}';
//   }
// }