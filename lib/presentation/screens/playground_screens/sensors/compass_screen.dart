import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/presentation/providers/providers.dart';

class CompassScreen extends ConsumerWidget {
  const CompassScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // final locationGranted = ref.watch( permissionsProvider ).locationGranted;
    final compassHeading$ = ref.watch( compassProvider );


    return Scaffold(
      appBar: AppBar(
        title: const Text('Compass Screen', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData( color: Colors.black),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: compassHeading$.when(
          data: (heading) => Compass(heading: heading ?? 0), 
          error: (error, stackTrace) => Text('$error', style: const TextStyle(color: Colors.white),), 
          loading: () => const CircularProgressIndicator()
        )
      )
    );
  }
}

class Compass extends StatelessWidget {

  final double heading;

  const Compass({ super.key, required this.heading});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('${heading.ceil()}', style: const TextStyle(color:Colors.white, fontSize: 30)),
        const SizedBox(height: 20),
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/compass/quadrant-1.png'),
            Transform.rotate(
              angle: ( heading * (math.pi / 180) * -1),
              child: Image.asset('assets/compass/needle-1.png'),
            )
          ],
        )
      ],
    );
  }
}
