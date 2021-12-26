import 'dart:async';
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
  List<double>? _accelerometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                      'X: ${_accelerometerValues!.elementAt(0).toStringAsFixed(7)}'),
                  Text(
                      'Y: ${_accelerometerValues!.elementAt(1).toStringAsFixed(7)}'),
                  Text(
                      'Z: ${_accelerometerValues!.elementAt(2).toStringAsFixed(7)}'),
                ],
              )
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
              _item.lng = value.longitude
            });
            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();
            _item.path = image.path;
            _item.accelerometerX = _accelerometerValues!.elementAt(0);
            _item.accelerometerY = _accelerometerValues!.elementAt(1);
            _item.accelerometerZ = _accelerometerValues!.elementAt(2);
            _item.descripcion = 'sin_descripcion';
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

    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
  }

}
