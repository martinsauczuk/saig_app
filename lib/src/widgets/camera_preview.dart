import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

///
/// Camera preview
///
class CameraPreviewWidget extends StatelessWidget {
  const CameraPreviewWidget({
    super.key,
    required CameraController controller,
  }) : _controller = controller;

  final CameraController _controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: _controller.value.isTakingPicture
                ? Colors.redAccent
                : Colors.grey,
            width: 3.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Center(child: CameraPreview(_controller)),
        ),
      ),
    );
  }
}