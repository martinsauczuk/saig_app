import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/presentation/providers/providers.dart';
import 'package:saig_app/presentation/widgets/widgets.dart';

class OneShotingScreen extends ConsumerWidget {

  const OneShotingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final cameraState = ref.watch(cameraProvider);
    final shotingNotifier = ref.read(shotingProvider.notifier);
    final shotingState = ref.watch(shotingProvider);

    final double screenHeight = MediaQuery.of(context).size.height;

    void onPressedCaptureButton() async {
      shotingNotifier.takeOnePhoto();
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(shotingState.message),
      ),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.2,
            child: shotingState.lastFile != null
             ? Image.file(
                  File(shotingState.lastFile!.path)
                )
             : const Placeholder(color: Colors.amber),
          )
          ,
          // const Placeholder(color: Colors.amber),
          _CapturerView(
            height: screenHeight * 0.4,
          ),
          const _SensorsView(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                iconSize: 40,
                onPressed: (cameraState.isReadyToCapture && !cameraState.isTakingPhoto)
                  ? onPressedCaptureButton
                  : null
                , 
                icon: const Icon(Icons.camera)
              )
          ])
        ],
      ),
    );

  }
}

class _SensorsView extends ConsumerWidget {
  
  const _SensorsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final gyroscope$ = ref.watch(gyroscopeProvider);
    final acceleromenterGravity$ = ref.watch(accelerometerGravityProvider);
    final acceleromenterUser$ = ref.watch(accelerometerUserProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SensorXYZWidget(
          asyncValue: gyroscope$,
          caption: 'Gyroscope', 
          icon: Icons.threesixty
        ),
        SensorXYZWidget(
          asyncValue: acceleromenterGravity$,
          caption: 'Accelerometer',
          icon: Icons.speed, 
        ),
        SensorXYZWidget(
          asyncValue: acceleromenterUser$,
          caption: 'User accelerometer',
          icon: Icons.person,
        )
      ],
    );
  }
}

class _CapturerView extends ConsumerWidget {
  
  const _CapturerView({required this.height});
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final capturerState = ref.watch(cameraProvider);

    return Center(
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
          SizedBox(
            height: height,
            child: capturerState.isReadyToCapture
              ? CameraPreview( capturerState.cameraController!)
              : const Center(
                child: CircularProgressIndicator()
              )
          )
        ),
      ),
    );
  }

}