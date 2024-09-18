import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/presentation/providers/providers.dart';

final cameraProvider = StateNotifierProvider.autoDispose<CameraNotifier, CameraState>((ref) {
  
  final itemsProvider = ref.watch(uploadGalleryProvider.notifier);
  
  return CameraNotifier(
    itemProvider: itemsProvider
  );

});


class CameraNotifier extends StateNotifier<CameraState> {

  late CameraController _cameraController;
  final UploadGalleryProvider itemProvider;

  CameraNotifier({ required this.itemProvider }):super(
    const CameraState()
  ) {
    initCapturer();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }


  void initCapturer() async {

    List<CameraDescription> cameras = await availableCameras();

    _cameraController = CameraController(
      cameras.first, 
      ResolutionPreset.max
    );

    state = state.copyWith(cameraController: _cameraController);
    await _cameraController.initialize();
    state = state.copyWith(isReadyToCapture: true);

  }


  Future<XFile> getPictureFile() async {

    state = state.copyWith(
      isTakingPhoto: true,
      // isReadyToCapture: true,
    );
    
    final XFile file;

    // try {
      file = await _cameraController.takePicture();
      // return file;
    // }
    // catch (e) {
    //   print(e);
    // }

    await Future.delayed(const Duration(milliseconds: 1000));

    // state = state.copyWith(lastFile: file);
    state = state.copyWith(
      isTakingPhoto: false,
      // isReadyToCapture: true
    );
    return file;

  }


//   Future<void> takeOnePhoto() async {

//     //TODO FIXME
//     final faker = Faker();


//     state = state.copyWith(isTakingPhoto: true);
//     XFile file;    
//     try {
      
//       final positionValue = PositionValue(
//         lat: faker.geo.latitude(),
//         lng: faker.geo.longitude(),
//         accuracy: 0.0,
//         heading: 0.0,
//         altitude: 0.0,
//         speed: 0.0,
//         speedAccuracy: 0.0,
//         timestamp: '',
//       );
//       file = await _cameraController.takePicture();
      
//       await itemProvider.addItem(
//         UploadItem( path: file.path, positionValue: positionValue)
//       );
//       state = state.copyWith(isTakingPhoto: false);

//     } catch (e) {
//       print(e);
//     }
//   }

}








@immutable
class CameraState {

  final CameraController? cameraController;
  final bool isReadyToCapture;
  final bool isTakingPhoto;

  const CameraState({
    this.cameraController,
    this.isReadyToCapture = false, 
    this.isTakingPhoto = false,
  });


  CameraState copyWith({
    CameraController? cameraController,
    bool? isReadyToCapture,
    bool? isTakingPhoto,
  }) {
    return CameraState(
      cameraController: cameraController ?? this.cameraController,
      isReadyToCapture: isReadyToCapture ?? this.isReadyToCapture,
      isTakingPhoto: isTakingPhoto ?? this.isTakingPhoto,
    );
  }

}