import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/presentation/providers/providers.dart';
import 'package:saig_app/presentation/widgets/widgets.dart';

class SensorsConsumerWidget extends ConsumerWidget {
  
  const SensorsConsumerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final gyroscope$ = ref.watch(gyroscopeProvider);
    final acceleromenterGravity$ = ref.watch(accelerometerGravityProvider);
    final acceleromenterUser$ = ref.watch(accelerometerUserProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SensorXYZWidget(
          asyncValue: gyroscope$,
          caption: 'Gyroscope', 
          icon: Icons.threesixty
        ),
        SensorXYZWidget(
          asyncValue: acceleromenterGravity$,
          caption: 'Accelerometer',
          icon: Icons.speed, 
        ),
        SensorXYZWidget(
          asyncValue: acceleromenterUser$,
          caption: 'User accelerometer',
          icon: Icons.person,
        )
      ],
    );
  }
}