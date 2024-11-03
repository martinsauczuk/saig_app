import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:saig_app/presentation/providers/geo/geo_providers.dart';
import 'package:saig_app/presentation/providers/geo/geojson_providers.dart';

class DistanceShotingScreen extends ConsumerStatefulWidget {
  const DistanceShotingScreen({super.key});

  @override
  ConsumerState<DistanceShotingScreen> createState() =>
      _DistaceShotingScreenState();
}

class _DistaceShotingScreenState extends ConsumerState<DistanceShotingScreen> {

  MapboxMap? mapboxMap;
  String _textFieldValue = '';

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  }

  _onStyleLoaded(StyleLoadedEventData data) async {
    await mapboxMap?.style.addSource(GeoJsonSource(id: 'location_source'));
    await mapboxMap!.style.addSource(GeoJsonSource(id: 'target_points_source'));
    // await mapboxMap?.style.addGeoJSONSourceFeatures('buffer', 'bufferDataId', [featureCenter] );
    await mapboxMap?.style.addLayer(FillLayer(
      id: 'line_layer',
      sourceId: 'location_source',
      fillColor: Colors.blueAccent.value,
      fillOpacity: 0.4,
    ));
    await mapboxMap?.location
        .updateSettings(LocationComponentSettings(enabled: true));

    // _loadTargetPoints();

    
  }

  _loadTargetPoints(String data) async {
    // final geojsonRepository = ref.watch(geojsonGithubRepositoryProvider);
    // String geojson =
    //     await geojsonRepository.getFeatureCollectionById('carloskeen.geojson');
    print(data);
    await mapboxMap!.style.removeStyleSource('target_points_source');
    await mapboxMap!.style.addSource(
        GeoJsonSource(id: 'target_points_source', data: data));
    await mapboxMap!.style.addLayer(
      CircleLayer(
        id: "target_points_layer",
        sourceId: "target_points_source",
        circleColor: Colors.deepOrange.value
      )
    );
  }

  _updateReferenceCenter(Feature featureCenter) async {
    await mapboxMap?.style.addGeoJSONSourceFeatures(
        'location_source', 'bufferDataId', [featureCenter]);
    await mapboxMap?.style.updateGeoJSONSourceFeatures(
        'location_source', 'bufferDataId', [featureCenter]);
  }

  _updateCamera() async {
    LocationIndicatorLayer? layerLocation = await mapboxMap?.style
        .getLayer("mapbox-location-indicator-layer") as LocationIndicatorLayer;

    await mapboxMap?.setCamera(CameraOptions(
        center: Point(
            coordinates: Position(
                layerLocation.location![1]!, layerLocation.location![0]!))));
  }

  @override
  Widget build(BuildContext context) {

    final featureCenter = ref.watch(locationBufferFeatureProvider);
    final currentSliderValue = ref.watch(circleRadiusProvider);
    final currentTargetIdValue = ref.watch(geojsonTargetIdProvider);
    final geojson = ref.watch(geojsonStringProvider);

    geojson.whenData((data) {
      _loadTargetPoints(data);
    });


    featureCenter.when(
      data: (data) {
        _updateReferenceCenter(data);
        // _updateCamera();
      },
      error: (error, stackTrace) => print('error'),
      loading: () => {},
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('Captura por distancia ${currentSliderValue.toString()}: $currentTargetIdValue'),
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
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'nombre del archivo',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _textFieldValue = value;
                        });
                      }
                    ),
                  ),
                  IconButton.filled(
                    onPressed: (){
                        ref
                          .read(geojsonTargetIdProvider.notifier)
                          .update((state) => _textFieldValue);
                    }, 
                    icon: Icon(Icons.download)
                  )
                ],
              ),
            ),
            Expanded(
              child: MapWidget(
                styleUri: MapboxStyles.LIGHT,
                cameraOptions: CameraOptions(
                    center: Point(
                      coordinates: Position(
                        -58.35055075717234,
                        -34.645330358739,
                      ),
                    ),
                    zoom: 14.0),
                onMapCreated: _onMapCreated,
                onStyleLoadedListener: _onStyleLoaded,
              ),
            ),
          ],
        ));
  }
}
