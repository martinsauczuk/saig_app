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
  static const SIZE = 10; // Cantidad de valores a promediar
  

  Queue<double> _magnetometerQueueX = Queue.of(List.filled(SIZE, 0));
  double _magnetometerMeanX = 0;

  Queue<double> _magnetometerQueueY = Queue.of(List.filled(SIZE, 0));
  double _magnetometerMeanY = 0;

  Queue<double> _magnetometerQueueZ = Queue.of(List.filled(SIZE, 0));
  double _magnetometerMeanZ = 0;
  

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
                Text('[00]: [ ${_magnetometerQueueX.elementAt(0).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(0).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(0).toStringAsFixed(3)} ]' ),
                Text('[01]: [ ${_magnetometerQueueX.elementAt(1).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(1).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(1).toStringAsFixed(3)} ]' ),
                Text('[02]: [ ${_magnetometerQueueX.elementAt(2).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(2).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(2).toStringAsFixed(3)} ]' ),
                Text('[03]: [ ${_magnetometerQueueX.elementAt(3).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(3).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(3).toStringAsFixed(3)} ]' ),
                Text('[04]: [ ${_magnetometerQueueX.elementAt(4).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(4).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(4).toStringAsFixed(3)} ]' ),
                Text('[05]: [ ${_magnetometerQueueX.elementAt(5).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(5).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(5).toStringAsFixed(3)} ]' ),
                Text('[06]: [ ${_magnetometerQueueX.elementAt(6).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(6).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(6).toStringAsFixed(3)} ]' ),
                Text('[07]: [ ${_magnetometerQueueX.elementAt(7).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(7).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(7).toStringAsFixed(3)} ]' ),
                Text('[08]: [ ${_magnetometerQueueX.elementAt(8).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(8).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(8).toStringAsFixed(3)} ]' ),
                Text('[09]: [ ${_magnetometerQueueX.elementAt(9).toStringAsFixed(3)}, ${_magnetometerQueueY.elementAt(9).toStringAsFixed(3)}, ${_magnetometerQueueZ.elementAt(9).toStringAsFixed(3)} ]' ),
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