import 'dart:io';

import 'package:flutter/material.dart';
import 'package:saig_app/src/enums/upload_status.dart';
import 'package:saig_app/src/models/upload_item_model.dart';
import 'package:saig_app/src/providers/cloudinary_provider.dart';
import 'package:saig_app/src/providers/db_provider.dart';

class UploadsProvider extends ChangeNotifier {

  List<UploadItemModel>? _items;
  CloudinaryProvider _cloudinaryProvider = new CloudinaryProvider();


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

    return _items;
  }


  ///
  /// Obtener solo los que se muestran en el listView. 
  /// Todos los estados menos archived
  ///
  Future<List<UploadItemModel>?> getVisibles() async {
    if (_items == null) {
      final items = await DBProvider.db.getVisibles();
      _items = items;
    }
    limpiarSubidosOk();
    return _items;
  }


  ///
  /// Pasa a status archive y elimina archivos
  /// Si quedo alguno como Uploaded, por ejemplo al cerrar
  /// la app sin haber cumplido el tiempo
  /// 

  ///
  void limpiarSubidosOk() {
    _items!
      .where( (item) => item.status! == UploadStatus.done )
      .toList()
      .forEach( (item) => procesarSubidoOk( item ) );
  }


  ///
  /// Procesar y subir item
  ///
  void upload(UploadItemModel item) async {
    
    print('subiendo item $item');
    item.status = UploadStatus.uploading; // Uploading no actualiza en DB pero si notifica
    notifyListeners();
    _cloudinaryProvider.uploadItem( item )
      .then((value) {
        item.publicId = value;
        item.status = UploadStatus.done;
        updateItemDB(item);
        procesarSubidoOk(item);
      })
      .onError((error, stackTrace) {
        item.status = UploadStatus.error;
        updateItemDB(item);
        print(error);
      });
  }


  ///
  /// Una vez subido esperar unos segundos para visualizar y luego pasar
  /// a archived y eliminar el archivo de la cache
  ///
  void procesarSubidoOk(UploadItemModel item) {

    Future.delayed(Duration(seconds: 3))
      .then((value) { 
        item.status = UploadStatus.archived;
        deleteItem(item);
        deleteFile(item);
        updateItemDB(item);
      });
  }


  ///
  /// Agregar nuevo item con PENDING a la lista de precarga
  ///
  void addItem(UploadItemModel item) async {
    print('add $item');

    item.id = await DBProvider.db.insertItem(item);

    _items!.insert(0, item);
    notifyListeners();
  }


  ///
  /// Elimina el archivo para que no ocupe lugar en la cache
  ///
  void deleteFile(item) {
    final file = File(item.path!);
    file.delete()
      .then((value) => print('eliminado ok') )
      .onError((error, stackTrace) => print('no se puede eliminar porque no seguramente no existia el archivo') );
  }

  ///
  /// Actualizar item en BD
  ///
  void updateItemDB(UploadItemModel item) async {
    print('add $item');

    await DBProvider.db.updateItem(item);

    // _items.add(item);
    notifyListeners();
  }


  ///
  /// Eliminar item de la lista y notificar
  ///
  void deleteItem(UploadItemModel item) async {
    print('delete $item');
    _items!.remove(item);
    notifyListeners();
  }

}
