
import 'package:flutter/material.dart';
import 'package:saig_app/domain/domain.dart';
// import 'package:saig_app/domain/entities/positition_value.dart';

@immutable
class UploadItem {

  final int? id;
  final String path;
  final UploadStatus status;
  final String? publicId;

  final PositionValue? positionValue;
  
  final SensorValue? accelerometer;
  final SensorValue? magnetometer;

  // final double accelerometerX = 0;
  // final double accelerometerY = 0;
  // final double accelerometerZ = 0;
  // final double magnetometerX = 0;
  // final double magnetometerY = 0;
  // final double magnetometerZ = 0;


  final String? descripcion = 'sin descripcion';

  const UploadItem({
    this.id, 
    this.publicId, 
    required this.path, 
    this.status = UploadStatus.pending, 
    this.positionValue,
    this.accelerometer,
    this.magnetometer,
  });

  UploadItem copyWith({
    int? id, 
    UploadStatus? status, 
    String? publicId,
    PositionValue? positionValue,
    SensorValue? accelerometer,
    SensorValue? magnetometer,
  }) {
    return UploadItem(
      id: id ?? this.id,
      path: path,
      status: status ?? this.status,
      publicId: publicId ?? this.publicId,
      positionValue: positionValue ?? this.positionValue,
      accelerometer: accelerometer ?? this.accelerometer,
      magnetometer: magnetometer ?? this.magnetometer,
    );
  }

  factory UploadItem.fromMap( Map<String, dynamic> map ) {
    return UploadItem(
      id: map['id'],
      path: map['path'],
      status: UploadStatus.values[map['status']],
      publicId: map['public_id'],
      positionValue: PositionValue.fromMap(map),
    );
  

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
  }



  ///
  /// Convertir a map para usar en base de datos
  ///
  Map<String, Object?> toMap() => {

    'id': id,
    'path': path,
    'status': status.index,
    'public_id': publicId,
    
    // positionValue
    'lat': positionValue!.lat,
    'lng': positionValue!.lng,
    'accuracy': positionValue!.accuracy,
    'heading' : positionValue!.heading,
    'altitude': positionValue!.altitude,
    'speed' : positionValue!.speed,
    'speedAccuracy': positionValue!.speedAccuracy,
    'timestamp' : positionValue!.timestamp,

    'accelerometerX': accelerometer!.x,
    'accelerometerY': accelerometer!.y,
    'accelerometerZ': accelerometer!.z,
    'magnetometerX': magnetometer!.x,
    'magnetometerY': magnetometer!.y,
    'magnetometerZ': magnetometer!.z,
    'descripcion': descripcion,

  };

}
