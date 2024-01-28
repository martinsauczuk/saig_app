import 'dart:math';

import 'package:flutter/material.dart';
import 'package:saig_app/domain/entities/upload_item.dart';
import 'package:saig_app/domain/enums/upload_status.dart';
import 'package:saig_app/domain/repositories/uploads_local_repository.dart';
import 'package:saig_app/infrastructure/datasources/device/uploads_local_memory_datasource.dart';
import 'package:saig_app/infrastructure/repositories/uploads_local_repository_impl.dart';

class UploadsProvider extends ChangeNotifier {

  final UploadsLocalRepository _repository = UploadsLocalRepositoryImpl(datasource: UploadsLocalMemoryDatasource());


  void newMockItem() async {

    final item = UploadItem();
    item.id = Random().nextInt(1000);
    item.descripcion = DateTime.now().toString();
    item.status = UploadStatus.values[ Random().nextInt(UploadStatus.values.length)];

    addItem(item);

  }

  Future<List<UploadItem>> getVisibles() {
    print('getVisibles');
    return _repository.getVisibles();
  }


  ///
  /// Agregar nuevo item con PENDING a la lista de precarga
  ///
  void addItem(UploadItem item) async {
    
    print('add $item');

    item.id = await _repository.insertItem(item);

    // _items!.insert(0, item); TODO
    notifyListeners();
  }


  ///
  /// Eliminar item de la lista y de la DB y notificar
  ///
  void deleteItem(UploadItem item) async {
    print('delete $item');
    

    await _repository.deleteItem(item);
    // await DBProvider.db.deleteItem(item); // TODO
    // deleteFile(item); // TODO
    notifyListeners();
  }



}