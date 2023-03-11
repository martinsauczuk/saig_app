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

  Timer timer = Timer(Duration(seconds: 5000), () {});

  String status = 'Waiting. Press start';
  int counter = 0;
  int interval = 5;

  void traceStatus(String text) {
    print(text);
    setState(() {
      status = text;
    });
  }

  int countBuild = 0;

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
      traceStatus('Shoting $counter ...');
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

        final image = await _controller.takePicture();
        _item.path = image.path;

        // Acceleronmeter
        _item.accelerometerX =
            context.read<SensorsProvider>().accelerometerMean.x;
        _item.accelerometerY =
            context.read<SensorsProvider>().accelerometerMean.y;
        _item.accelerometerZ =
            context.read<SensorsProvider>().accelerometerMean.z;

        // Magnetometer
        _item.magnetometerX =
            context.read<SensorsProvider>().magnetometerMean.x;
        _item.magnetometerY =
            context.read<SensorsProvider>().magnetometerMean.y;
        _item.magnetometerZ =
            context.read<SensorsProvider>().magnetometerMean.z;

        _item.descripcion = 'photo_batch_$counter';
        _item.status = UploadStatus.pending;

        traceStatus('Building item $_item');
        counter++;
        uploadsProvider.addItem(_item);
      } catch (e) {
        // If an error occurs, log the error to the console.
        status = e.toString();
        print(e);
      }
    }

    void onStartButton() {
      counter = 1;
      takePicture();
      timer = Timer.periodic(Duration(seconds: interval), (timer) {
        print('timer: ${timer.tick}');
        traceStatus('starting timer $timer');
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
          title: Text('Captura múltiple'),
        ),
        body: Column(
          children: [
            SensorsIndicatorsWidget(
                accelerometer: accelerometer, magnetometer: magnetometer),
            CameraPreviewWidget(controller: _controller),
            Container(
              color: Colors.teal,
              padding: const EdgeInsets.all(6.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                        initialValue: '5',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          labelText: 'Intervalo en segundos',
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          try {
                            interval = int.parse(value);
                          } catch (e) {
                            interval = 5;
                          }
                        }),
                  ),
                  Container(
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: onStartButton,
                            icon: Icon(Icons.play_arrow)),
                        IconButton(
                            onPressed: onStopButton, icon: Icon(Icons.stop)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text('$status\n\n', maxLines: 3, overflow: TextOverflow.ellipsis),
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
    if (timer.isActive) {
      timer.cancel();
    }
  }
}

///
/// SensorIndicator
/// Reusable
///
class SensorsIndicatorsWidget extends StatelessWidget {
  const SensorsIndicatorsWidget({
    super.key,
    required this.accelerometer,
    required this.magnetometer,
  });

  final SensorValue accelerometer;
  final SensorValue magnetometer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Accelerometer mean'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('X: ${accelerometer.x.toStringAsFixed(7)}'),
            Text('Y: ${accelerometer.y.toStringAsFixed(7)}'),
            Text('Z: ${accelerometer.z.toStringAsFixed(7)}'),
          ],
        ),
        Text('Magnetometer mean'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('X: ${magnetometer.x.toStringAsFixed(7)}'),
            Text('Y: ${magnetometer.y.toStringAsFixed(7)}'),
            Text('Z: ${magnetometer.z.toStringAsFixed(7)}'),
          ],
        ),
      ],
    );
  }
}

///
/// Camera preview
///
class CameraPreviewWidget extends StatelessWidget {
  const CameraPreviewWidget({
    super.key,
    required CameraController controller,
  }) : _controller = controller;

  final CameraController _controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: _controller.value.isTakingPicture
                ? Colors.redAccent
                : Colors.grey,
            width: 3.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Center(child: CameraPreview(_controller)),
        ),
      ),
    );
  }
}
