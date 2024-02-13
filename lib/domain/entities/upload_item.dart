
import 'package:flutter/material.dart';
import 'package:saig_app/domain/enums/upload_status.dart';

@immutable
class UploadItem {

  final int? id;
  final String path;
  final UploadStatus status;

  final double lat = 0;
  final double lng = 0;
  final double accelerometerX = 0;
  final double accelerometerY = 0;
  final double accelerometerZ = 0;
  final double magnetometerX = 0;
  final double magnetometerY = 0;
  final double magnetometerZ = 0;

  final double accuracy = 0;
  final double heading = 0;
  final double altitude = 0;
  final double speed = 0;
  final double speedAccuracy = 0;
  final String? timestamp = '';

  final String? descripcion = 'sin descripcion';
  final String? publicId = '';

  const UploadItem({this.id, required this.path, this.status = UploadStatus.pending });

  UploadItem copyWith({int? id, UploadStatus? status}) {
    return UploadItem(
      id: id ?? this.id,
      status: status ?? this.status,
      path: path,
    );
  }


  @override
  String toString() {
    return 'desc:$descripcion|lat:$lat|lng:$lng|accX:$accelerometerX|accY:$accelerometerY|accZ:$accelerometerZ|magX:$magnetometerX|magY:$magnetometerY|magZ:$magnetometerZ';
  }

  // UploadItem.fromMap(Map<String, Object?> map) {
  //   id = map['id'] as int;
  //   lat = map['lat'] as double;
  //   lng = map['lng'] as double;
  //   accelerometerX = map['accelerometerX'] as double;
  //   accelerometerY = map['accelerometerY'] as double;
  //   accelerometerZ = map['accelerometerZ'] as double;
  //   magnetometerX = map['magnetometerX'] as double;
  //   magnetometerY = map['magnetometerY'] as double;
  //   magnetometerZ = map['magnetometerZ'] as double;
  //   descripcion = map['descripcion'] as String;

  //   accuracy = map['accuracy'] as double;
  //   heading = map['heading'] as double;
  //   altitude = map['altitude'] as double;
  //   speed = map['speed'] as double;
  //   speedAccuracy = map['speedAccuracy'] as double;
  //   timestamp = map['timestamp'] as String;

  //   path = map['path'] as String;
  //   publicId = map['public_id'] as String;
  //   status = UploadStatus.values[map['status'] as int];
  // }

  ///
  /// Convertir a map para usar en base de datos
  ///
  Map<String, Object?> toMap() => {
    'id': id,
    'lat': lat,
    'lng': lng,
    'accelerometerX': accelerometerX,
    'accelerometerY': accelerometerY,
    'accelerometerZ': accelerometerZ,
    'magnetometerX': magnetometerX,
    'magnetometerY': magnetometerY,
    'magnetometerZ': magnetometerZ,
    'descripcion': descripcion,

    'accuracy': accuracy,
    'heading' : heading,
    'altitude': altitude,
    'speed' : speed,
    'speedAccuracy': speedAccuracy,
    'timestamp' : timestamp,

    'status': status.index,
    'path': path,
    'public_id': publicId!,
  };
}
