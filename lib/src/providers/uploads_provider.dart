import 'package:flutter/material.dart';
import 'package:saig_app/src/enums/upload_status.dart';
import 'package:saig_app/src/models/upload_item_model.dart';
import 'package:saig_app/src/providers/cloudinary_provider.dart';

class UploadsProvider extends ChangeNotifier {
  List<UploadItemModel> _items = [];

  List<UploadItemModel> getItems() {
    return _items;
  }

  CloudinaryProvider _cloudinaryProvider = new CloudinaryProvider();

  ///
  /// Procesar y subir item
  ///
  void upload(UploadItemModel item) async {
    print(item);
    item.status = UploadStatus.uploading;
    notifyListeners();
    _cloudinaryProvider.uploadItem(item).then((value) {
      item.publicId = value;
      item.status = UploadStatus.done;
      notifyListeners();
    });
  }

  ///
  /// Agregar nuevo item a la lista
  ///
  void addItem(UploadItemModel item) {
    print('add $item');
    _items.add(item);
    notifyListeners();
  }
}
