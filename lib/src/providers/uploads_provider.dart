import 'package:flutter/material.dart';
import 'package:saig_app/src/enums/upload_status.dart';
import 'package:saig_app/src/models/upload_item_model.dart';
import 'package:saig_app/src/providers/cloudinary_provider.dart';
import 'package:saig_app/src/providers/db_provider.dart';

class UploadsProvider extends ChangeNotifier {
  List<UploadItemModel>? _items;
  CloudinaryProvider _cloudinaryProvider = new CloudinaryProvider();

  // UploadsProvider() {
  //   print('hola mundo provider creado');
  //   final items = await DBProvider.db.getAll();
  // }

  // void init() async {
  //     final items = await DBProvider.db.getAll();
  //     _items = items;
  // }

  ///
  /// Obtener todos los items. Cambiar de estado los que figuran como Uploading
  /// para dar la posibilidad de volver a intentar subirlos.
  /// Si se cargan como Uploading quiere decir que no se subieron correctamente
  ///
  Future<List<UploadItemModel>?> getItems() async {
    if (_items == null) {
      final items = await DBProvider.db.getAll();
      _items = items;
    }

    // final items = await DBProvider.db.getAll();

    // Procesar de manera individual cada uno de los items
    // items.forEach((item) {
    // _cleanUpdateItem(item);
    // });

    // _items = items;

    return _items;
  }

  ///
  ///
  ///
  UploadItemModel _cleanUpdateItem(UploadItemModel item) {
    print(item);

    // if( item.status == UploadStatus.uploading ) {
    //   item.status = UploadStatus.pending;
    //   updateItem(item);
    // }

    return item;
  }

  ///
  /// Procesar y subir item
  ///
  void upload(UploadItemModel item) async {
    print('subiendo item $item');
    item.status = UploadStatus.uploading; // Uploading no actualiza en DB
    // updateItem(item);
    notifyListeners();
    _cloudinaryProvider.uploadItem(item).then((value) {
      item.publicId = value;
      item.status = UploadStatus.done;
      updateItemDB(item);
    }).onError((error, stackTrace) {
      item.status = UploadStatus.error;
      updateItemDB(item);
      print(error);
    });
  }

  ///
  /// Agregar nuevo item con PENDING a la lista de precarga
  ///
  void addItem(UploadItemModel item) async {
    print('add $item');

    item.id = await DBProvider.db.insertItem(item);

    // _items!.add(item);
    _items!.insert(0, item);
    notifyListeners();
  }

  void updateItemDB(UploadItemModel item) async {
    print('add $item');

    await DBProvider.db.updateItem(item);

    // _items.add(item);
    notifyListeners();
  }
}
