import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorsProvider with ChangeNotifier {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  static const SIZE = 10; // Cantidad de valores a promediar

  Queue<double> _accelerometerQueueX = Queue.of(List.filled(SIZE, 0));
  double _accelerometerMeanX = 0;

  Queue<double> _accelerometerQueueY = Queue.of(List.filled(SIZE, 0));
  double _accelerometerMeanY = 0;

  Queue<double> _accelerometerQueueZ = Queue.of(List.filled(SIZE, 0));
  double _accelerometerMeanZ = 0;

  Queue<double> _magnetometerQueueX = Queue.of(List.filled(SIZE, 0));
  double _magnetometerMeanX = 0;

  Queue<double> _magnetometerQueueY = Queue.of(List.filled(SIZE, 0));
  double _magnetometerMeanY = 0;

  Queue<double> _magnetometerQueueZ = Queue.of(List.filled(SIZE, 0));
  double _magnetometerMeanZ = 0;

  late int _counter;
  late Timer timer1;

  void startTimer() {
    print('start timer');
    _counter = 1;

    timer1 = Timer.periodic(Duration(milliseconds: 3000), (timer) {
      _counter++;
      // print('increment counter $_counter');
      notifyListeners();
    });
  }

  init() {
    // Acelerometro
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          // Eje x
          _accelerometerQueueX.addFirst(event.x);
          _accelerometerQueueX.removeLast();
          double accelerometerSumX =
              _accelerometerQueueX.reduce((value, element) => value + element);
          _accelerometerMeanX = accelerometerSumX / SIZE;

          notifyListeners();
          // print(_accelerometerMeanX);

          // Eje Y
          _accelerometerQueueY.addFirst(event.y);
          _accelerometerQueueY.removeLast();
          double accelerometerSumY =
              _accelerometerQueueY.reduce((value, element) => value + element);
          _accelerometerMeanY = accelerometerSumY / SIZE;

          // Eje Z
          _accelerometerQueueZ.addFirst(event.z);
          _accelerometerQueueZ.removeLast();
          double accelerometerSumZ =
              _accelerometerQueueZ.reduce((value, element) => value + element);
          _accelerometerMeanZ = accelerometerSumZ / SIZE;
        },
      ),
    );

    // Magnetometro
    _streamSubscriptions.add(
      magnetometerEvents.listen(
        (MagnetometerEvent event) {
          // Eje x
          _magnetometerQueueX.addFirst(event.x);
          _magnetometerQueueX.removeLast();
          double magnetometerSumX =
              _magnetometerQueueX.reduce((value, element) => value + element);
          _magnetometerMeanX = magnetometerSumX / SIZE;

          // Eje Y
          _magnetometerQueueY.addFirst(event.y);
          _magnetometerQueueY.removeLast();
          double magnetometerSumY =
              _magnetometerQueueY.reduce((value, element) => value + element);
          _magnetometerMeanY = magnetometerSumY / SIZE;

          // Eje Z
          _magnetometerQueueZ.addFirst(event.z);
          _magnetometerQueueZ.removeLast();
          double magnetometerSumZ =
              _magnetometerQueueZ.reduce((value, element) => value + element);
          _magnetometerMeanZ = magnetometerSumZ / SIZE;
        },
      ),
    );
  }

  double getMeanX() {
    return _accelerometerMeanX;
  }

  Future<String> delayedString() {
    Future<String> myFuture = Future.delayed(Duration(seconds: 3), () {
      return 'Hola Mundo';
    });

    return myFuture;
  }

  ///
  /// timer example
  ///
  int timerString() {
    print(_counter);
    return _counter;
  }
}
