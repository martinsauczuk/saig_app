
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerXYZ {
  final double x;
  final double y;
  final double z;

  AccelerometerXYZ(this.x, this.y, this.z);

  @override
  String toString() {
    return 'AccelerometerXYZ x: $x y:$y z: $z';
  }
}

final accelerometerGravityProvider = StreamProvider.autoDispose<AccelerometerXYZ>((ref) async* {
  await for (final event in accelerometerEventStream(samplingPeriod: SensorInterval.normalInterval) ) {
    yield AccelerometerXYZ(event.x, event.y, event.z);
  }
});

final accelerometerUserProvider = StreamProvider.autoDispose<AccelerometerXYZ>((ref) async* {
  await for (final event in userAccelerometerEventStream(samplingPeriod: SensorInterval.normalInterval) ) {
    yield AccelerometerXYZ(event.x, event.y, event.z);
  }
});