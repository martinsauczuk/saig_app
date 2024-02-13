import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saig_app/presentation/widgets/shared/menu_widget.dart';
import 'package:saig_app/presentation/providers/old/sensors_provider.dart';

class SensorsPlaygroundScreen extends StatelessWidget {

  const SensorsPlaygroundScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba de sensores')
      ),
      drawer: const MenuWidget(),
      body: _SensorsView(),
    );
  }

}

class _SensorsView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final SensorsProvider sensorsProvider = context.watch<SensorsProvider>();


    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Accelerometer'),
        Text(sensorsProvider.magnetometerInstant.toString())
      ]
    );
  }
}




// class SensorsPlaggroundScreen extends StatefulWidget {

//   const SensorsPlaggroundScreen({super.key});

//   @override
//   State<SensorsPlaggroundScreen> createState() => _SensorsPlaggroundScreenState();
// }

// class _SensorsPlaggroundScreenState extends State<SensorsPlaggroundScreen> {

//   List<double>? _accelerometerValues;
//   List<double>? _userAccelerometerValues;
//   List<double>? _gyroscopeValues;
//   List<double>? _magnetometerValues;
//   static const SIZE = 10; // Cantidad de valores a promediar
  

//   Queue<double> _magnetometerQueueX = Queue.of(List.filled(SIZE, 0));
//   double _magnetometerMeanX = 0;

//   Queue<double> _magnetometerQueueY = Queue.of(List.filled(SIZE, 0));
//   double _magnetometerMeanY = 0;

//   Queue<double> _magnetometerQueueZ = Queue.of(List.filled(SIZE, 0));
//   double _magnetometerMeanZ = 0;
  

//   final _streamSubscriptions = <StreamSubscription<dynamic>>[];

//   @override
//   Widget build(BuildContext context) {

//     final accelerometer =
//         _accelerometerValues?.map((double v) => v.toStringAsFixed(4)).toList();
//     final gyroscope =
//         _gyroscopeValues?.map((double v) => v.toStringAsFixed(4)).toList();
//     final userAccelerometer = _userAccelerometerValues
//         ?.map((double v) => v.toStringAsFixed(1))
//         .toList();
//     final magnetometer =
//         _magnetometerValues?.map((double v) => v.toStringAsFixed(4)).toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Prueba de sensores')
//       ),
//       drawer: const MenuWidget(),
//       body: Center(child: Placeholder()),
//     );
//   }
// }