import 'dart:math';

import 'package:flutter/material.dart';
import 'package:saig_app/domain/entities/upload_item.dart';
import 'package:saig_app/domain/enums/upload_status.dart';
import 'package:saig_app/domain/repositories/uploads_local_repository.dart';
import 'package:saig_app/infrastructure/cloudinary/datasources/cloudinary_uploads_cloud_datasource.dart';
import 'package:saig_app/infrastructure/device/uploads_local_memory_datasource.dart';
import 'package:saig_app/infrastructure/repositories/uploads_cloud_repository_impl.dart';
import 'package:saig_app/infrastructure/repositories/uploads_local_repository_impl.dart';
import 'package:saig_app/infrastructure/sqlite/uploads_local_sqlite_datasource.dart';

class UploadsProvider extends ChangeNotifier {

  // final _localRepository = UploadsLocalRepositoryImpl(datasource: UploadsLocalMemoryDatasource());
  final _localRepository = UploadsLocalRepositoryImpl(datasource: UploadsLocalSqliteDatasource.db );

  final cloudRepository = UploadsCloudRepositoryImpl(datasource: CloudinaryUploadsCloudDatasource());


  void newMockItem() async {

    final item = UploadItem();
    item.id = Random().nextInt(1000);
    item.descripcion = DateTime.now().toString();
    item.status = UploadStatus.values[ Random().nextInt(UploadStatus.values.length)];

    addItem(item);

  }

  Future<List<UploadItem>> getVisibles() async {
    // print('getVisibles');
    return await _localRepository.getVisibles();
  }


  ///
  /// Agregar nuevo item con PENDING a la lista de precarga
  ///
  void addItem(UploadItem item) async {
    
    // print('add $item');

    item.id = await _localRepository.insertItem(item);

    // _items!.insert(0, item); TODO
    notifyListeners();
  }


  ///
  /// Eliminar item de la lista y de la DB y notificar
  ///
  void deleteItem(UploadItem item) async {
    
    await _localRepository.deleteItem(item);
    // await DBProvider.db.deleteItem(item); // TODO
    // deleteFile(item); // TODO
    notifyListeners();
  }


  ///
  ///
  ///
  void uploadItem(UploadItem item) async {

    item.status = UploadStatus.uploading;
    notifyListeners();
    
    cloudRepository.uploadItem(item)
      .then((value) {
        item.publicId = value;
        item.status = UploadStatus.done;
        notifyListeners();
        // updateItemDB(item); // TODO
        // procesarSubidoOk(item); // TODO
      })
      .onError((error, stackTrace) {
        item.status = UploadStatus.error;
        notifyListeners();
        // updateItemDB(item); // TODO
        // print(error); // TODO
      });

    // return Future.delayed(const Duration(seconds: 3), () => 'Done');
  }



}