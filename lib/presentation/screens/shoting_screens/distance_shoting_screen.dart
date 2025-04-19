import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:saig_app/presentation/screens/shoting_screens/distance_shoting_consumer.dart';

import '../../widgets/widgets.dart';

class DistanceShotingScreen extends StatefulWidget {
  const DistanceShotingScreen({super.key});

  @override
  State<DistanceShotingScreen> createState() => _DistanceShotingScreenState();
}

class _DistanceShotingScreenState extends State<DistanceShotingScreen> with WidgetsBindingObserver{
  
  CameraController? _cameraController;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _initializeCameraController();
  }
  
  Future<void> _initializeCameraController() async {
    
    List<CameraDescription> cameras = await availableCameras();
    
    CameraController cameraController = CameraController(
      cameras.first, 
      ResolutionPreset.max
    );
    await cameraController.initialize();

    setState(() {
      _cameraController = cameraController;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Captura por distancia'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        // child: (_cameraController != null && _cameraController!.value.isInitialized)
        //           ? CameraPreviewWidget(controller: _cameraController!)
        //           : CircularProgressIndicator(),
        child: Column(
          children: [
            SizedBox(
              // width: 300,
              height: 300,
              child: DistanceConsumerWidget()
              // child: Placeholder(),
            ),
            // Padding(
              // padding: const EdgeInsets.symmetric(horizontal: 8), 
            SizedBox(
              height: 500,
              child: 
                (_cameraController != null && _cameraController!.value.isInitialized)
                  ? CameraPreviewWidget(controller: _cameraController!)
                  : CircularProgressIndicator()
            )
          ],
        ),
      )
    );
  }
}