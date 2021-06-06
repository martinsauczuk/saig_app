import 'package:image_picker/image_picker.dart';
import 'package:saig_app/src/enums/upload_status.dart';

class UploadItemModel {
  
  PickedFile? pickedFile;
  late double lat;
  late double lng; 
  String descripcion = 'sin descripcion';
  UploadStatus status = UploadStatus.pending;
  String? publicId;

  @override
  String toString() {
    return 'desc:$descripcion|lat:$lat|lng:$lng';
  }

}