import 'package:saig_app/domain/entities/upload_item.dart';


abstract class UploadsLocalDatasource {
  
  Future<int> insertItem(UploadItem newItem);

  Future<List<UploadItem>> getAll();

  Future<int> updateItem(UploadItem itemToUpdate);

  Future<int> deleteItem(UploadItem itemToDelete);

  Future<List<UploadItem>> getVisibles();
  
}