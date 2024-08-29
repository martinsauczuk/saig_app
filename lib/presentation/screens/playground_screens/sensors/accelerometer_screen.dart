import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/presentation/providers/providers.dart';

class AccelerometerScreen extends ConsumerWidget {
  const AccelerometerScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final accelerometerGravity$ = ref.watch(accelerometerGravityProvider);
    final accelerometerUser$ = ref.watch(accelerometerUserProvider);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Accelerometer'),
      ),
      body: Column(
        children: [
          const Text('Gravity'),
          Center(
            child: accelerometerGravity$.when(
              data: (value) => Column(children: [
                Text(value.x.toString()),
                Text(value.y.toString()),
                Text(value.z.toString())
              ]),
              error: (error, stackTrace) => Text('$error'), 
              loading: () => const CircularProgressIndicator()
            )
          ),
          const Text('User'),
          Center(
            child: accelerometerUser$.when(
              data: (value) => Column(children: [
                Text(value.x.toString()),
                Text(value.y.toString()),
                Text(value.z.toString())
              ]),
              error: (error, stackTrace) => Text('$error'), 
              loading: () => const CircularProgressIndicator()
            )
          ),
        ],
      ),
    );
  }
}