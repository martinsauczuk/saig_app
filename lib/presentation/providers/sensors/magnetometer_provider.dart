
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MagnetometerXYZ {
  final double x;
  final double y;
  final double z;

  MagnetometerXYZ(this.x, this.y, this.z);

  @override
  String toString() {
    return 'Magnetometer x: $x y:$y z: $z';
  }
}

final magnetometerProvider = StreamProvider.autoDispose<MagnetometerXYZ>((ref) async* {
  await for (final event in magnetometerEventStream(samplingPeriod: SensorInterval.normalInterval) ) {
    yield MagnetometerXYZ(event.x, event.y, event.z);
  }
});