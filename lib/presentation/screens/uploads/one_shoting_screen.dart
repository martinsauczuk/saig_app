import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saig_app/domain/entities/upload_item.dart';
import 'package:saig_app/domain/enums/upload_status.dart';
import 'package:saig_app/presentation/providers/uploads_provider.dart';

class OneShotingScreen extends StatefulWidget {

  final CameraDescription camera;
  const OneShotingScreen({super.key, required this.camera});

  @override
  State<OneShotingScreen> createState() => _OneShotingScreenState();
}

class _OneShotingScreenState extends State<OneShotingScreen> {

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.max,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }


  @override
  Widget build(BuildContext context) {

    final UploadsProvider uploadsProvider = context.watch<UploadsProvider>();


    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Pre carga de imagen'),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done ) {
                return Expanded(child: CameraPreview(_controller));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          UploadItem item = await buildItem();
          uploadsProvider.addItem(item);
          Navigator.pop(context);
        },
        child: const Icon(Icons.camera, size: 50,),
      ),
      
      // Center(
      //   child: Column(
      //     children: [
      //       IconButton(
      //         onPressed: () {
      //           print('onPressed');
      //         },
      //         iconSize: 50.0,
      //         icon: const Icon(Icons.account_tree_sharp)
      //       )
      //     ],
      //   ),
      // )
    );
  }


  Future<UploadItem> buildItem() async {
    UploadItem item = UploadItem();

    final image = await captureImageItem();

    item.path = image.path;
    item.status = UploadStatus.pending;

    return item;
  }

  ///
  /// Take Picture
  ///
  Future<XFile> captureImageItem() async {

    print('taking Picture');
    
  
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;
      // await getPosition().then((value) => { //TODO
      //       print(value),
      //       _item.lat = value.latitude,
      //       _item.lng = value.longitude,
      //       _item.accuracy = value.accuracy,
      //       _item.heading = value.heading,
      //       _item.altitude = value.altitude,
      //       _item.speed = value.speed,
      //       _item.speedAccuracy = value.speedAccuracy,
      //       _item.timestamp = value.timestamp.toString()
      //     });

      final image = await _controller.takePicture();
      // item.path = image.path;

      // Acceleronmeter
      // _item.accelerometerX = accelerometer.x;
      // _item.accelerometerY = accelerometer.y;
      //   _item.accelerometerZ = accelerometer.z;

      // // Magnetometer
      // _item.magnetometerX = magnetometer.x;
      // _item.magnetometerY = magnetometer.y;
      // _item.magnetometerZ = magnetometer.z;

      // _item.descripcion = _description;
      // item.status = UploadStatus.pending;
      // print('$_item');
      // uploadsProvider.addItem(_item);
      return image;
    } catch (e) {
      print(e);
      throw Exception('Error al tomar foto');
    }

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}