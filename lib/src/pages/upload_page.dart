import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saig_app/src/providers/upload_provider.dart';
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

  final ImagePicker _picker = ImagePicker();
  PickedFile? _imageFile;
  dynamic _pickImageError;
  double _lat = 0;
  double _lng = 0;

  final _uploadProvider = new UploadProvider();


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
  Widget _coordenadasDisplay() {

    return Container(
      color: Colors.blueGrey.shade50,
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
        color: Colors.amber,
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
      color: Colors.amber,
      child: Image.file( 
        File( _imageFile!.path),
        fit: BoxFit.cover,
        height: 400.0,
      ),
    );
  }
  
  
  ///
  /// Cuadro de upload con imagen y coordenadas
  ///
  Widget _uploadItem(BuildContext context) {
    return Container(
      color: Colors.teal.shade100,
      child: Column(children: <Widget>[
        _coordenadasDisplay(),
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
        IconButton(
          icon: Icon(Icons.upload_sharp),
          onPressed: _imageFile == null
            ? null
            : () => _uploadImage() 
        ),
      ])
    );
  }

  ///
  /// Subir imagen
  ///
  void _uploadImage() {
    print('subiendo...');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog (
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Cargando'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget> [
              Text('Subiendo imagen con coordenadas a Cloudinary'),
              Icon(Icons.sync, size: 60.0)
            ]
          ),
        );
      },
    );

    _uploadProvider.uploadImage(_imageFile!, _lat, _lng)
      
      .then(
        (id) {
          print('ok url >' + id);
          this._imageFile = null;
          Navigator.pop(context);
          setState(() {
            
          });
          final snackBar = SnackBar(content: Text('Imagen $id subida ok'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      );

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
