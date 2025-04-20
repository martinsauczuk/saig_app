import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:saig_app/domain/domain.dart';
import 'package:saig_app/presentation/providers/providers.dart';
import 'package:turf/turf.dart' hide Point, Feature;

import '../../widgets/widgets.dart';


class DistanceShotingScreen extends ConsumerStatefulWidget {
  const DistanceShotingScreen({super.key});

  @override
  ConsumerState<DistanceShotingScreen> createState() =>
      _DistaceShotingScreenState();
}

class _DistaceShotingScreenState extends ConsumerState<DistanceShotingScreen> {

  CameraController? _cameraController;


  MapboxMap? mapboxMap;
  CircleAnnotationManager? circleAnnotationManager;
  final List<CircleAnnotation> _targetCircleAnnotationList = [];

  int buildCounter = 0;

  // Constants
  static final int _colorCircleInRadio = Colors.blue.toARGB32();
  static final int _colorCircleOutRadio = Colors.green.toARGB32();
  static final int _colorCircleLocation = Colors.tealAccent.toARGB32();

  static final double _circleRadius = 10.0;

  String _textFieldValue = '';
  ViewportState _viewport = CameraViewportState(center: Point(
                  coordinates: Position(
                    -58.35055075717234,
                    -34.645330358739,
                  ),
                ),
                zoom: 14.0);
  bool _started = false;
  double _timerDuration = 3;

  // Counters
  int _gpsCounter = 0;
  int _captureCounter = 0;
  late Timer _timerCapture;

