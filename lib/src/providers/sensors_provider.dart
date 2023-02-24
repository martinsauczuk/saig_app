import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:saig_app/src/models/sensor_value.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorsProvider with ChangeNotifier {
  
  // Cantidad de valores a promediar
  static const ACC_SIZE = 100; 

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  // Accelerometer
  SensorValue _accelerometerInstant = SensorValue(0, 0, 0);
  SensorValue _accelerometerMean = SensorValue(0, 0, 0);
  Queue<SensorValue> _accelerometerQueue =
      Queue.of(List.filled(ACC_SIZE, SensorValue(0, 0, 0)));


  SensorValue get accelerometerInstant => _accelerometerInstant;
  SensorValue get accelerometerMean => _accelerometerMean;

  init() {
    _listenAccelerometer();

    // Magnetometro
    // _streamSubscriptions.add(
    //   magnetometerEvents.listen(
    //     (MagnetometerEvent event) {
    //       // Eje x
    //       _magnetometerQueueX.addFirst(event.x);
    //       _magnetometerQueueX.removeLast();
    //       double magnetometerSumX =
    //           _magnetometerQueueX.reduce((value, element) => value + element);
    //       _magnetometerMeanX = magnetometerSumX / ACC_SIZE;

    //       // Eje Y
    //       _magnetometerQueueY.addFirst(event.y);
    //       _magnetometerQueueY.removeLast();
    //       double magnetometerSumY =
    //           _magnetometerQueueY.reduce((value, element) => value + element);
    //       _magnetometerMeanY = magnetometerSumY / ACC_SIZE;

    //       // Eje Z
    //       _magnetometerQueueZ.addFirst(event.z);
    //       _magnetometerQueueZ.removeLast();
    //       double magnetometerSumZ =
    //           _magnetometerQueueZ.reduce((value, element) => value + element);
    //       _magnetometerMeanZ = magnetometerSumZ / ACC_SIZE;
    //     },
    //   ),
    // );
  }

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



  @override
  void dispose() {
    print("<<< disposing sensors provider>>");
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }
}
