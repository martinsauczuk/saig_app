import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/presentation/providers/providers.dart';

class MagnetometerScreen extends ConsumerWidget {
  const MagnetometerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final magnetometer$ = ref.watch(magnetometerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Magnetometro'),
      ),
      body:          
        Center(
            child: magnetometer$.when(
              data: (value) => Column(children: [
                Text(value.x.toStringAsFixed(2)),
                Text(value.y.toStringAsFixed(2)),
                Text(value.z.toStringAsFixed(2))
              ]),
              error: (error, stackTrace) => Text('$error'), 
              loading: () => const CircularProgressIndicator()
            )
          ),
    );
  }
}