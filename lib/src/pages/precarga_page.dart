import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:saig_app/src/enums/upload_status.dart';
import 'package:saig_app/src/models/upload_item_model.dart';
import 'package:saig_app/src/providers/uploads_provider.dart';

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
  /// Imagen y botones de carga
  ///
  Widget _previewImage() {
    // final Text? retrieveError = _getRetrieveErrorWidget();

    if( _item.pickedFile == null ) {
      return Container(
        // color: Colors.amber,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_library), 
              onPressed: () => _onLoadButtonPressed(ImageSource.gallery, context),
            ),
            IconButton(
              icon: Icon(Icons.camera_alt), 
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
          Expanded(child: _previewImage() ),
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
  /// Subir imagen
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
