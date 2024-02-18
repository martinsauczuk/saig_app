import 'package:saig_app/domain/datasources/uploads_local_datadource.dart';
import 'package:saig_app/domain/entities/upload_item.dart';
import 'package:saig_app/domain/repositories/uploads_local_repository.dart';

class UploadsLocalRepositoryImpl implements UploadsLocalRepository {

  final UploadsLocalDatasource datasource;

  UploadsLocalRepositoryImpl({required this.datasource});

  @override
  Future<int> deleteItem(UploadItem itemToDelete) {
    return datasource.deleteItemById(itemToDelete.id!);
  }

  @override
  Future<List<UploadItem>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<UploadItem>> getVisibles() {
    return datasource.getVisibles();
  }

  @override
  Future<int> insertItem(UploadItem newItem) {
    return datasource.insertItem(newItem);
  }

  @override
  Future<int> updateItem(UploadItem itemToUpdate) {
    return datasource.updateItem(itemToUpdate);
  }



}