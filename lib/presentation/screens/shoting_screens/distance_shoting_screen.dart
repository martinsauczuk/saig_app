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

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  }

  _onStyleLoaded(StyleLoadedEventData data) async {
    await mapboxMap?.style.addSource(GeoJsonSource(id: 'location_source'));
    // await mapboxMap?.style.addGeoJSONSourceFeatures('buffer', 'bufferDataId', [featureCenter] );
    await mapboxMap?.style.addLayer(FillLayer(
      id: 'line_layer',
      sourceId: 'location_source',
      fillColor: Colors.blueAccent.value,
      fillOpacity: 0.4,
    ));
    mapboxMap?.location
        .updateSettings(LocationComponentSettings(enabled: true));

    final geojsonRepository = ref.watch(geojsonGithubRepositoryProvider);
    String geojson =
        await geojsonRepository.getFeatureCollectionById('autopista.json');
    print(geojson);
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

    featureCenter.when(
      data: (data) {
        _updateReferenceCenter(data);
        _updateCamera();
      },
      error: (error, stackTrace) => print('error'),
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
                setState(() {
                  ref
                      .read(circleRadiusProvider.notifier)
                      .update((state) => value);
                });
              },
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
