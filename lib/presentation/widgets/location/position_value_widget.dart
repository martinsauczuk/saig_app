import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/domain/domain.dart';

class PositionValueWidget extends StatelessWidget {
  
  final AsyncValue<PositionValue> positionAsyncValue;


  const PositionValueWidget({
    required this.positionAsyncValue,
    super.key
  });


  @override
  Widget build(BuildContext context) {

    return positionAsyncValue.when(
      data: (PositionValue position) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on),
              Text('Longitude: ${position.lng.toStringAsFixed(2)}'),
              Text('Latitude: ${position.lat.toStringAsFixed(2)}'),
              Text('Time: ${position.timestamp.split(' ').last}'),
              Text('Accuracy: ${position.accuracy.toStringAsFixed(2)}'),
              Text('Altitude: ${position.altitude.toStringAsFixed(2)}'),
              // Text('Heading: ${position.heading.toStringAsFixed(2)}'),
              // Text('Speed: ${position.speed.toStringAsFixed(2)}'),
              Text('SpeedAccuracy: ${position.speedAccuracy.toStringAsFixed(2)}'),
            ],
         );
        },    
        error: (error, stackTrace) => Column(
        children: [
          const Text('No location enabled'),
        ],
      ), 
      loading: () => const CircularProgressIndicator(),
    ); 
  }
}