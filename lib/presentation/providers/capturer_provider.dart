import 'package:camera/camera.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/domain/domain.dart';
import 'package:saig_app/domain/entities/positition_value.dart';
import 'package:saig_app/presentation/providers/providers.dart';

final capturerProvider = StateNotifierProvider.autoDispose<CapturerNotifier, CapturerState>((ref) {
  
  final itemsProvider = ref.watch(uploadItemsProvider.notifier);
  
  return CapturerNotifier(
    itemProvider: itemsProvider
  );

});


class CapturerNotifier extends StateNotifier<CapturerState> {

  late CameraController _cameraController;
  final UploadItemsProvider itemProvider;

  CapturerNotifier({ required this.itemProvider }):super(
    const CapturerState()
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


  Future<void> takeOnePhoto() async {

    //TODO FIXME
    final faker = Faker();


    state = state.copyWith(isTakingPhoto: true);
    XFile file;    
    try {
      
      final positionValue = PositionValue(
        lat: faker.geo.latitude(),
        lng: faker.geo.longitude(),
        accuracy: 0.0,
        heading: 0.0,
        altitude: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        timestamp: '',
      );
      file = await _cameraController.takePicture();
      
      await itemProvider.addItem(
        UploadItem( path: file.path, positionValue: positionValue)
      );
      state = state.copyWith(isTakingPhoto: false);

    } catch (e) {
      print(e);
    }
  }

}








@immutable
class CapturerState {

  final CameraController? cameraController;
  final bool isReadyToCapture;
  final bool isTakingPhoto;

  const CapturerState({
    this.cameraController,
    this.isReadyToCapture = false, 
    this.isTakingPhoto = false
  });


  CapturerState copyWith({
    CameraController? cameraController,
    bool? isReadyToCapture,
    bool? isTakingPhoto
  }) {
    return CapturerState(
      cameraController: cameraController ?? this.cameraController,
      isReadyToCapture: isReadyToCapture ?? this.isReadyToCapture,
      isTakingPhoto: isTakingPhoto ?? this.isTakingPhoto
    );
  }

}