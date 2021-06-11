import 'package:flutter/material.dart';
import 'package:saig_app/src/enums/upload_status.dart';
import 'package:saig_app/src/models/upload_item_model.dart';
import 'package:saig_app/src/providers/cloudinary_provider.dart';
import 'package:saig_app/src/providers/db_provider.dart';

class UploadsProvider extends ChangeNotifier {
  
  List<UploadItemModel> _items = [];

  Future<List<UploadItemModel>> getItems() async {

    final items = await DBProvider.db.getAll();

    _items = items;

    return _items;
  }

  CloudinaryProvider _cloudinaryProvider = new CloudinaryProvider();

  ///
  /// Procesar y subir item
  ///
  void upload(UploadItemModel item) async {
    print(item);
    item.status = UploadStatus.uploading;
    updateItem(item);
    // notifyListeners();
    _cloudinaryProvider.uploadItem(item).then((value) {
      item.publicId = value;
      item.status = UploadStatus.done;
      updateItem(item);
    }).onError((error, stackTrace) {
      item.status = UploadStatus.error;
      updateItem(item);
      print(error);
    });
  }

  ///
  /// Agregar nuevo item a la lista
  ///
  void addItem(UploadItemModel item) async {
    print('add $item');

    await DBProvider.db.insertItem(item);

    // _items.add(item);
    notifyListeners();
  }


  void updateItem(UploadItemModel item) async {
    print('add $item');

    await DBProvider.db.updateItem(item);

    // _items.add(item);
    notifyListeners();
  }



}
