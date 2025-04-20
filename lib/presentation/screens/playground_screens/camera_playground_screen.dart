import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:saig_app/presentation/widgets/widgets.dart';

class CameraPlaygroundScreen extends StatelessWidget {
  
  const CameraPlaygroundScreen({super.key});

  @override
  Widget build(BuildContext context) {
        
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cámara: Prueba de funcionalidades'),
      ),
      drawer: const MenuWidget(),
      body: const _CameraPlaygroundView()
    );
    
  }
}


class _CameraPlaygroundView extends StatefulWidget {
  
  const _CameraPlaygroundView();

  @override
  State<_CameraPlaygroundView> createState() => _CameraPlaygroundViewState();
}

class _CameraPlaygroundViewState extends State<_CameraPlaygroundView> {
  
  CameraController? _cameraController;
  XFile? _imageFile;

  int counter = 0;

  @override
  void initState() {
    super.initState();
    _initializeCameraController();
  }

  Future<void> _initializeCameraController() async {
    
    List<CameraDescription> cameras = await availableCameras();
    
    CameraController cameraController = CameraController(
      cameras.first, 
      ResolutionPreset.max
    );
    await cameraController.initialize();
    // return cameraController;
    print('cameraController done $cameraController');

    setState(() {
      _cameraController = cameraController;
    });
  }
  
  
  @override
  Widget build(BuildContext context) {

    return _cameraController != null
      ? Column(
          children: [
            CheckboxListTile(
              title: Text('isInitialized'),
              value: _cameraController!.value.isInitialized,
              onChanged: (value) {
                setState(() {
                  counter ++;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('isTakingPicture'),
              value: _cameraController!.value.isTakingPicture, 
              onChanged: null
            ),
            Text(_cameraController!.value.toString()),
            // capturerState.isReadyToCapture
            Expanded(
              child: CameraPreviewWidget(controller: _cameraController!)
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  label: const Text('TakeOnePhoto'),
                  // onPressed: null,
                  onPressed: _cameraController != null && !_cameraController!.value.isTakingPicture
                    ? takePicture
                    : null,  
                  icon: const Icon(Icons.camera, size: 50)
                ),
                _imageFile != null
                  ? SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.file(File(_imageFile!.path)),
                    )
                  : Container()
              ],
            ),
          ],
        )
      : Center(
          child: CircularProgressIndicator()
        );
  }

  void takePicture() async {

    if (_cameraController!.value.isTakingPicture) {
      return null;
    }

    setState(() {});
    try {
      _imageFile = await _cameraController!.takePicture();
      setState(() {});
      print('>>File: ${_imageFile!.path}');
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void dispose() {
    disposeCameraController();
    super.dispose();
  }

  void disposeCameraController() {
    if (_cameraController != null) {
      _cameraController!.dispose();
    }
  }
}