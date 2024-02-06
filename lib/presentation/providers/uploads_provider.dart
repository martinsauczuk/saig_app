import 'package:flutter/material.dart';
import 'package:saig_app/domain/entities/upload_item.dart';
import 'package:saig_app/domain/enums/upload_status.dart';
import 'package:saig_app/infrastructure/cloudinary/datasources/cloudinary_uploads_cloud_datasource.dart';
import 'package:saig_app/infrastructure/device/filesystem_helper.dart';
import 'package:saig_app/infrastructure/repositories/uploads_cloud_repository_impl.dart';
import 'package:saig_app/infrastructure/repositories/uploads_local_repository_impl.dart';
import 'package:saig_app/infrastructure/sqlite/uploads_local_sqlite_datasource.dart';

class UploadsProvider extends ChangeNotifier {

  final _localRepository = UploadsLocalRepositoryImpl(datasource: UploadsLocalSqliteDatasource.instance ); // TODO: Implementar riverpod para mantener esta instancia
  final _cloudRepository = UploadsCloudRepositoryImpl(datasource: CloudinaryUploadsCloudDatasource()); // TODO: Implementar riverpod para mantener esta instancia
  List<UploadItem>? _items;


  ///
  /// Visibles son todos los intems con estado
  /// con estado distinto a Upload.status = archived
  /// TODO: Colocar la regla de negocio en otro lado
  ///
  Future<List<UploadItem>> getVisibles() async {
    
    if (_items == null) {
      final items = await _localRepository.getVisibles();
      _items = items;
      _cleanUploadsOk();
    }

    return _items!;
  }


  ///
  /// Agregar nuevo item con PENDING a la lista de precarga
  ///
  Future<void> addItem(UploadItem item) async {
        
    item.id = await _localRepository.insertItem(item);
    
    _items!.insert(0, item);
    notifyListeners();
  }

  ///
  /// Intentar subir a la nube, sino marcarlo como error
  /// para dar la opcion de volver a intentar
  ///
  Future<void> uploadItem(UploadItem item) async {

    item.status = UploadStatus.uploading;
    notifyListeners();
    
    _cloudRepository.uploadItem(item)
      .then((value) {
        item.publicId = value;
        item.status = UploadStatus.done;
        _proccessUploadOk(item);
      })
      .onError((error, stackTrace) {
        item.status = UploadStatus.error;
      })
      .whenComplete(() {
        _localRepository.updateItem(item)
          .then((value){
            notifyListeners();
          });
      });
  }


  ///
  /// Eliminar item de la lista y notificar
  /// Eliminar archivo del filesystem
  ///
  Future<void> deleteItem(UploadItem item) async {
    
    await _localRepository.deleteItem(item);
    _items!.remove(item);
    FilesHelper.deleteFile(item.path)
      .then((value){
        notifyListeners();
      });
  }


  ///
  /// Una vez subido esperar unos segundos para visualizar y luego pasar
  /// a archived y eliminar el archivo de la cache
  ///
  void _proccessUploadOk(UploadItem item) async{

    Future.delayed(const Duration(seconds: 3))
      .then((value) { 
        item.status = UploadStatus.archived;
        FilesHelper.deleteFile(item.path)
          .then((value){
            _localRepository.updateItem(item)
              .then((value) {
                _items!.remove(item);
                notifyListeners();
              });
          });
      });
  }



  ///
  /// Al inicializar la app
  ///
  void _cleanUploadsOk() {
    _items!
      .where( (item) => item.status == UploadStatus.done )
      .toList()
      .forEach( (item) => _proccessUploadOk( item ) );
  }


}