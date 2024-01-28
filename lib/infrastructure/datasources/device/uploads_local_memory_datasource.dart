import 'package:saig_app/domain/datasources/uploads_local_datadource.dart';
import 'package:saig_app/domain/entities/upload_item.dart';
import 'package:saig_app/presentation/providers/uploads_provider.dart';

class UploadsLocalMemoryDatasource implements UploadsLocalDatasource {

  final List<UploadItem> items = [];

  @override
  Future<int> deleteItem(UploadItem itemToDelete) {
    // TODO: implement deleteItem
    throw UnimplementedError();
  }

  @override
  Future<List<UploadItem>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<UploadItem>> getVisibles() {
    // return Future.delayed(const Duration(seconds: 1), () => items);
    return Future.value(items);
  }

  @override
  Future<int> insertItem(UploadItem newItem) {
    items.add(newItem);
    return Future.value( newItem.id! );
  }

  @override
  Future<int> updateItem(UploadItem itemToUpdate) {
    // TODO: implement updateItem
    throw UnimplementedError();
  }

}