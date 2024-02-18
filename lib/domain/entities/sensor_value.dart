class SensorValue {

  SensorValue(this.x, this.y, this.z);

  double x = 0.0;
  double y = 0.0;
  double z = 0.0;

  @override
  String toString() => '[SensorValue (x: $x, y: $y, z: $z)]';

}
