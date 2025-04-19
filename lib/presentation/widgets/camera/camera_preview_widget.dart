import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPreviewWidget extends StatelessWidget {
  
  const CameraPreviewWidget({super.key, required this.controller});
  
  final CameraController controller;

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Container(
        decoration: controller.value.isTakingPicture
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
          controller.value.isInitialized
            ? CameraPreview(controller)
            : const Center(
                child: CircularProgressIndicator()
            )
        ),
      ),
    );
  }
}
