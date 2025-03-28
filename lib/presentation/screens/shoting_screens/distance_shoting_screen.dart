import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:saig_app/presentation/providers/providers.dart';


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

  @override
  void initState() {
    super.initState();
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    mapboxMap.annotations.createCircleAnnotationManager().then((value) {
      circleAnnotationManager = value;
    });
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
  _startRoute() {
    setState(() {
      _viewport = FollowPuckViewportState(
        zoom: 14.0,
        pitch: 0,
      );
    });
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


  _searchFeaturesInRadio(Feature featureCenter) async {
    print('searching...');
    


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

    final featureCenter = ref.watch(locationBufferFeatureProvider);
    final currentSliderValue = ref.watch(circleRadiusProvider);

    featureCenter.when(
      data: (data) async{
        _updateReferenceCenter(data);
        _searchFeaturesInRadio(data);
      },
      error: (error, stackTrace) => print('$error'),
      loading: () => {},
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Captura por distancia ${currentSliderValue.toString()}'),
      ),
      body: Column(
      children: [
        Slider(
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8), 
          child: Column(
            children: [
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
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Puntos total: ${_featurePoints.length}'),
                        Text('Puntos en radio: 0')
                      ],
                    ),
                  ),
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
          onPressed: _startRoute,
          child: Icon(Icons.play_arrow),
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
