import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../enums/upload_status.dart';
import '../models/sensor_value.dart';
import '../models/upload_item_model.dart';
import '../providers/sensors_provider.dart';
import '../providers/uploads_provider.dart';

class MultipleShotingPage extends StatefulWidget {
  const MultipleShotingPage({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<MultipleShotingPage> createState() => _MultipleShotingPageState();
}

Future<Position> getPosition() async {
  Future<Position> position =
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  return position;
}

class _MultipleShotingPageState extends State<MultipleShotingPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late Timer timer;

  String status = 'Esperando';
  int counter = 0;
  int milliseconds = 3000;

  void traceStatus(String text) {
    print(text);
    setState(() {
      status = text;
    });
  }

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
    void takePicture() async {
      traceStatus('Capturando $counter ...');
      final UploadItemModel _item = new UploadItemModel();
      try {
        // Ensure that the camera is initialized.
        // await _initializeControllerFuture;

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


        // _item.lat = 0.0;
        // _item.lng = 0.0;
        // _item.accuracy = 0.0;
        // _item.heading = 0.0;
        // _item.altitude = 0.0;
        // _item.speed = 0.0;
        // _item.speedAccuracy = 0.0;
        // _item.timestamp = '342344';

        final image = await _controller.takePicture();

        _item.path = image.path;

        // Acceleronmeter
        _item.accelerometerX = accelerometer.x;
        _item.accelerometerY = accelerometer.y;
        _item.accelerometerZ = accelerometer.z;

        // _item.accelerometerX = 0;
        // _item.accelerometerY = 0;
        // _item.accelerometerZ = 0;

        // Magnetometer
        _item.magnetometerX = magnetometer.x;
        _item.magnetometerY = magnetometer.y;
        _item.magnetometerZ = magnetometer.z;

        // _item.magnetometerX = 0;
        // _item.magnetometerY = 0;
        // _item.magnetometerZ = 0;

        _item.descripcion = 'photo_batch_$counter';
        _item.status = UploadStatus.pending;

        traceStatus('Building item $_item');
        uploadsProvider.addItem(_item);
      } catch (e) {
        // If an error occurs, log the error to the console.
        status = e.toString();
        print(e);
      }
    }

    void onStartButton() {
      counter = 0;
      timer = Timer.periodic(Duration(milliseconds: milliseconds), (timer) {
        print('timer: ${timer.tick}');
        traceStatus('starting timer $timer');
        counter++;
        takePicture();
      });
    }

    void onStopButton() {
      if (timer.isActive) {
        timer.cancel();
      }
      setState(() {
        counter = 0;
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Capura múltiple'),
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
            Container(
              // color: Colors.amber,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Intervalo en milisegundos',
                      fillColor: Colors.amber,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      try {
                        milliseconds = int.parse(value);
                      } catch (e) {
                        milliseconds = 3000;
                      }
                    }
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: onStartButton,
                          icon: Icon(Icons.play_arrow)),
                      IconButton(
                          onPressed: onStopButton, icon: Icon(Icons.stop)),
                      Text('$counter'),
                    ],
                  ),
                  Text('$status'),
                ],
              ),
            ),
          ],
        ));
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

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    timer.cancel();
  }
}
