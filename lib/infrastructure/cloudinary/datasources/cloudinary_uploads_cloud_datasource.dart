import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:saig_app/config/cloudinary/cloudinary_config.dart';
import 'package:saig_app/domain/datasources/uploads_cloud_datasource.dart';
import 'package:saig_app/domain/entities/upload_item.dart';

class CloudinaryUploadsCloudDatasource implements UploadsCloudDatasource {

  final String _basePath = CloudinaryConfig.basePath;
  final String _cloudName = CloudinaryConfig.cloudinaryCloudName;
  final String _uploadPreset = CloudinaryConfig.uploadPreset;



  @override
  Future<String> uploadItem(UploadItem item) async {
     // Future<String> uploadItem(
  //     File imagen, double lat, double lng, String descripcion, double accelerometerX, double accelerometerY, double accelerometerZ) async {
    // String coordLat = lat.toString();
    // String coordLng = lng.toString();

    // Validacion a mejorar con form
    String descripcion;
    if (item.descripcion!.isEmpty) {
      descripcion = 'Imagen sin descripción';
    } else {
      descripcion = item.descripcion!;
    }

    final Uri uri = Uri.https( 
      _basePath, 
      '/v1_1/$_cloudName/image/upload',
      {'upload_preset': _uploadPreset }
    );

    // final imagen = File(path);

    final mimeType = mime(item.path)!.split('/');

    final imageUploadRequest = http.MultipartRequest('POST', uri);

    final file = await http.MultipartFile.fromPath('file', item.path!,
        contentType: MediaType(mimeType[0], mimeType[1]));
    imageUploadRequest.fields['metadata'] =
        '''
          coord_lat=${item.lat}|
          coord_lng=${item.lng}|
          desc=$descripcion|
          accelerometerX=${item.accelerometerX}|
          accelerometerY=${item.accelerometerY}|
          accelerometerZ=${item.accelerometerZ}|
          magnetometerX=${item.magnetometerX}|
          magnetometerY=${item.magnetometerY}|
          magnetometerZ=${item.magnetometerZ}|
          accuracy=${item.accuracy}|
          heading=${item.heading}|
          altitude=${item.altitude}|
          speed=${item.speed}|
          speedAccuracy=${item.speedAccuracy}|
          timestamp=${item.timestamp}
        ''';

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print("Error al subir imagen");
      print(resp.body);

      // return "Algo salio mal";
      throw Exception('error al subir');
    }

    final respData = json.decode(resp.body);

    print('upload ok');
    final publicId = respData['public_id'];

    return publicId;
  }
  
}