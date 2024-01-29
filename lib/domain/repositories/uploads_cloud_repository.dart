import 'package:saig_app/domain/entities/upload_item.dart';

abstract class UploadsCloudRepository {

  ///
  /// Upload the image and metadata and return the id generated
  ///
  Future<String> uploadItem(UploadItem item);

}