import 'package:saig_app/domain/datasources/uploads_cloud_datasource.dart';
import 'package:saig_app/domain/entities/upload_item.dart';
import 'package:saig_app/domain/repositories/uploads_cloud_repository.dart';

class UploadsCloudRepositoryImpl implements UploadsCloudRepository {

  final UploadsCloudDatasource datasource;

  UploadsCloudRepositoryImpl({required this.datasource});

  @override
  Future<String> uploadItem(UploadItem item) {
    return datasource.uploadItem(item);
  }
  
}
