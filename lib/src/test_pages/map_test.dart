import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

  static const String ACCESS_TOKEN =
      'pk.eyJ1IjoibXNhdWN6dWsiLCJhIjoiY2tqb3VkeTE3MTc5OTJxbjA3bDB5cDZ1dSJ9.No63VlJhfD9TLgRTTgSFwA';


  // MapboxMapController? mapController;
  // CameraPosition _position = _kInitialPosition;
  // bool _isMoving = false;
  // bool _mapExpanded = true;
  // CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  // MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;

  // bool _scrollGesturesEnabled = true;
  // bool? _doubleClickToZoomEnabled;
  // bool _tiltGesturesEnabled = true;
  // bool _zoomGesturesEnabled = true;
  // bool _telemetryEnabled = true;
  bool _myLocationEnabled = false;

  // void _extractMapInfo() {
  //   final position = mapController!.cameraPosition;
  //   if (position != null) _position = position;
  //   _isMoving = mapController!.isCameraMoving;
  // }

  // void _onMapChanged() {
  //   setState(() {
  //     _extractMapInfo();
  //   });
  // }

  // void onMapCreated(MapboxMapController controller) {
  //   mapController = controller;
  //   mapController!.addListener(_onMapChanged);
  //   _extractMapInfo();

  //   mapController!.getTelemetryEnabled().then((isEnabled) => setState(() {
  //         _telemetryEnabled = isEnabled;
  //       }));
  // }

  @override
  void initState() {
    Future<Position> position =
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    position.then((value) => setState(() {
          print("------location ok");
          _myLocationEnabled = true;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MapboxMap mapboxMap = MapboxMap(
      accessToken: ACCESS_TOKEN,
      initialCameraPosition: _kInitialPosition,
      trackCameraPosition: true,
      compassEnabled: true,
      rotateGesturesEnabled: false,
      scrollGesturesEnabled: false,
      myLocationEnabled: _myLocationEnabled,
      myLocationTrackingMode: MyLocationTrackingMode.TrackingCompass,
      myLocationRenderMode: MyLocationRenderMode.COMPASS,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
      ),
      drawer: MenuWidget(),
      body: mapboxMap,
    );
  }
}
