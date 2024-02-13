import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/domain/domain.dart';
import 'package:saig_app/infrastructure/cloudinary/cloudinary.dart';
import 'package:saig_app/infrastructure/device/filesystem_helper.dart';
import 'package:saig_app/infrastructure/repositories/uploads_cloud_repository_impl.dart';
import 'package:saig_app/infrastructure/repositories/uploads_local_repository_impl.dart';
import 'package:saig_app/infrastructure/sqlite/uploads_local_sqlite_datasource.dart';

final uploadscloudRepository = Provider<UploadsCloudRepository>((ref) 
  => UploadsCloudRepositoryImpl(datasource: CloudinaryUploadsCloudDatasource())
);

final uploadItemsProvider = StateNotifierProvider<UploadItemsProvider, List<UploadItem>>((ref) {

  return UploadItemsProvider( 
    localRepository: UploadsLocalRepositoryImpl(UploadsLocalSqliteDatasource.instance ), 
    cloudRepository: ref.watch(uploadscloudRepository) 
  );

});


class UploadItemsProvider extends StateNotifier<List<UploadItem>> {

  final UploadsLocalRepository localRepository;
  final UploadsCloudRepository cloudRepository;

  UploadItemsProvider({
    required this.localRepository, 
    required this.cloudRepository
  }): super([]) {
    initUploadItems();
  }

  Future<void> initUploadItems() async {

    final items = await localRepository.getVisibles();
    state = items;
    
      // _cleanUploadsOk();

  }


  Future<void> addItem(UploadItem item) async {
      
    print('Adding Item $item');
    final generatedId = await localRepository.insertItem(item);

    final itemSaved = item.copyWith(id: generatedId);
    
    state = [
      itemSaved,
      ...state
    ];

      // state = [
      //   item,
      //   ...state
      // ];

      // Future.delayed(const Duration(seconds: 3), () {
      //   final newitem = item.copyWith( status: UploadStatus.uploading );
      //   state = [
      //     ...state,
      //     newitem
      //   ];

      // });
    // _items!.insert(0, item);
    
  }


  Future<void> uploadItem(UploadItem toUpload) async {

    state = [
      for (final item in state)
        if (item.id == toUpload.id) 
          item.copyWith(status: UploadStatus.uploading)
        else
          item
    ];

    Future.delayed(const Duration(seconds: 3), () {
      state = [
        for (final item in state)
          if (item.id == toUpload.id) 
            item.copyWith(status: UploadStatus.done)
          else
            item
      ];
    });
    
    // cloudRepository.uploadItem(item)
    //   .then((value) {
    //     item.publicId = value;
    //     item.status = UploadStatus.done;
    //     // _proccessUploadOk(item); TODO
    //   })
    //   .onError((error, stackTrace) {
    //     item.status = UploadStatus.error;
    //   })
    //   .whenComplete(() {
    //     localRepository.updateItem(item)
    //       .then((value){
    //         // notifyListeners();
    //       });
    //   });
  }


  Future<void> deleteItem(UploadItem toDelete) async {
    
    await localRepository.deleteItem(toDelete);
    // await FilesHelper.deleteFile(item.path);

    state = [
      for (final item in state)
        if (item.id != toDelete.id) 
          item,
    ];
    
    // _items!.remove(item);
    // FilesHelper.deleteFile(item.path)
    //   .then((value){
    //     notifyListeners();
    //   });
  }







}