  @override
  void initState() {
    super.initState();
    _initializeCameraController();
    _initTimer();
  }



  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    mapboxMap.annotations.createCircleAnnotationManager().then((value) {
      circleAnnotationManager = value;
    });
  }


  void _initTimer() {
    _timerCapture = Timer(Duration(seconds: _timerDuration.toInt()), () {});
  } 


  ///
  ///
  ///
  _onStyleLoaded(StyleLoadedEventData data) async {
    
    // location
    await mapboxMap?.style.addSource(GeoJsonSource(id: 'location_source'));
    await mapboxMap?.style.addLayer(FillLayer(
      id: 'line_layer',
      sourceId: 'location_source',
      fillColor: _colorCircleLocation,
      fillOpacity: 0.4,
    ));
    await mapboxMap?.location
        .updateSettings(LocationComponentSettings(enabled: true, pulsingEnabled: false, ));

  }


  ///
  ///
  ///
  _onPressedStart() {
    setState(() {
      _viewport = FollowPuckViewportState(
        zoom: 14.0,
        pitch: 0,
      );
      _started = true;
    });

    _timerCapture = Timer.periodic(Duration(seconds: _timerDuration.toInt()), _onTimerCapture );


  }


  ///
  /// Timer interval
  ///
  void _onTimerCapture(Timer timer) {
    
    _captureIfTargetsInRadio();

  }

  ///
  ///
  ///
  void _captureIfTargetsInRadio() {
    
    final localRepository = ref.read(uploadsLocalRepository);

    if(ref.read(targetsInRadioCounterProvider) > 0 
        && _cameraController!.value.isInitialized
        && !_cameraController!.value.isTakingPicture
      ) {
        setState(() {});
        final Future<UploadItem> itemFuture =_captureUploadItem();
        itemFuture.then((item){
          localRepository.insertItem(item).then((id) {
            print('>>>Item: $id');
            _captureCounter ++;
          });
          
        }).onError((error, stackTrace) {
         print(error);
         _onPressedStop();
        });
      }

    setState(() {});

  }

  ///
  ///
  ///
  void _updateTargetCircleDistanceList() async {
    
    final currentRadioValue = ref.read(circleRadiusProvider);
    PositionValue? positionValue = await ref.read(positionValueProvider.future); // FIXME
    
    int counterInRadio = 0;
    for (CircleAnnotation circleAnnotation in _targetCircleAnnotationList) {
      counterInRadio += _updateCircleDistance(circleAnnotation, Position(positionValue!.lng as num, positionValue.lat as num), currentRadioValue, counterInRadio);
      circleAnnotationManager!.update(circleAnnotation);
    }

    ref.read(targetsInRadioCounterProvider.notifier)
       .update((state) => counterInRadio);
     
  }



  ///
  /// Update  circleAnnotation comparing distance
  ///
  int _updateCircleDistance(CircleAnnotation circleAnnotation, Position position, double distance, int counter) {

    int value = 0;
    final calculatedDistance = distanceRaw(
      position,
      circleAnnotation.geometry.coordinates,
      Unit.meters
    );
    if (calculatedDistance < distance) {
      circleAnnotation.circleColor = _colorCircleInRadio;
      value = 1;
    } else {
      circleAnnotation.circleColor = _colorCircleOutRadio;
    }
    return value;
  }


  ///
  ///
  ///
  Future<UploadItem> _captureUploadItem() async {
    
    UploadItem? item;
    XFile imageFile;
      try {
        imageFile = await _cameraController!.takePicture();
        setState(() {});
        print('>>File: ${imageFile.path}');
        
        item = UploadItem(
          path: imageFile.path,
          description: 'DistanceShoting_$_captureCounter',
          accelerometer: await ref.read(accelerometerGravityProvider.future),
          magnetometer: SensorValue(0, 0, 0), //TODO: Add magnetometer
          positionValue: await ref.read(positionValueProvider.future),
        );
        return item;
    } on CameraException catch (e) {
      print(e);
      return Future.error(e);
    }
  }


  ///
  /// Stop button
  ///
  _onPressedStop() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_captureCounter items capturados en ${_timerCapture.tick} intervalos')
      )
    );
    setState(() {
      _started = false;
      _captureCounter = 0;
    });
    _timerCapture.cancel();
    ref.invalidate(uploadGalleryProvider); //TODO: Buscar una mejor opcion que invalidate aca
  }


  ///
  /// 
  ///
  _updateReferenceCenter(Feature featureCenter) async {
    await mapboxMap?.style.removeGeoJSONSourceFeatures(
        'location_source', 'bufferDataId', ['location_buffer']);

    await mapboxMap?.style.addGeoJSONSourceFeatures(
        'location_source', 'bufferDataId', [featureCenter]);
  }


  ///
  /// Load features from FeatureRepository
  ///
  _loadTargetFeatures() async{

    final featureRepository = ref.watch(featureProvider);
    List<Feature> featurePoints =  await featureRepository.getTargetFeaturePointsById(_textFieldValue);

    for (final featurePoint in featurePoints) {
      CircleAnnotation circleAnnotation = await circleAnnotationManager!.create(CircleAnnotationOptions(
          geometry: featurePoint.geometry as Point,
          circleColor: _colorCircleOutRadio,
          circleRadius: _circleRadius,
        ));
      _targetCircleAnnotationList.add(circleAnnotation);
    }

    ScaffoldMessenger.of(context)
      .showSnackBar( SnackBar(content: Text('${featurePoints.length} puntos cargados')) );
    
    setState(() { });

  }

  ///
  /// Delete all features
  ///
  void _deleteAllFeatures() async {
    await circleAnnotationManager?.deleteAll().then((onValue) {
      ScaffoldMessenger
        .of(context).showSnackBar( SnackBar(content: Text('Puntos eliminados')) );
    });
    setState(() {
      _targetCircleAnnotationList.clear();
    });
  }


  ///
  ///
  ///
  void _onFeatureCenterData(Feature data) {
    _updateReferenceCenter(data);
    _gpsCounter ++;
    _updateTargetCircleDistanceList();
  }


  Future<void> _initializeCameraController() async {
    
    List<CameraDescription> cameras = await availableCameras();
    
    CameraController cameraController = CameraController(
      cameras.first, 
      ResolutionPreset.max
    );
    await cameraController.initialize();

    setState(() {
      _cameraController = cameraController;
    });
  }

  @override
  Widget build(BuildContext context) {

    final featureCenterAsync = ref.watch(locationBufferFeatureProvider);
    final currentRadioValue = ref.watch(circleRadiusProvider);
    final targetsInRadioCounter = ref.watch(targetsInRadioCounterProvider);

    featureCenterAsync.when(
      data: _onFeatureCenterData,
      error: (error, stackTrace) => print('$error'),
      loading: () => {},
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Captura por distancia'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8), 
            child: Column(
              children: [
                CustomSliderWidget(
                  enabled: true,
                  currentValue: currentRadioValue,
                  minValue: 0,
                  maxValue: 300,
                  divisions: 20,
                  unitLabel: 'm',
                  onChanged: (double value) {
                    ref
                      .read(circleRadiusProvider.notifier)
                      .update((state) => value);
                  },
                ),
                CustomSliderWidget(
                  enabled: !_started,
                  currentValue: _timerDuration,
                  minValue: 3,
                  maxValue: 20,
                  divisions: 17,
                  unitLabel: 's',
                  onChanged: (value) {
                    setState(() {
                      _timerDuration = value;
                    });
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'nombre del archivo',
                        ),
                        onChanged: (value) {
                          _textFieldValue = value;
                        }
                      ),
                    ),
                    IconButton.filled(
                      onPressed: _loadTargetFeatures,
                      icon: Icon(Icons.download)
                    )
                  ],
                ),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconTextIndicatorWidget(
                          icon: Icons.satellite_alt,
                          caption: _gpsCounter.toString(),
                        ),
                        IconTextIndicatorWidget(
                          icon: Icons.circle , 
                          caption: _targetCircleAnnotationList.length.toString()
                        ),
                        IconTextIndicatorWidget(
                          icon: Icons.adjust_outlined , 
                          caption: '$targetsInRadioCounter'
                        ),
                        IconTextIndicatorWidget(
                          icon: Icons.timer_outlined , 
                          caption: _timerCapture.isActive
                                    ? _timerCapture.tick.toString()
                                    : '-'
                        ),
                        IconTextIndicatorWidget(
                          icon: Icons.collections, 
                          caption: _captureCounter.toString()
                        ),
                      ],
                    ),
                    _cameraController != null
                      ? CameraPreviewWidget(controller: _cameraController!)
                      : CircularProgressIndicator()
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: MapWidget(
              viewport: _viewport,
              styleUri: MapboxStyles.LIGHT,
              cameraOptions: CameraOptions(
                  center: Point(
                    coordinates: Position(
                      -58.35055075717234,
                      -34.645330358739,
                    ),
                  ),
                  zoom: 10.0),
              onMapCreated: _onMapCreated,
              onStyleLoadedListener: _onStyleLoaded,
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,      
        children: [
          FloatingActionButton(
            heroTag: 'start',
            onPressed: _started 
              ? _onPressedStop
              : _onPressedStart,
            child: Icon(_started ? Icons.stop : Icons.play_arrow),
          ),
          FloatingActionButton(
            heroTag: 'deleteAll',
            onPressed: () async {
              _deleteAllFeatures();
            },
            child: Icon(Icons.delete_forever_sharp),
          )
        ],
      ),
    );
  }

  
  @override
  void dispose() {
    _timerCapture.cancel();
    disposeCameraController();
    super.dispose();
  }

  void disposeCameraController() {
    if (_cameraController != null) {
      _cameraController!.dispose();
    }
  }
}
