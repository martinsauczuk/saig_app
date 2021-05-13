import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

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


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          title: Text('Carga de imagen y coordenadas'),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                onPressed: () => _onUplodButtonPressed(ImageSource.gallery, context),
                child: Icon(Icons.photo_library),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                onPressed: () => _onUplodButtonPressed(ImageSource.camera, context),
                child: Icon(Icons.camera_alt),
              ),
            )
          ],
        ), 
        body: Column(
          children: <Widget>[
            uploadItem(),
            _previewImage()
          ],
        ));
  }

  ///
  ///
  ///
  Widget _coordenadasData() {
    return FutureBuilder<Position>(
      future: getPosition(),
      builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
        if (snapshot.hasData) {
        // Position position = snapshot.data;
          double latitude = snapshot.data!.latitude;
          double longitude = snapshot.data!.longitude;

          return Column(
            children: <Widget>[
              Text(latitude.toString()),
              Text(longitude.toString()),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      }
    );
  }


  ///
  ///
  ///
  Widget _previewImage() {
    // final Text? retrieveError = _getRetrieveErrorWidget();
    if (_imageFile != null) {
      
      return Image.file( 
        File( _imageFile!.path),
        fit: BoxFit.cover,
        height: 400.0,
      );

    } else {
      return Container(child: Text('Esperando carga de imagen desde galeria o cámara') );
    }
  
  }
  
  
  ///
  /// 
  ///
  Widget uploadItem() {
    return Container(
      color: Colors.lightBlue.shade50,
      child: Row(children: <Widget>[
        Icon(Icons.location_pin),
        _coordenadasData(),
        IconButton(
          onPressed: () {
              setState(() {
                getPosition();
              });
            },
          icon: Icon(Icons.refresh),
        ),
        Expanded(child: Container() ),
        IconButton(
          onPressed: () {
              setState(() {
                _imageFile = null;
              });
            },
          icon: Icon(Icons.delete_forever),
        ),
        IconButton(
          onPressed: () { },
          icon: Icon(Icons.upload_sharp),
        ),
      ]),
    );
  }

  ///
  /// Cargar una imagen desde camara o galeria
  ///
  ///
  void _onUplodButtonPressed(ImageSource source, BuildContext context) async {
    
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
