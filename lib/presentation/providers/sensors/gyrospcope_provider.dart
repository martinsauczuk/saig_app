
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroscopeXYZ {
  final double x;
  final double y;
  final double z;

  GyroscopeXYZ(this.x, this.y, this.z);

  @override
  String toString() {
    return 'Gyroscope x: $x y:$y z: $z';
  }
}

final gysroscopeProvider = StreamProvider.autoDispose<GyroscopeXYZ>((ref) async* {
  await for (final event in gyroscopeEventStream(samplingPeriod: SensorInterval.normalInterval) ) {
    yield GyroscopeXYZ(event.x, event.y, event.z);
  }
});