import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:saig_app/presentation/providers/geo/geo_providers.dart';

class DistanceShotingScreen extends ConsumerStatefulWidget {

  const DistanceShotingScreen({super.key});

  @override
  ConsumerState<DistanceShotingScreen> createState() => _DistaceShotingScreenState();
}

class _DistaceShotingScreenState extends ConsumerState<DistanceShotingScreen> {

  MapboxMap? mapboxMap;
  double _currentSliderValue = 20;

  
  _onMapCreated(MapboxMap mapboxMap) async {
    print('_onMapCreated');
    this.mapboxMap = mapboxMap;
  }


  _onStyleLoaded(StyleLoadedEventData data) async {

    await mapboxMap?.style.addSource(GeoJsonSource(id: 'buffer'));
    // await mapboxMap?.style.addGeoJSONSourceFeatures('buffer', 'bufferDataId', [featureCenter] );
    await mapboxMap?.style.addLayer(
      LineLayer(
        id: "line_layer",
        sourceId: "buffer",
        lineJoin: LineJoin.ROUND,
        lineCap: LineCap.ROUND,
        lineColor: Colors.blueAccent.value,
        lineWidth: 6.0
      )
    );

  }

  _updateReferenceCenter(Feature featureCenter) async {
    
    print(featureCenter.geometry);
    // await mapboxMap?.style.addSource(GeoJsonSource(id: 'buffer'));
    await mapboxMap?.style.addGeoJSONSourceFeatures('buffer', 'bufferDataId', [featureCenter] );
    await mapboxMap?.style.updateGeoJSONSourceFeatures('buffer', 'bufferDataId', [featureCenter] );
    
    // await mapboxMap?.style.addLayer(LineLayer(
    //     id: "line_layer",
    //     sourceId: "buffer",
    //     lineJoin: LineJoin.ROUND,
    //     lineCap: LineCap.ROUND,
    //     lineColor: Colors.yellow.value,
    //     lineWidth: 6.0
    //   )
    // );

  }

  @override
  Widget build(BuildContext context) {

    final featureCenter = ref.watch(circleCenterProvider);

    final currentSliderValue = ref.watch(circleRadiusProvider);


    featureCenter.when(
      data: (data) => _updateReferenceCenter(data),
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
                ref.read(circleRadiusProvider.notifier).update((state) => value);
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
                zoom: 14.0
              ),
              onMapCreated: _onMapCreated,
              onStyleLoadedListener: _onStyleLoaded,
            ),
          ),
        ],
      )
    );
  }
}



// Slider(
//     value: _currentVolume,
//     max: 5,
//     divisions: 5,
//     label: _currentVolume.toString(),
//     onChanged: (double value) {
//       setState(() {
//         _currentVolume = value;
//       });
//     },
//   );