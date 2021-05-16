import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapPage> {

  Completer<GoogleMapController> _controller = Completer();
  MapType mapType = MapType.normal;
  
  @override
  Widget build(BuildContext context) {
  
    // final ScanModel scan = ModalRoute.of(context).settings.arguments;
    final marker = LatLng(-31.663993431973054, -50.370704650878906);

    final CameraPosition puntoInicial = CameraPosition(
      target: marker,
      zoom: 14.4746,
    );

    // Markers<<
    Set<Marker> markers = new Set<Marker>();
    markers.add(
      new Marker(
        markerId: MarkerId('geo-location'),
        position: marker
      )
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('Coordenadas'),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.my_location),
          //     onPressed: () async {
          //       final GoogleMapController controller = await _controller.future;
          //         controller.animateCamera(
          //           CameraUpdate.newCameraPosition(puntoInicial)
          //         );
          //     }
          //   ),
          // ],
        ),
        body: GoogleMap(
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          mapType: mapType,
          // markers: markers,
          initialCameraPosition: puntoInicial,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.layers),
        //   onPressed: ( ) {
        //     if(mapType == MapType.normal) {
        //       mapType = MapType.satellite;
        //     } else {
        //       mapType = MapType.normal;
        //     }
        //     setState(() {
        //       //
        //     });
        //   },
        // )
    );
  }
}
