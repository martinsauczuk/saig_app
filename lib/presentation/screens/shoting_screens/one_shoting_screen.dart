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
  
  UploadItem? _uploadItem;

  ///
  /// Button to capture the image and build a UploadItem
  ///
  void _onPressedCaptureButton() async {
    
    final file = await ref.read(cameraProvider.notifier).getPictureFile();
    
    _uploadItem = UploadItem(
      path: file.path,
      accelerometer: await ref.read(accelerometerGravityProvider.future),
      magnetometer: SensorValue(0, 0, 0), //TODO: Add magnetometer
      positionValue: await ref.read(positionValueProvider.future),
    );
    setState(() {});
  }

  ///
  /// To close preview Widget
  ///
  void _onPressDiscardItemPreview() {
    
    setState(() {
      _uploadItem = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Borrador descartado')
      )
    );

  }


  ///
  /// Ok Button
  ///
  void _onPressConfirmItemPreview() {

    final galleryProvider = ref.read(uploadGalleryProvider.notifier);

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item cargado ok')
      )
    );

    galleryProvider.addItem(_uploadItem!);

    Navigator.pop(context);

  }


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final cameraState = ref.watch(cameraProvider);
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Captura simple'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              const CameraPreviewConsumerWidget(),
              const SensorsConsumerWidget(),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton.filledTonal(
                      iconSize: 50,
                      onPressed: (cameraState.isReadyToCapture && !cameraState.isTakingPhoto)
                        ? _onPressedCaptureButton
                        : null
                      ,
                      icon: const Icon(Icons.camera)
                    )
                ]),
              )
            ],
          ),
          if (_uploadItem != null)  
            UploadItemPreviewWidget(
              onPressDiscard: _onPressDiscardItemPreview,
              onPressOk: _onPressConfirmItemPreview,
              item: _uploadItem!, 
              height: screenHeight * 0.6,
              width: screenWidth * 0.9,
            )
        ],
      ),
    );
  }

}
