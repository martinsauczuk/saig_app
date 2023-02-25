import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:saig_app/src/enums/upload_status.dart';
import 'package:saig_app/src/models/sensor_value.dart';
import 'package:saig_app/src/models/upload_item_model.dart';
import 'package:saig_app/src/providers/sensors_provider.dart';
import 'package:saig_app/src/providers/uploads_provider.dart';

class OneShotingPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const OneShotingPage({Key? key, required this.cameras}) : super(key: key);

  @override
  _OneShotingPageState createState() => _OneShotingPageState();
}

Future<Position> getPosition() async {
  Future<Position> position =
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  return position;
}

class _OneShotingPageState extends State<OneShotingPage> {

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final UploadItemModel _item = new UploadItemModel();
    
  String _description = 'sin descripcion';

  @override
  Widget build(BuildContext context) {
    
    final UploadsProvider uploadsProvider = context.read<UploadsProvider>();
    final SensorValue accelerometer =
        context.watch<SensorsProvider>().accelerometerMean;
    final SensorValue magnetometer =
        context.watch<SensorsProvider>().magnetometerMean;

    ///
    /// Take Picture
    ///
    void onTakePictureButtonPressed() async {
      print('taking Picture');
      try {
        // Ensure that the camera is initialized.
        await _initializeControllerFuture;
        await getPosition().then((value) => {
              print(value),
              _item.lat = value.latitude,
              _item.lng = value.longitude,
              _item.accuracy = value.accuracy,
              _item.heading = value.heading,
              _item.altitude = value.altitude,
              _item.speed = value.speed,
              _item.speedAccuracy = value.speedAccuracy,
              _item.timestamp = value.timestamp.toString()
            });

        final image = await _controller.takePicture();
        _item.path = image.path;

        // Acceleronmeter
        _item.accelerometerX = accelerometer.x;
        _item.accelerometerY = accelerometer.y;
        _item.accelerometerZ = accelerometer.z;

        // // Magnetometer
        _item.magnetometerX = magnetometer.x;
        _item.magnetometerY = magnetometer.y;
        _item.magnetometerZ = magnetometer.z;

        _item.descripcion = _description;
        _item.status = UploadStatus.pending;
        print('$_item');
        uploadsProvider.addItem(_item);
        Navigator.pop(context);
      } catch (e) {
        // If an error occurs, log the error to the console.
        print(e);
      }
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Pre carga de imagen'),
      ),
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Column(
            children: [
              Text('Accelerometer'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('X: ${accelerometer.x.toStringAsFixed(7)}'),
                  Text('Y: ${accelerometer.y.toStringAsFixed(7)}'),
                  Text('Z: ${accelerometer.z.toStringAsFixed(7)}'),
                ],
              ),
              Text('Magnetometer'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('X: ${magnetometer.x.toStringAsFixed(7)}'),
                  Text('Y: ${magnetometer.y.toStringAsFixed(7)}'),
                  Text('Z: ${magnetometer.z.toStringAsFixed(7)}'),
                ],
              ),
              Expanded(child: Divider()),
              TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ingrese una descripción para la imagen',
                  ),
                  onChanged: (value) {
                    _description = value;
                  }),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onTakePictureButtonPressed,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    print('initState');

    context.read<SensorsProvider>().init();

    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.cameras.first,
      // Define the resolution to use.
      ResolutionPreset.max,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }
}
