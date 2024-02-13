import 'package:camera/camera.dart';
import 'package:saig_app/domain/entities/upload_item.dart';

class Capturer {

  Future<UploadItem> buildItem({ required CameraController cameraController }) async {
      
    await cameraController.initialize();
    final image = await cameraController.takePicture();
    return UploadItem(path: image.path);

  }

}