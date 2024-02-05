import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:saig_app/domain/entities/sensor_value.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorsProvider with ChangeNotifier {


  
  // Cantidad de valores a promediar
  static const ACC_SIZE = 10; // acelerometro
  static const MAG_SIZE = 10; // magnetometro

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  // Accelerometer
  SensorValue _accelerometerInstant = SensorValue(0, 0, 0);
  SensorValue _accelerometerMean = SensorValue(0, 0, 0);
  Queue<SensorValue> _accelerometerQueue =
      Queue.of(List.filled(ACC_SIZE, SensorValue(0, 0, 0)));

  // Magnetometer
  SensorValue _magnetometerInstant = SensorValue(0, 0, 0);
  SensorValue _magnetometerMean = SensorValue(0, 0, 0);
  Queue<SensorValue> _magnetometerQueue =
      Queue.of(List.filled(MAG_SIZE, SensorValue(0, 0, 0)));

  ///
  /// Getters
  ///
  SensorValue get accelerometerInstant => _accelerometerInstant;
  SensorValue get accelerometerMean => _accelerometerMean;
  SensorValue get magnetometerInstant => _magnetometerInstant;
  SensorValue get magnetometerMean => _magnetometerMean;

  List<SensorValue> get magnetometerList => _magnetometerQueue.toList(growable: false);

  init() {
    _listenAccelerometer();
    _listenMagnetometer();
  }

  ///
  /// Accelerometro, emitir datos y calcular media
  ///
  void _listenAccelerometer() {
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      // register instant value
      _accelerometerInstant = SensorValue(event.x, event.y, event.z);

      // calculate mean
      _accelerometerQueue.addFirst(SensorValue(event.x, event.y, event.z));
      _accelerometerQueue.removeLast();
      SensorValue sum = _accelerometerQueue.reduce((value, element) =>
          SensorValue(
              value.x + element.x, value.y + element.y, value.z + element.z));
      _accelerometerMean =
          SensorValue(sum.x / ACC_SIZE, sum.y / ACC_SIZE, sum.z / ACC_SIZE);

      notifyListeners();
    }));
  }

  ///
  /// Magnetometro: Calcualar media
  ///
  void _listenMagnetometer() {
    _streamSubscriptions
        .add(magnetometerEvents.listen((MagnetometerEvent event) {
      // register instant value
      _magnetometerInstant = SensorValue(event.x, event.y, event.z);

      // calculate mean
      _magnetometerQueue.addFirst(SensorValue(event.x, event.y, event.z));
      _magnetometerQueue.removeLast();
      SensorValue sum = _magnetometerQueue.reduce((value, element) =>
          SensorValue(
              value.x + element.x, value.y + element.y, value.z + element.z));
      _magnetometerMean =
          SensorValue(sum.x / MAG_SIZE, sum.y / MAG_SIZE, sum.z / MAG_SIZE);

      notifyListeners();
    }));
  }

  @override
  void dispose() {
    print("<<< disposing sensors provider>>");
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}
