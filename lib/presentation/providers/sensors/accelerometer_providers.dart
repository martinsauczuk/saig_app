
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/domain/domain.dart';
import 'package:sensors_plus/sensors_plus.dart';


final accelerometerGravityProvider = StreamProvider.autoDispose<SensorValue>((ref) async* {
  await for (final event in accelerometerEventStream(samplingPeriod: SensorInterval.normalInterval) ) {
    yield SensorValue(event.x, event.y, event.z);
  }
});

final accelerometerUserProvider = StreamProvider.autoDispose<SensorValue>((ref) async* {
  await for (final event in userAccelerometerEventStream(samplingPeriod: SensorInterval.normalInterval) ) {
    yield SensorValue(event.x, event.y, event.z);
  }
});