import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:saig_app/src/enums/upload_status.dart';
import 'package:saig_app/src/models/upload_item_model.dart';
import 'package:saig_app/src/providers/uploads_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

class PrecargaPage extends StatefulWidget {
  @override
  _PrecargaPageState createState() => _PrecargaPageState();
}

Future<Position> getPosition() async {
  Future<Position> position =
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  return position;
}

class _PrecargaPageState extends State<PrecargaPage> {
  

  final ImagePicker _picker = ImagePicker();
  final UploadItemModel _item = new UploadItemModel();
  List<double>? _accelerometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  dynamic _pickImageError;
 
 
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Pre carga de imagen'),
      ),
      body: _uploadItem(context),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }


  @override
  void initState() {
    super.initState();
    print('initState');
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


  ///
  /// Cuadro con las coordenadas
  ///
  Widget _buildCoordenadasDisplay() {

    return Container(
      // color: Colors.blueGrey.shade50,
      child: Row(
        children: <Widget>[
          Icon(Icons.location_pin),
          FutureBuilder<Position>(
            future: getPosition(),
            builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
              if (snapshot.hasData) {
              // Position position = snapshot.data;
                _item.lat = snapshot.data!.latitude;
                _item.lng = snapshot.data!.longitude;

                return Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: <Widget>[
                      Text(_item.lat.toString()),
                      Text(_item.lng.toString()),
                    ],
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            }
          ),
          IconButton(
            onPressed: () {
                setState(() {
                  getPosition();
                });
              },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }


  ///
  /// Cuadro con la info de los sensores
  ///
  Widget _buildSensoresDisplay() {

    return Container(
      // color: Colors.blueGrey.shade50,
      child: Row(
        children: <Widget>[
          Icon(Icons.border_inner),
          // FutureBuilder<Position>(
          //   future: getPosition(),
          //   builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
          //     if (snapshot.hasData) {
          //     // Position position = snapshot.data;
          //       _item.accelerometerX = 1.11;
          //       _item.accelerometerY = 2.22;
          //       _item.accelerometerZ = 3.33;

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: <Widget>[
                      Text(_accelerometerValues!.elementAt(0).toStringAsFixed(4)),
                      Text(_accelerometerValues!.elementAt(1).toStringAsFixed(4)),
                      Text(_accelerometerValues!.elementAt(2).toStringAsFixed(4)),
                    ],
                  ),
                ),
              // } else {
              //   return CircularProgressIndicator();
              // }
            // }
          // ),
        ],
      ),
    );
  }

  ///
  /// Imagen y botones de carga
  ///
  Widget _buildPreviewImage() {
    // final Text? retrieveError = _getRetrieveErrorWidget();

    if( _item.pickedFile == null ) {
      return Container(
        color: Colors.blueGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FloatingActionButton.extended(
              icon: const Icon(Icons.camera_alt),
              label: Text('Abrir cámara'),
              onPressed: () => _onLoadButtonPressed(ImageSource.camera, context),
            ),
          ],
        )
      );
    }

    return Container(
      // color: Colors.amber,
      child: Image.file( 
        File( _item.pickedFile!.path),
        fit: BoxFit.cover,
        height: 400.0,
      ),
    );
  }
  
  
  ///
  /// Cuadro de upload con imagen y coordenadas
  /// Widget principal
  ///
  Widget _uploadItem(BuildContext context) {
    return Container(
      // color: Colors.teal.shade100,
      child: Column(
        children: <Widget> [
          _buildCoordenadasDisplay(),
          _buildSensoresDisplay(),
          Expanded(child: _buildPreviewImage() ),
          IconButton(
            onPressed: _item.pickedFile == null 
              ? null 
              : ( ) {
                setState(() {
                  _item.pickedFile = null;
                });
              },
            icon: Icon(Icons.delete_forever),
          ),
          TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.description),
              labelText: 'Descripción para la imagen (opcional)',
            ),
            onChanged: (value) {
              print(value);
              _item.descripcion = value;
              setState(() {
                //
              });
            }
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.save_sharp),
            label: Text('Guardar pre carga'), 
            onPressed: _item.pickedFile == null
              ? null
              : () => _onPressSave()
          ),
        ]
      )
    );
  }

  ///
  /// Preparar imagen para ser subida desde la pagina de carga
  ///
  void _onPressSave() {

    final UploadsProvider uploadsProvider = context.read<UploadsProvider>();
    print('$_item');

    _item.status = UploadStatus.pending;
    uploadsProvider.addItem(_item);
    Navigator.pop(context);
  }

  ///
  /// Cargar una imagen desde camara o galeria
  ///
  void _onLoadButtonPressed(ImageSource source, BuildContext context) async {
    
    try {
      final pickedFile = await _picker.getImage(
        source: source,
      );
      setState(() {
        _item.pickedFile = pickedFile;
       });
    } catch (e) {
      setState(() {
         _pickImageError = e;
      });
    }
  }

}
