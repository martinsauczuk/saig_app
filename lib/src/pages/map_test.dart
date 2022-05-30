import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:saig_app/src/widgets/menu_widget.dart';


class MapTestPage extends StatefulWidget {
  
  @override
  _MapTestPageState createState() => _MapTestPageState();
  
}

class _MapTestPageState extends State<MapTestPage> {
  

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(-34.70624, -58.2784),
    zoom: 11.0,
  );

  static const String ACCESS_TOKEN = 'pk.eyJ1IjoibXNhdWN6dWsiLCJhIjoiY2tqb3VkeTE3MTc5OTJxbjA3bDB5cDZ1dSJ9.No63VlJhfD9TLgRTTgSFwA';


  MapboxMapController? mapController;
  CameraPosition _position = _kInitialPosition;
  bool _isMoving = false;
  bool _compassEnabled = true;
  bool _mapExpanded = true;
  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  int _styleStringIndex = 0;
  // Style string can a reference to a local or remote resources.
  // On Android the raw JSON can also be passed via a styleString, on iOS this is not supported.
  List<String> _styleStrings = [
    MapboxStyles.MAPBOX_STREETS,
    MapboxStyles.SATELLITE,
    "assets/style.json"
  ];
  List<String> _styleStringLabels = [
    "MAPBOX_STREETS",
    "SATELLITE",
    "LOCAL_ASSET"
  ];
  bool _rotateGesturesEnabled = true;
  bool _scrollGesturesEnabled = true;
  bool? _doubleClickToZoomEnabled;
  bool _tiltGesturesEnabled = true;
  bool _zoomGesturesEnabled = true;
  bool _myLocationEnabled = true;
  bool _telemetryEnabled = true;
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.None;
  List<Object>? _featureQueryFilter;
  Fill? _selectedFill;




  @override
  Widget build(BuildContext context) {


    final MapboxMap mapboxMap = MapboxMap(
      accessToken: ACCESS_TOKEN,
      // onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
      // trackCameraPosition: true,
      // compassEnabled: _compassEnabled,
      // cameraTargetBounds: _cameraTargetBounds,
      // minMaxZoomPreference: _minMaxZoomPreference,
      // styleString: _styleStrings[_styleStringIndex],
      // rotateGesturesEnabled: _rotateGesturesEnabled,
      // scrollGesturesEnabled: _scrollGesturesEnabled,
      // tiltGesturesEnabled: _tiltGesturesEnabled,
      // zoomGesturesEnabled: _zoomGesturesEnabled,
      // doubleClickZoomEnabled: _doubleClickToZoomEnabled,
      // myLocationEnabled: _myLocationEnabled,
      // myLocationTrackingMode: _myLocationTrackingMode,
      // myLocationRenderMode: MyLocationRenderMode.GPS,
      // onMapClick: (point, latLng) async {
      //   print(
      //       "Map click: ${point.x},${point.y}   ${latLng.latitude}/${latLng.longitude}");
      //   print("Filter $_featureQueryFilter");
      //   List features = await mapController!
      //       .queryRenderedFeatures(point, [], _featureQueryFilter);
      //   print('# features: ${features.length}');
      //   _clearFill();
      //   if (features.isEmpty && _featureQueryFilter != null) {
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //         content: Text('QueryRenderedFeatures: No features found!')));
      //   } else if (features.isNotEmpty) {
      //     _drawFill(features);
      //   }
      // },
      // onMapLongClick: (point, latLng) async {
      //   print(
      //       "Map long press: ${point.x},${point.y}   ${latLng.latitude}/${latLng.longitude}");
      //   Point convertedPoint = await mapController!.toScreenLocation(latLng);
      //   LatLng convertedLatLng = await mapController!.toLatLng(point);
      //   print(
      //       "Map long press converted: ${convertedPoint.x},${convertedPoint.y}   ${convertedLatLng.latitude}/${convertedLatLng.longitude}");
      //   double metersPerPixel =
      //       await mapController!.getMetersPerPixelAtLatitude(latLng.latitude);

      //   print(
      //       "Map long press The distance measured in meters at latitude ${latLng.latitude} is $metersPerPixel m");

      //   List features =
      //       await mapController!.queryRenderedFeatures(point, [], null);
      //   if (features.length > 0) {
      //     print(features[0]);
      //   }
      // },
      onCameraTrackingDismissed: () {
        this.setState(() {
          _myLocationTrackingMode = MyLocationTrackingMode.None;
        });
      },
      onUserLocationUpdated: (location) {
        print(
            "new location: ${location.position}, alt.: ${location.altitude}, bearing: ${location.bearing}, speed: ${location.speed}, horiz. accuracy: ${location.horizontalAccuracy}, vert. accuracy: ${location.verticalAccuracy}");
      },
    );

    // void onMapCreated(MapboxMapController controller) {
      // mapController = controller;
      // mapController!.addListener(_onMapChanged);
      // _extractMapInfo();

      // mapController!.getTelemetryEnabled().then((isEnabled) => setState(() {
      //       _telemetryEnabled = isEnabled;
      //     }));
    // }



    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
      ),
      drawer: MenuWidget(),
      body:
      // body: Stack(children: [
        // SizedBox(
          // height: MediaQuery.of(context).size.height * 0.8,
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                SizedBox(  
                  child: mapboxMap,
                  height: 400,
                  width: 200,
                ),
              
              
              
            ]),
          )
        // )
      );
      //   // margin: EdgeInsetsDirectional.all(10),
      //   // child: Column(
      //     // mainAxisSize: MainAxisSize.min,
      //     // children: [
      //       // Center(
      //         // child: SizedBox(
      //           // width: 300.0,
      //           // height: 500.0,
                // mapboxMap,
              // ),
            // ),
          // ],
        // )
      // );
    // );
  }
}