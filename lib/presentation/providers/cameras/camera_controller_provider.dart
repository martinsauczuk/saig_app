import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cameraControllerProvider = FutureProvider.autoDispose<CameraController>((ref) async {
    
  Future<List<CameraDescription>> camerasFuture = availableCameras();
  List<CameraDescription> cameras = await camerasFuture;

  CameraController controller = CameraController(
    cameras.first, 
    ResolutionPreset.max
  );

  print('Provider/ Created controlller');
  return controller;

});
