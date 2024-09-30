import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/presentation/providers/providers.dart';
import 'package:saig_app/presentation/widgets/widgets.dart';

class LocationScreen extends ConsumerWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final positionValueAsync = ref.watch( positionValueProvider );


    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Screen'),
      ),
      drawer: const MenuWidget(),
      body: Center(
        child: Column(
          children: [
            const Text('Ubicacion actual', style: TextStyle(fontSize: 20)),
            SizedBox(height: 30),
            PositionValueWidget(
              positionAsyncValue: positionValueAsync,
            )
          ],
        ),
      )
    );
  }
}