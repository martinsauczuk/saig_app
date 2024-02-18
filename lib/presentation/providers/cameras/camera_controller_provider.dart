import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cameraControllerProvider = FutureProvider<CameraController>((ref) async {
    
  Future<List<CameraDescription>> camerasFuture = availableCameras();
  List<CameraDescription> cameras = await camerasFuture;

  CameraController controller = CameraController(
    cameras.first, 
    ResolutionPreset.max
  );

  await Future.delayed(const Duration(seconds: 5), () {
    print('future ready');
  });

  await controller.initialize();

  print(controller);
  print('Provider/ Created controller');
  return controller;

});
