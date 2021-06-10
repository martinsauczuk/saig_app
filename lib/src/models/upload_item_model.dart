import 'package:image_picker/image_picker.dart';
import 'package:saig_app/src/enums/upload_status.dart';

class UploadItemModel {

  UploadItemModel(); 

  // UploadItemModel({
  //   this.id,
  //   required this.lat,
  //   required this.lng,
  //   required this.descripcion,
  //   // required this.status
  // });


  int? id;
  PickedFile? pickedFile;
  String? path;
  double? lat;
  double? lng; 
  String? descripcion = 'sin descripcion';
  UploadStatus? status = UploadStatus.pending;
  String? publicId;

  @override
  String toString() {
    return 'desc:$descripcion|lat:$lat|lng:$lng';
  }

  UploadItemModel.fromMap( Map<String, Object?> map ) {
    id          =  map['id']          as int;
    lat         =  map['lat']         as double;
    lng         =  map['lng']         as double;
    descripcion =  map['descripcion'] as String;
    path        =  map['path']        as String;
    status      =  UploadStatus.values[ map['status'] as int ]; 
  }


  ///
  /// Convertir a map para usar en base de datos
  ///
  Map<String, Object?> toMap() => {
    'lat'         : lat,
    'lng'         : lng,
    'descripcion' : descripcion,
    'status'      : status!.index,
    'path'        : path
  };
  

  

}