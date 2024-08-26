import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/presentation/providers/providers.dart';

class GyroscopeScreen extends ConsumerWidget {
  const GyroscopeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {

    final gyroscope$ = ref.watch(gysroscopeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giroscopio'),
      ),
      body: Center(
        child: gyroscope$.when(
          data: (value) => Column(
            children: [
              Text(value.x.toString()),
              Text(value.y.toString()),
              Text(value.z.toString())
            ]
          ), 
          error: (error, stackTrace) => Text('$error'), 
          loading: () => const CircularProgressIndicator()
        )
      ),
    );
  }
}