import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CustomCameraPreview extends StatefulWidget {
  
  final CameraController controller; 
  final bool showInfo;
  
  const CustomCameraPreview({
    super.key, 
    required this.controller,
    this.showInfo = false,
  });

  @override
  State<CustomCameraPreview> createState() => _CustomCameraPreviewState();
}

class _CustomCameraPreviewState extends State<CustomCameraPreview> {

  late Future<void> loadingCamera;

  @override
  void initState() {
    super.initState();
    loadingCamera = widget.controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: loadingCamera,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done ) {
          return Stack(
            children: [
              CameraPreview(widget.controller),
              if ( widget.showInfo ) _ControllerInfo(widget.controller),
            ]
          );

        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}

class _ControllerInfo extends StatelessWidget {
  
  final CameraController _controller;
  const _ControllerInfo(this._controller);

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme.labelSmall;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('LentsDirection: ${_controller.description.lensDirection}', style: textStyle),
          Text('Resolution: ${_controller.resolutionPreset}', style: textStyle),
          
        ],
      )
    );
  }
}