import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/domain/domain.dart';
import 'package:saig_app/infrastructure/cloudinary/cloudinary.dart';
import 'package:saig_app/infrastructure/device/filesystem_helper.dart';
import 'package:saig_app/infrastructure/repositories/uploads_cloud_repository_impl.dart';
import 'package:saig_app/infrastructure/repositories/uploads_local_repository_impl.dart';
import 'package:saig_app/infrastructure/sqlite/uploads_local_sqlite_datasource.dart';


final uploadsLocalRepository = Provider<UploadsLocalRepositoryImpl>((ref) 
  => UploadsLocalRepositoryImpl(datasource: UploadsLocalSqliteDatasource.instance)
);


final uploadsCloudRepository = Provider<UploadsCloudRepository>((ref) 
  => UploadsCloudRepositoryImpl(datasource: CloudinaryUploadsCloudDatasource())
);



final uploadGalleryProvider = StateNotifierProvider<UploadGalleryProvider, List<UploadItem>>((ref) {

  return UploadGalleryProvider( 
    localRepository: ref.watch(uploadsLocalRepository),
    cloudRepository: ref.watch(uploadsCloudRepository),
  );

});


class UploadGalleryProvider extends StateNotifier<List<UploadItem>> {

  final UploadsLocalRepository localRepository;
  final UploadsCloudRepository cloudRepository;

  UploadGalleryProvider({
    required this.localRepository, 
    required this.cloudRepository,
  }): super([]) {
    initUploadItems();
  }

  Future<void> initUploadItems() async {

    // TODO: Modify getVisibles business rule
    final items = await localRepository.getVisibles();
    state = items;
    
  }


  Future<void> addItem(UploadItem item) async {
      
    print('Adding Item $item');
    final generatedId = await localRepository.insertItem(item);

    final itemSaved = item.copyWith(id: generatedId);
    
    state = [
      itemSaved,
      ...state
    ];
    
  }


  Future<void> uploadItem(UploadItem item) async {

    final toUpload = item.copyWith( status: UploadStatus.uploading );

    state = [
      for (final item in state)
        if (item.id == toUpload.id) 
          toUpload
        else
          item
    ];

    cloudRepository.uploadItem(toUpload)
      .then((publicId) async {
        final uplodaded = toUpload.copyWith(
          status: UploadStatus.done,
          publicId: publicId, 
        );
        await localRepository.updateItem(uplodaded);
        state = [
          for (final item in state)
            if (item.id == toUpload.id) 
              uplodaded
            else
              item
        ];
      })
      .onError((error, stackTrace) async { // TODO: Implement error message
        print(error);
        final withError = toUpload.copyWith(
          status: UploadStatus.error, 
        );
        await localRepository.updateItem(withError);

        state = [
          for (final item in state)
            if (item.id == toUpload.id) 
              withError
            else
              item
        ];

      });

  }


  Future<void> deleteItem(UploadItem toDelete) async {
    
    await localRepository.deleteItem(toDelete);
    await FilesHelper.deleteFile(toDelete.path);

    state = [
      for (final item in state)
        if (item.id != toDelete.id) 
          item,
    ];
    
  }

}


