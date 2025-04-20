import 'package:camera/camera.dart';
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
  CameraController? _cameraController;


  ///
  /// Button to capture the image and build a UploadItem
  ///
  void _onPressedCaptureButton() async {
    
    setState(() {});
    final file = await _cameraController!.takePicture();
    setState(() {});

    _uploadItem = UploadItem(
      path: file.path,
      description: 'One Shoting',
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

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Captura simple'),
      ),
      body: (_cameraController != null)
      ? Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                CameraPreviewWidget(controller: _cameraController!),
                const SensorsConsumerWidget(),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                        iconSize: 50,
                        onPressed: (_cameraController!.value.isInitialized && !_cameraController!.value.isTakingPicture)
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
        )
      : Center(
        child: CircularProgressIndicator() 
      )
    );
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
