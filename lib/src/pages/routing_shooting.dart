import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geojson/geojson.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geopoint/geopoint.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import 'package:saig_app/src/models/point_target.dart';
import 'package:saig_app/src/providers/geo_provider.dart';
import 'package:saig_app/src/widgets/menu_widget.dart';

import '../enums/upload_status.dart';
import '../models/upload_item_model.dart';
import '../providers/sensors_provider.dart';
import '../providers/uploads_provider.dart';

class RoutingShootingPage extends StatefulWidget {
  const RoutingShootingPage({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  _RoutingShootingPageState createState() => _RoutingShootingPageState();
}

Future<Position> getPosition() async {
  Future<Position> position = Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  return position;
}

class _RoutingShootingPageState extends State<RoutingShootingPage> {
  static const String ACCESS_TOKEN =
      'pk.eyJ1IjoibXNhdWN6dWsiLCJhIjoiY2tqb3VkeTE3MTc5OTJxbjA3bDB5cDZ1dSJ9.No63VlJhfD9TLgRTTgSFwA';
  late MapboxMapController mapController;
  final _geoProvider = new GeoProvider();
  static final LatLng center = const LatLng(-34.645330358739, -58.35055075717234);
  late CameraController _controller;
  String status = 'Waiting nearby point...';
  int counter = 0;
  bool enabledTakePhoto = false;
  late Future<void> _initializeControllerFuture;

  final playerCamera = AudioPlayer();

  String _jsonFilename = '';

  // Initial position
  static final CameraPosition _kInitialPosition = CameraPosition(
    target: center,
    zoom: 14.0,
  );

  Fill? circleSmall;
  late LatLng centerReference;
  double _currentSliderValue = 20;
  late String geojsonRaw;

  List<PointTarget> pointsTarget = List.empty();

  bool _myLocationEnabled = false;
  void _onMapCreated(MapboxMapController controller) {
    this.mapController = controller;
  }

  ///
  ///
  ///
  void traceStatus(String text) {
    print(text);
    setState(() {
      status = text;
    });
  }

  ///
  /// Re dibujar circulo de referencia
  ///
  updateCircleSmall(LatLng latLng, double radius) async {
    if (circleSmall != null) {
      await mapController.removeFill(circleSmall!);
    }

    GeoJsonPolygon polygonReference =
        _geoProvider.buildGeoJsonCircle(latLng, _currentSliderValue / 1000);

    List<LatLng> geometry = polygonReference.geoSeries.first.geoPoints
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();

    circleSmall = await mapController.addFill(FillOptions(
      geometry: [geometry],
      fillColor: "#4e878c",
      fillOpacity: 0.5,
      fillOutlineColor: "#4e878c",
    ));
  }

  void _onStyleLoadedCallback() {
    // _onStyleLoadedCallback
  }


  ///
  /// Load point from Github
  ///
  void loadPointsTarget() async {

    await mapController.clearCircles();
    
    geojsonRaw = await _geoProvider.getJsonFile(_jsonFilename);
    final geo = GeoJson();

    try {
      await geo.parse(geojsonRaw);
      List<GeoJsonPoint> points = geo.points;

      List<Future<PointTarget>> pointsTargetFuture = points.map((point) async {
        Circle circle = await mapController.addCircle(
          CircleOptions(
              geometry: LatLng(point.geoPoint.latitude, point.geoPoint.longitude),
              circleColor: "#FF0000"),
        );
        return PointTarget(point, circle);
      }).toList();

      Future.wait(pointsTargetFuture).then((value) {
        pointsTarget = value;
      });
      
    } catch (e) {
      print(e);
    }

  }

  void takePicture() async {
    traceStatus('Shoting $counter ...');
    final UploadItemModel _item = new UploadItemModel();
    try {
      await getPosition().then((value) => {
            print(value),
            _item.lat = value.latitude,
            _item.lng = value.longitude,
            _item.accuracy = value.accuracy,
            _item.heading = value.heading,
            _item.altitude = value.altitude,
            _item.speed = value.speed,
            _item.speedAccuracy = value.speedAccuracy,
            _item.timestamp = value.timestamp.toString()
          });

      final image = await _controller.takePicture();
      playerCamera.play(AssetSource('camera.wav'));
      _item.path = image.path;

      // Acceleronmeter
      _item.accelerometerX = context.read<SensorsProvider>().accelerometerMean.x;
      _item.accelerometerY = context.read<SensorsProvider>().accelerometerMean.y;
      _item.accelerometerZ = context.read<SensorsProvider>().accelerometerMean.z;

      // Magnetometer
      _item.magnetometerX = context.read<SensorsProvider>().magnetometerMean.x;
      _item.magnetometerY = context.read<SensorsProvider>().magnetometerMean.y;
      _item.magnetometerZ = context.read<SensorsProvider>().magnetometerMean.z;

      _item.descripcion = 'photo_routing_$counter';
      _item.status = UploadStatus.pending;

      traceStatus('Building item $_item');
      counter++;
      context.read<UploadsProvider>().addItem(_item);
    } catch (e) {
      // If an error occurs, log the error to the console.
      status = e.toString();
      print(e);
    }
  }

  ///
  ///
  ///
  Future<void> searchPointDistance(LatLng reference, int distance) async {
    final geo = GeoJson();
    List<GeoJsonPoint> foundPoints = await geo.geofenceDistance(
        point: GeoJsonPoint(
            geoPoint: GeoPoint(latitude: reference.latitude, longitude: reference.longitude)),
        points: pointsTarget.map((e) => e.geojsonPoint).toList(),
        distance: _currentSliderValue);

    print(foundPoints);
    traceStatus('>>Points founded: ${foundPoints.length}');

    foundPoints.forEach((element) {
      print(element);
    });

    if (foundPoints.isNotEmpty) {
      GeoJsonPoint aPoint = foundPoints.first;

      PointTarget aPointTarget = pointsTarget.firstWhere(
          (element) => element.geojsonPoint.geoPoint.latitude == aPoint.geoPoint.latitude);

      traceStatus('<<PuntoEncontrado>> ${aPointTarget.geojsonPoint.geoPoint.toLatLng()}');

      takePicture();

      mapController.updateCircle(aPointTarget.circle, CircleOptions(circleColor: "#FF00FF"));
    }
  }

  @override
  void initState() {
    getPosition().then((value) {
      traceStatus(value.toString());
      _myLocationEnabled = true;
    });

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///
    /// Actualizar ubicacion
    ///
    void onUserLocationUpdated(UserLocation location) {
      traceStatus('>>Location updated ${location.position}');
      updateCircleSmall(location.position, 100);

      if (enabledTakePhoto) {
        searchPointDistance(location.position, 100);
      }
    }

    final MapboxMap mapboxMap = MapboxMap(
      accessToken: ACCESS_TOKEN,
      initialCameraPosition: _kInitialPosition,
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: _onStyleLoadedCallback,
      onUserLocationUpdated: onUserLocationUpdated,
      trackCameraPosition: true,
      compassEnabled: true,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      myLocationEnabled: _myLocationEnabled,
      myLocationTrackingMode: MyLocationTrackingMode.TrackingCompass,
      myLocationRenderMode: MyLocationRenderMode.COMPASS,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
      ),
      drawer: MenuWidget(),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    _jsonFilename = value;
                  }
                ),
              ),
              IconButton(
                onPressed: () {
                  loadPointsTarget();
                }, 
                icon: Icon(Icons.download)
              )
            ],
          ),
          SizedBox(
            child: mapboxMap,
            height: 200,
          ),
          SizedBox(
              height: 400,
              // width: 400,
              child: CameraPreview(_controller)),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _currentSliderValue,
                  min: 0,
                  max: 300,
                  divisions: 20,
                  label: _currentSliderValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValue = value;
                    });
                  },
                ),
              ),
              Switch(
                value: enabledTakePhoto,
                onChanged: (value) {
                  setState(() {
                    enabledTakePhoto = value;
                  });
                },
              ),
            ],
          ),
          Text(_jsonFilename),
          Text('$status\n\n', maxLines: 3, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    playerCamera.dispose();
  }
}
