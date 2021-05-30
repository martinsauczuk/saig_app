import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saig_app/src/providers/cloudinary_provider.dart';
import 'package:saig_app/src/widgets/loading_alert_dialog.dart';
import 'package:saig_app/src/widgets/menu_widget.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

Future<Position> getPosition() async {
      Future<Position> position =
          Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return position;
    }


class _UploadPageState extends State<UploadPage> {

  // final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  PickedFile? _imageFile;
  dynamic _pickImageError;
  double _lat = 0;
  double _lng = 0;

  final _uploadProvider = new CloudinaryProvider();
  String _descripcion = '';

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Carga de imagen y coordenadas'),
      ),
      drawer: MenuWidget(),
      body: _uploadItem(context)
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
                this._lat = snapshot.data!.latitude;
                this._lng = snapshot.data!.longitude;

                return Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: <Widget>[
                      Text(_lat.toString()),
                      Text(_lng.toString()),
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

    if( _imageFile == null ) {
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
        File( _imageFile!.path),
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
            onPressed: _imageFile == null 
              ? null 
              : ( ) {
                setState(() {
                  _imageFile = null;
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
              this._descripcion = value;
              setState(() {
                //
              });
            }
          ),
          IconButton(
            icon: Icon(Icons.upload_sharp),
            onPressed: _imageFile == null
              ? null
              : () => _onPressUpload()
          ),
        ]
      )
    );
  }

  ///
  /// Subir imagen
  ///
  void _onPressUpload() {
    print('subiendo...');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => LoadingAlertDialog(),
    );

    _uploadProvider.uploadImage(_imageFile!, _lat, _lng, _descripcion)
      .then( (id) {
        print('ok url >' + id);
        Navigator.pop(context);
        _clean();
        final snackBar = SnackBar(content: Text('Imagen $id subida ok'), duration: Duration(milliseconds: 5000),);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).onError( (error, stackTrace) {
        print(error);
        Navigator.pop(context);
        final snackBar = SnackBar(content: Text('Error al subir imagen'), backgroundColor: Colors.red,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });

  }


  ///
  /// Limpiar imagen y descripcion
  ///
  void _clean() {
    setState(() {
      this._imageFile = null;
      this._descripcion = '';
    });
  }


  ///
  /// Cargar una imagen desde camara o galeria
  ///
  void _onLoadButtonPressed(ImageSource source, BuildContext context) async {
    
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        // maxWidth: maxWidth,
        // maxHeight: maxHeight,
        // imageQuality: quality,
      );
      setState(() {
        _imageFile = pickedFile;
       });
    } catch (e) {
      setState(() {
         _pickImageError = e;
      });
    }
  }

}
