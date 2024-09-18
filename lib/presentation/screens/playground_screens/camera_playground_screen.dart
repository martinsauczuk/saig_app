import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/presentation/widgets/shared/menu_widget.dart';
import 'package:saig_app/presentation/providers/providers.dart';

class CameraPlaygroundScreen extends ConsumerWidget {
  
  const CameraPlaygroundScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
        
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cámara: Prueba de funcionalidades'),
      ),
      drawer: const MenuWidget(),
      body: const _CameraPlaygroundView()
    );
    
  }
}


class _CameraPlaygroundView extends ConsumerWidget {
  
  const _CameraPlaygroundView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final capturerState = ref.watch(cameraProvider);

    return Column(
      children: [
        CheckboxListTile(
          title: const Text('capturerState.isReadyToCapture'),
          value: capturerState.isReadyToCapture, 
          onChanged: null
        ),
        CheckboxListTile(
          title: const Text('capturerState.isTakingPhoto'),
          value: capturerState.isTakingPhoto, 
          onChanged: null
        ),
        capturerState.isReadyToCapture
          ? Expanded(child: CameraPreview(capturerState.cameraController!))
          : const CircularProgressIndicator(),
        Row(
          children: [
            ElevatedButton.icon(
              label: const Text('TakeOnePhoto'),
              onPressed: null,
              // onPressed: capturerState.isTakingPhoto
                // ? null 
                // : () => ref.read(cameraProvider.notifier).takeOnePhoto(), 
              icon: const Icon(Icons.camera, size: 30)
            ),
          ],
        ),
      ],
    );
  }
}