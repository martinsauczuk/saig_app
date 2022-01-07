import 'package:saig_app/src/enums/upload_status.dart';

class UploadItemModel {

  UploadItemModel(); 

  int? id;
  String? path;
  double? lat;
  double? lng;
  double? accelerometerX;
  double? accelerometerY;
  double? accelerometerZ;
  double? magnetometerX;
  double? magnetometerY;
  double? magnetometerZ;
  String? descripcion = 'sin descripcion';
  UploadStatus? status = UploadStatus.pending;
  String? publicId = '';

  @override
  String toString() {
    return 'desc:$descripcion|lat:$lat|lng:$lng|accX:$accelerometerX|accY:$accelerometerY|accZ:$accelerometerZ|magX:$magnetometerX|magY:$magnetometerY|magZ:$magnetometerZ';
  }

  UploadItemModel.fromMap( Map<String, Object?> map ) {
    id              =  map['id']              as int;
    lat             =  map['lat']             as double;
    lng             =  map['lng']             as double;
    accelerometerX  =  map['accelerometerX']  as double;
    accelerometerY  =  map['accelerometerY']  as double;
    accelerometerZ  =  map['accelerometerZ']  as double;
    magnetometerX   =  map['magnetometerX']   as double;
    magnetometerY   =  map['magnetometerY']   as double;
    magnetometerZ   =  map['magnetometerZ']   as double;
    descripcion     =  map['descripcion']     as String;
    path            =  map['path']            as String;
    publicId        =  map['public_id']       as String;
    status          =  UploadStatus.values[ map['status'] as int ]; 
  }


  ///
  /// Convertir a map para usar en base de datos
  ///
  Map<String, Object?> toMap() => {
    'id'              : id,
    'lat'             : lat,
    'lng'             : lng,
    'accelerometerX'  : accelerometerX,
    'accelerometerY'  : accelerometerY,
    'accelerometerZ'  : accelerometerZ,
    'magenetometerX'  : magnetometerX,
    'magenetometerY'  : magnetometerY,
    'magenetometerZ'  : magnetometerZ,
    'descripcion'     : descripcion,
    'status'          : status!.index,
    'path'            : path,
    'public_id'       : publicId!,
  };
  

  

}