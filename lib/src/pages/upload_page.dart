import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
        appBar: AppBar(
          title: Text('Carga de imagenes y coordenadas'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),
        body: Column(
          children: <Widget>[
            uploadItem(),
          ],
        ));
  }

  ///
  ///
  ///
  Widget coordenadasData() {
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
  Widget uploadItem() {
    return Container(
      color: Colors.green,
      child: Row(children: <Widget>[
        FlutterLogo(size: 100),
        Text('Un icono'),
        coordenadasData(),
        IconButton(
          onPressed: () {
              setState(() {
                getPosition();
              });
            },
          icon: Icon(Icons.refresh),
        ),
        IconButton(
          onPressed: () { },
          icon: Icon(Icons.upload_sharp),
        ),
      ]),
    );
  }

  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Position'),
  //     ),
  //     body: Column(
  //       children: <Widget> [
  //         DefaultTextStyle(
  //           style: Theme.of(context).textTheme.headline2,
  //           child: FutureBuilder<Position> (
  //             future: getPosition(),
  //             builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {

  //               if (snapshot.hasData) {

  //                 Position position = snapshot.data;
  //                 double latitude = snapshot.data.latitude;
  //                 double longitude = snapshot.data.longitude;

  //                 return Text(latitude.toString());

  //               } else {
  //                 return CircularProgressIndicator();
  //               }
  //             },
  //           ),
  //         )

  //       ],
  //     )
  //   );
  // }
}
