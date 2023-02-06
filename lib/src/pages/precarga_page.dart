import 'dart:async';
import 'dart:collection';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:saig_app/src/enums/upload_status.dart';
import 'package:saig_app/src/models/upload_item_model.dart';
import 'package:saig_app/src/providers/uploads_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

class PrecargaPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const PrecargaPage({Key? key, required this.cameras}) : super(key: key);

  @override
  _PrecargaPageState createState() => _PrecargaPageState();
}

Future<Position> getPosition() async {
  Future<Position> position =
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  return position;
}

class _PrecargaPageState extends State<PrecargaPage> {

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final UploadItemModel _item = new UploadItemModel();

  static const SIZE = 10; // Cantidad de valores a promediar

  Queue<double> _accelerometerQueueX = Queue.of(List.filled(SIZE, 0));
  double _accelerometerMeanX = 0;

  Queue<double> _accelerometerQueueY = Queue.of(List.filled(SIZE, 0));
  double _accelerometerMeanY = 0;

  Queue<double> _accelerometerQueueZ = Queue.of(List.filled(SIZE, 0));
  double _accelerometerMeanZ = 0;


  Queue<double> _magnetometerQueueX = Queue.of(List.filled(SIZE, 0));
  double _magnetometerMeanX = 0;

  Queue<double> _magnetometerQueueY = Queue.of(List.filled(SIZE, 0));
  double _magnetometerMeanY = 0;

  Queue<double> _magnetometerQueueZ = Queue.of(List.filled(SIZE, 0));
  double _magnetometerMeanZ = 0;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  String _description = 'sin descripcion';

  @override
  Widget build(BuildContext context) {

    final UploadsProvider uploadsProvider = context.read<UploadsProvider>();

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
              // FutureBuilder(
              //   future: getPosition(),
              //   builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
              //     if (snapshot.hasData) {
              //       _item.lat = snapshot.data!.latitude;
              //       _item.lng = snapshot.data!.longitude;
              //       return Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: <Widget>[
              //           Text('lat: ${snapshot.data!.latitude.toStringAsFixed(7)}'),
              //           Text('lng: ${snapshot.data!.longitude.toStringAsFixed(7)}'),
              //         ],
              //       );
              //     }
              //     return Text('Cargando coordenadas...');
              //   },
              // ),
              Text('Accelerometer'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                      'X: ${_accelerometerMeanX.toStringAsFixed(7)}'),
                  Text(
                      'Y: ${_accelerometerMeanY.toStringAsFixed(7)}'),
                  Text(
                      'Z: ${_accelerometerMeanZ.toStringAsFixed(7)}'),
                ],
              ),
              Text('Magnetometer'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                      'X: ${_magnetometerMeanX.toStringAsFixed(7)}'),
                  Text(
                      'Y: ${_magnetometerMeanY.toStringAsFixed(7)}'),
                  Text(
                      'Z: ${_magnetometerMeanZ.toStringAsFixed(7)}'),
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
                }
              ),
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
            _item.accelerometerX = _accelerometerMeanX;
            _item.accelerometerY = _accelerometerMeanY;
            _item.accelerometerZ = _accelerometerMeanZ;
            
            // Magnetometer
            _item.magnetometerX = _magnetometerMeanX;
            _item.magnetometerY = _magnetometerMeanY;
            _item.magnetometerZ = _magnetometerMeanZ;

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
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    print('initState');

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



    // Acelerometro
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            // Eje x
            _accelerometerQueueX.addFirst(event.x);
            _accelerometerQueueX.removeLast();
            double accelerometerSumX = _accelerometerQueueX.reduce((value, element) => value + element );
            _accelerometerMeanX = accelerometerSumX / SIZE;
            
            // Eje Y
            _accelerometerQueueY.addFirst(event.y);
            _accelerometerQueueY.removeLast();
            double accelerometerSumY = _accelerometerQueueY.reduce((value, element) => value + element );
            _accelerometerMeanY = accelerometerSumY / SIZE;

            // Eje Z
            _accelerometerQueueZ.addFirst(event.z);
            _accelerometerQueueZ.removeLast();
            double accelerometerSumZ = _accelerometerQueueZ.reduce((value, element) => value + element );
            _accelerometerMeanZ = accelerometerSumZ / SIZE;
          });
        },
      ),
    );

    // Magnetometro
    _streamSubscriptions.add(
      magnetometerEvents.listen(
        (MagnetometerEvent event) {
          setState(() {

            // Eje x
            _magnetometerQueueX.addFirst(event.x);
            _magnetometerQueueX.removeLast();
            double magnetometerSumX = _magnetometerQueueX.reduce((value, element) => value + element );
            _magnetometerMeanX = magnetometerSumX / SIZE;
            
            // Eje Y
            _magnetometerQueueY.addFirst(event.y);
            _magnetometerQueueY.removeLast();
            double magnetometerSumY = _magnetometerQueueY.reduce((value, element) => value + element );
            _magnetometerMeanY = magnetometerSumY / SIZE;

            // Eje Z
            _magnetometerQueueZ.addFirst(event.z);
            _magnetometerQueueZ.removeLast();
            double magnetometerSumZ = _magnetometerQueueZ.reduce((value, element) => value + element );
            _magnetometerMeanZ = magnetometerSumZ / SIZE;

          });
        },
      ),
    );


  }

}
