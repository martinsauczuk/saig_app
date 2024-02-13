import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/infrastructure/device/capturer_helper.dart';
import 'package:saig_app/presentation/providers/providers.dart';
import 'package:saig_app/presentation/widgets/widgets.dart';

class OneShotingScreen extends ConsumerWidget {

  const OneShotingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    AsyncValue<CameraController> controller = ref.watch( cameraControllerProvider );
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('One shotting screen'),
      ),
      body: controller.when(
        data: (controller) {
          return Column(
            children: [
              Expanded(
                child: CustomCameraPreview(controller: controller)
              ),
              Row(
                children: [
                  IconButton.filled(
                    onPressed: () async {
                      final uploadItem = await Capturer().buildItem(cameraController: controller );
                      ref.read(uploadItemsProvider.notifier).addItem(uploadItem);
                    }, 
                    icon: const Icon(Icons.camera)
                  )
                ],
              )
            ],
          );
        }, 
        error: (error, stackTrace) => ErrorIndicatorWidget(message: error.toString()), 
        loading: () => const Center( child: Text('Loading') )
      ),
    );

  }
}
