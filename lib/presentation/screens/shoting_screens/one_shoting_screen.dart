import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/presentation/providers/providers.dart';

class OneShotingScreen extends ConsumerWidget {

  const OneShotingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final capturerState = ref.watch(capturerProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captura simple manual'),
      ),
      body: capturerState.isReadyToCapture 
        ? const _CapturerView()
        : const Center(child: CircularProgressIndicator())
    );

  }
}

class _CapturerView extends ConsumerWidget {
  
  const _CapturerView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final capturerState = ref.watch(capturerProvider);

    return Column(
      children: [
        capturerState.isReadyToCapture
          ? Expanded(child: CameraPreview(capturerState.cameraController!))
          : const CircularProgressIndicator(),
        IconButton.filled(
          onPressed: capturerState.isTakingPhoto
            ? null 
            : () => ref.read(capturerProvider.notifier).takeOnePhoto(), 
          icon: const Icon(Icons.camera, size: 30)
        ),
      ],
    );
  }
}