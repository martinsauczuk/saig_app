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
    // print('<<Build>>');
    final UploadsProvider uploadsProvider = context.read<UploadsProvider>();

    SensorValue accelerometer =
        context.watch<SensorsProvider>().accelerometerMean;

    // print(accelerometerInstant);

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
                  // Text('X: ${_magnetometerMeanX.toStringAsFixed(7)}'),
                  // Text('Y: ${_magnetometerMeanY.toStringAsFixed(7)}'),
                  // Text('Z: ${_magnetometerMeanZ.toStringAsFixed(7)}'),
                ],
              ),
              Expanded(child: Divider()),
              TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ingrese una descripción para la imagen',
                  ),
                  onChanged: (value) {
                    // print(value);
                    // this._descripcion = value;
                    _description = value;
                    // setState(() {
                    //   //
                    // });
                  }),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
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
            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();
            _item.path = image.path;

            // Acceleronmeter
            // _item.accelerometerX = _accelerometerMeanX;
            // _item.accelerometerY = _accelerometerMeanY;
            // _item.accelerometerZ = _accelerometerMeanZ;

            // // Magnetometer
            // _item.magnetometerX = _magnetometerMeanX;
            // _item.magnetometerY = _magnetometerMeanY;
            // _item.magnetometerZ = _magnetometerMeanZ;

            _item.descripcion = _description;
            _item.status = UploadStatus.pending;
            print('$_item');
            uploadsProvider.addItem(_item);
            Navigator.pop(context);
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
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
