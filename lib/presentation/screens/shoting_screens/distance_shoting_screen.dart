import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:saig_app/domain/entities/sensor_value.dart';
import 'package:saig_app/domain/entities/upload_item.dart';
import 'package:saig_app/presentation/providers/providers.dart';

import '../../widgets/widgets.dart';


class DistanceShotingScreen extends ConsumerStatefulWidget {
  const DistanceShotingScreen({super.key});

  @override
  ConsumerState<DistanceShotingScreen> createState() =>
      _DistaceShotingScreenState();
}

class _DistaceShotingScreenState extends ConsumerState<DistanceShotingScreen> {

  MapboxMap? mapboxMap;
  CircleAnnotationManager? circleAnnotationManager;
  final List<Feature> _featurePoints = [];
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
  int _gpsCounter = 0;
  int _captureCounter = 0;
  late Timer _timerCapture;

  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timerCapture.cancel();
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
      fillColor: const Color.fromARGB(255, 113, 43, 90).value,
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
        zoom: 16.0,
        pitch: 0,
      );
      _started = true;
    });

    _timerCapture = Timer.periodic(Duration(seconds: 2), _onTimerCapture );


  }



  ///
  ///
  ///
  void _onTimerCapture(Timer timer) {

    final galleryProvider = ref.read(uploadGalleryProvider.notifier);

    setState(() {
      //
    });
    Future<UploadItem> itemFuture =_captureUploadItem();

    itemFuture.then((item){
      print(item.path);
      galleryProvider.addItem(item);
      _captureCounter ++;
    });


  }



  ///
  ///
  ///
  Future<UploadItem> _captureUploadItem() async {
    
    final file = await ref.read(cameraProvider.notifier).getPictureFile();
    
    UploadItem item = UploadItem(
      path: file.path,
      accelerometer: await ref.read(accelerometerGravityProvider.future),
      magnetometer: SensorValue(0, 0, 0), //TODO: Add magnetometer
      positionValue: await ref.read(positionValueProvider.future),
    );

    return item;
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
      circleAnnotationManager
        ?.create(CircleAnnotationOptions(
          geometry: featurePoint.geometry as Point,
          circleColor: Colors.green.value,
          circleRadius: 12.0,
        ));
    }
    ScaffoldMessenger.of(context)
      .showSnackBar( SnackBar(content: Text('${featurePoints.length} puntos cargados')) );
    
    setState(() {
      _featurePoints.addAll(featurePoints);
    });

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
      _featurePoints.clear();
    });
  }

  @override
  Widget build(BuildContext context) {

    final featureCenterAsync = ref.watch(locationBufferFeatureProvider);
    final currentSliderValue = ref.watch(circleRadiusProvider);

    featureCenterAsync.when(
      data: (data) async {  
          _updateReferenceCenter(data);
          _gpsCounter ++;
      },
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
                _DistanceSlider(currentSliderValue: currentSliderValue, ref: ref),
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
                          caption: _featurePoints.length.toString()
                        ),
                        IconTextIndicatorWidget(
                          icon: Icons.adjust_outlined , 
                          caption: '0'
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
                    const CameraPreviewConsumerWidget(),
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
}

class _DistanceSlider extends StatelessWidget {
  const _DistanceSlider({
    required this.currentSliderValue,
    required this.ref,
  });

  final double currentSliderValue;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('${currentSliderValue.toString()}m'),
        Expanded(
          child: Slider(
            value: currentSliderValue,
            min: 0,
            max: 300,
            divisions: 20,
            label: currentSliderValue.toString(),
            onChanged: (double value) {
                ref
                  .read(circleRadiusProvider.notifier)
                  .update((state) => value);
            },
          ),
        ),
      ],
    );
  }
}