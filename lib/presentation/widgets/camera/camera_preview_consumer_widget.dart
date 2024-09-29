import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/presentation/providers/providers.dart';

class CameraPreviewConsumerWidget extends ConsumerWidget {
  
  const CameraPreviewConsumerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final capturerState = ref.watch(cameraProvider);

    return Expanded(
      child: Container(
        decoration: capturerState.isTakingPhoto 
          ? BoxDecoration(
              border: Border.all(
                width: 8,
                color:Colors.green
              )
            )
          : BoxDecoration(
              border: Border.all(
                width: 8,
                color:Colors.white
              )
          ),
        child: (
          capturerState.isReadyToCapture
            ? CameraPreview( capturerState.cameraController!)
            : const Center(
              child: CircularProgressIndicator()
            )
        ),
      ),
    );
  }
}