
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

  final String description;

  const UploadItem({
    this.id, 
    this.publicId,
    this.description = 'sin descripcion',
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
    String? description,
  }) {
    return UploadItem(
      id: id ?? this.id,
      path: path,
      status: status ?? this.status,
      publicId: publicId ?? this.publicId,
      positionValue: positionValue ?? this.positionValue,
      accelerometer: accelerometer ?? this.accelerometer,
      magnetometer: magnetometer ?? this.magnetometer,
      description: description ?? this.description,
    );
  }

  factory UploadItem.fromMap( Map<String, dynamic> map ) {
    return UploadItem(
      id: map['id'],
      path: map['path'],
      status: UploadStatus.values[map['status']],
      publicId: map['public_id'],
      positionValue: PositionValue.fromMap(map),
      description: map['description'],
    );
  
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
    'description': description,

  };

}
