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

    final file = await http.MultipartFile.fromPath('file', item.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
    imageUploadRequest.fields['metadata'] =
        '''
          coord_lat=${item.positionValue!.lat}|
          coord_lng=${item.positionValue!.lng}|
          desc=$descripcion|
          accelerometerX=${item.accelerometer!.x}|
          accelerometerY=${item.accelerometer!.y}|
          accelerometerZ=${item.accelerometer!.z}|
          magnetometerX=${item.magnetometer!.x}|
          magnetometerY=${item.magnetometer!.y}|
          magnetometerZ=${item.magnetometer!.z}|
          accuracy=${item.positionValue!.accuracy}|
          heading=${item.positionValue!.heading}|
          altitude=${item.positionValue!.altitude}|
          speed=${item.positionValue!.speed}|
          speedAccuracy=${item.positionValue!.speedAccuracy}|
          timestamp=${item.positionValue!.timestamp}
        ''';

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception('error al subir');
    }

    final respData = json.decode(resp.body);
    final publicId = respData['public_id'];

    return publicId;
  }
  
}