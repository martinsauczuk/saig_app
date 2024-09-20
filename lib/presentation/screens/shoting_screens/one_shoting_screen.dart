import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/domain/domain.dart';
import 'package:saig_app/presentation/providers/providers.dart';
import 'package:saig_app/presentation/widgets/widgets.dart';

class OneShotingScreen extends ConsumerStatefulWidget {

  const OneShotingScreen({super.key});

  @override
  ConsumerState<OneShotingScreen> createState() => _OneShotingScreenState();
  
}

class _OneShotingScreenState extends ConsumerState<OneShotingScreen> {
  
  // XFile? _photoFile;
  UploadItem? _uploadItem;


  ///
  /// Button to capture the image and build a UploadItem
  ///
  void _onPressedCaptureButton() async {
    
    final file = await ref.read(cameraProvider.notifier).getPictureFile();
    
    _uploadItem = UploadItem(
      path: file.path,
      accelerometer: await ref.read(accelerometerUserProvider.future),
      magnetometer: await ref.read(magnetometerProvider.future),
    );

    
    print(_uploadItem);
    setState(() {});
  }

  ///
  /// To close preview Widget
  ///
  void _onTapFilePreview() {
    
    setState(() {
      _uploadItem = null;
    });

  }


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final cameraState = ref.watch(cameraProvider);
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Captura simple'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              CameraPreviewConsumerWidget(
                height: screenHeight * 0.6,
              ),
              const SensorsConsumerWidget(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton.filledTonal(
                    iconSize: 40,
                    onPressed: (cameraState.isReadyToCapture && !cameraState.isTakingPhoto)
                      ? _onPressedCaptureButton
                      : null
                    ,
                    icon: const Icon(Icons.camera)
                  )
              ])
            ],
          ),
          if (_uploadItem != null)  
            UploadItemPreviewWidget(
              onTapFilePreview: _onTapFilePreview,
              onPressOk: _onTapFilePreview,
              item: _uploadItem!, 
              height: screenHeight * 0.6
            )
        ],
      ),
    );
  }

}
