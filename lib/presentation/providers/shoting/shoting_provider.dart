import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:saig_app/domain/domain.dart';
import 'package:saig_app/presentation/providers/providers.dart';



final shotingProvider = StateNotifierProvider.autoDispose<ShotingNotifier, ShotingState>((ref) {
  
  return ShotingNotifier(
    cameraNotifier: ref.watch(cameraProvider.notifier),
    // gyroscopeValue: ref.watch(gyroscopeProvider),
  );

});


class ShotingNotifier extends StateNotifier<ShotingState> {
  
  final CameraNotifier cameraNotifier;
  // final AsyncValue<SensorValue> gyroscopeValue;

  ShotingNotifier({
    required this.cameraNotifier,
    // required this.gyroscopeValue,
  }): super(const ShotingState());


  // @override
  // void dispose() {
  //   super.dispose();
  // }

  Future<void> takeOnePhoto() async {

    XFile file = await cameraNotifier.getPictureFile();

    state = state.copyWith(
      lastFile: file,
      message: file.path
    );

    final uploadItem = UploadItem(
      path: file.path
    );

    // gyroscopeValue.whenData((value) {
    //   print(value);
    // });



    // print('>>Gyroscope value ${gyroscopeValue.value}');

    // uploadItem.copyWith(accelerometer: .value ) 


    print(uploadItem);
    

  }


}

@immutable
class ShotingState {

  final XFile? lastFile;
  final UploadItem? lastUploadItem;
  final String message;

  const ShotingState({
    this.lastFile,
    this.lastUploadItem,
    this.message = 'starting',
  });


  ShotingState copyWith({
    XFile? lastFile,
    UploadItem? lastUploadItem,
    String? message,
  }) {
    return ShotingState(
      lastFile: lastFile ?? this.lastFile,
      lastUploadItem: lastUploadItem ?? this.lastUploadItem,
      message: message ?? this.message
    );
  }

}
