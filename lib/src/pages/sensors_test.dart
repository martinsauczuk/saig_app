import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:saig_app/src/widgets/menu_widget.dart';
import 'package:sensors_plus/sensors_plus.dart';


class SensorsTestPage extends StatefulWidget {
  

  @override
  _SensorsTestPageState createState() => _SensorsTestPageState();
}

class _SensorsTestPageState extends State<SensorsTestPage> {

  List<double>? _accelerometerValues;
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  static const SIZE = 100; // Cantidad de valores a promediar
  

  Queue<double> _magnetometerQueueX = Queue.of(List.filled(SIZE, 0));
  double _magnetometerMeanX = 0;

  Queue<double> _magnetometerQueueY = Queue.of(List.filled(SIZE, 0));
  double _magnetometerMeanY = 0;

  Queue<double> _magnetometerQueueZ = Queue.of(List.filled(SIZE, 0));
  double _magnetometerMeanZ = 0;
  // List<double>? _magnetometerY;
  // List<double>? _magnetometerZ;
  

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  Widget build(BuildContext context) {

    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(4)).toList();
    final gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(4)).toList();
    final userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();
    final magnetometer =
        _magnetometerValues?.map((double v) => v.toStringAsFixed(4)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Prueba de sensores')
      ),
      drawer: MenuWidget(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Accelerometer: $accelerometer'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('UserAccelerometer: $userAccelerometer'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Gyroscope: $gyroscope'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Magnetometer mean: [ ${_magnetometerMeanX.toStringAsFixed(3)} ${_magnetometerMeanY.toStringAsFixed(3)} ${_magnetometerMeanZ.toStringAsFixed(3)} ]'),
                Text('[10]: [ ${_magnetometerQueueX.elementAt(10).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(10).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(10).toStringAsFixed(3)} ]' ),
                Text('[20]: [ ${_magnetometerQueueX.elementAt(20).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(20).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(20).toStringAsFixed(3)} ]' ),
                Text('[30]: [ ${_magnetometerQueueX.elementAt(30).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(30).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(30).toStringAsFixed(3)} ]' ),
                Text('[40]: [ ${_magnetometerQueueX.elementAt(40).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(40).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(40).toStringAsFixed(3)} ]' ),
                Text('[50]: [ ${_magnetometerQueueX.elementAt(50).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(50).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(50).toStringAsFixed(3)} ]' ),
                Text('[60]: [ ${_magnetometerQueueX.elementAt(60).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(60).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(60).toStringAsFixed(3)} ]' ),
                Text('[70]: [ ${_magnetometerQueueX.elementAt(70).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(70).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(70).toStringAsFixed(3)} ]' ),
                Text('[80]: [ ${_magnetometerQueueX.elementAt(80).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(80).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(80).toStringAsFixed(3)} ]' ),
                Text('[90]: [ ${_magnetometerQueueX.elementAt(90).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(90).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(90).toStringAsFixed(3)} ]' ),
                Text('[99]: [ ${_magnetometerQueueX.elementAt(99).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(99).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(99).toStringAsFixed(3)} ]' ),
                Text('Magnetometer current: $magnetometer'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          setState(() {
            _gyroscopeValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) {
          setState(() {
            _userAccelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      magnetometerEvents.listen(
        (MagnetometerEvent event) {
          setState(() {
            
            _magnetometerValues = <double>[event.x, event.y, event.z];

            // Eje x
            _magnetometerQueueX.addFirst(event.x);
            _magnetometerQueueX.removeLast();
            double magnetometerSumX = _magnetometerQueueX.reduce((value, element) => value + element );
            _magnetometerMeanX = magnetometerSumX / SIZE;
            
            // Eje Y
            _magnetometerQueueY.addFirst(event.y);
            _magnetometerQueueY.removeLast();
            double magnetometerSumY = _magnetometerQueueY.reduce((value, element) => value + element );
            _magnetometerMeanY = magnetometerSumY / SIZE;

            // Eje Z
            _magnetometerQueueZ.addFirst(event.z);
            _magnetometerQueueZ.removeLast();
            double magnetometerSumZ = _magnetometerQueueZ.reduce((value, element) => value + element );
            _magnetometerMeanZ = magnetometerSumZ / SIZE;

          });
        },
      ),
    );
  }
}