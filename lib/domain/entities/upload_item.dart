
import 'package:saig_app/domain/enums/upload_status.dart';

class UploadItem {

  int? id;
  
  late final String path;
  UploadStatus status = UploadStatus.pending;

  double lat = 0;
  double lng = 0;
  double accelerometerX = 0;
  double accelerometerY = 0;
  double accelerometerZ = 0;
  double magnetometerX = 0;
  double magnetometerY = 0;
  double magnetometerZ = 0;

  double accuracy = 0;
  double heading = 0;
  double altitude = 0;
  double speed = 0;
  double speedAccuracy = 0;
  String? timestamp = '';

  String? descripcion = 'sin descripcion';
  String? publicId = '';

  UploadItem({required this.path, required this.status});

  @override
  String toString() {
    return 'desc:$descripcion|lat:$lat|lng:$lng|accX:$accelerometerX|accY:$accelerometerY|accZ:$accelerometerZ|magX:$magnetometerX|magY:$magnetometerY|magZ:$magnetometerZ';
  }

  UploadItem.fromMap(Map<String, Object?> map) {
    id = map['id'] as int;
    lat = map['lat'] as double;
    lng = map['lng'] as double;
    accelerometerX = map['accelerometerX'] as double;
    accelerometerY = map['accelerometerY'] as double;
    accelerometerZ = map['accelerometerZ'] as double;
    magnetometerX = map['magnetometerX'] as double;
    magnetometerY = map['magnetometerY'] as double;
    magnetometerZ = map['magnetometerZ'] as double;
    descripcion = map['descripcion'] as String;

    accuracy = map['accuracy'] as double;
    heading = map['heading'] as double;
    altitude = map['altitude'] as double;
    speed = map['speed'] as double;
    speedAccuracy = map['speedAccuracy'] as double;
    timestamp = map['timestamp'] as String;

    path = map['path'] as String;
    publicId = map['public_id'] as String;
    status = UploadStatus.values[map['status'] as int];
  }

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
