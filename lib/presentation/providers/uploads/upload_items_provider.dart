import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/domain/entities/upload_item.dart';
import 'package:saig_app/domain/enums/upload_status.dart';
import 'package:saig_app/domain/repositories/uploads_local_repository.dart';
import 'package:saig_app/infrastructure/repositories/uploads_local_repository_impl.dart';
import 'package:saig_app/infrastructure/sqlite/uploads_local_sqlite_datasource.dart';

final uploadItemsProvider = StateNotifierProvider<UploadItemsProvider, List<UploadItem>>((ref) {
  return UploadItemsProvider( UploadsLocalRepositoryImpl( UploadsLocalSqliteDatasource.instance ) );
});


class UploadItemsProvider extends StateNotifier<List<UploadItem>> {

  final UploadsLocalRepository _localRepository;
  UploadItemsProvider(this._localRepository): super([]) {
    initUploadItems();
  }

  Future<void> initUploadItems() async {

    final items = await _localRepository.getVisibles();
    state = items;
    
      // _cleanUploadsOk();

  }


  Future<void> addItem(UploadItem item) async {
      
      print('Add Item $item');
      // item.id = await _localRepository.insertItem(item);

      // UploadItem.copyWith(``)
      // UploadItem.copy

      state = [
        ...state,
        item
      ];

      Future.delayed(const Duration(seconds: 3), () {
        final newitem = item.copyWith( status: UploadStatus.uploading );
        state = [
          ...state,
          newitem
        ];

      });
    // _items!.insert(0, item);
    
  }


  Future<void> uploadItem(UploadItem item) async {

    // item.status = UploadStatus.uploading;
    // notifyListeners();
    
    // _cloudRepository.uploadItem(item)
    //   .then((value) {
    //     item.publicId = value;
    //     item.status = UploadStatus.done;
    //     _proccessUploadOk(item);
    //   })
    //   .onError((error, stackTrace) {
    //     item.status = UploadStatus.error;
    //   })
    //   .whenComplete(() {
    //     _localRepository.updateItem(item)
    //       .then((value){
    //         notifyListeners();
    //       });
    //   });
  }


  Future<void> deleteItem(UploadItem item) async {
    
    // await _localRepository.deleteItem(item);
    // _items!.remove(item);
    // FilesHelper.deleteFile(item.path)
    //   .then((value){
    //     notifyListeners();
    //   });
  }







}


