import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/presentation/providers/providers.dart';

class GyroscopeBallScreen extends ConsumerWidget {
  const GyroscopeBallScreen({super.key});


  @override
  Widget build(BuildContext context, ref) {

    final gyroscope$ = ref.watch(gysroscopeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gyroscope Ball Screen'),
      ),
      body: SizedBox.expand(
        child: gyroscope$.when(
          data: (data) => MovingBall(x: data.x, y: data.y), 
          error: (error, stackTrace) => Text('$error'), 
          loading: () => const CircularProgressIndicator(),
        ),
      )
    );
  }
}


class MovingBall extends StatelessWidget {

  final double x;
  final double y;


  const MovingBall({super.key, required this.x, required this.y});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double screenHeight = size.height;

    double currentXPox = ( x * 100 );
    double currentYPox = ( y * 100);


    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedPositioned(
          left: (currentYPox - 25) + (screenWidth / 2),
          top: (currentXPox - 25) + (screenHeight / 2),
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 100),
          child: const Ball(), 
        ),
        Text(
          'x: ${x.toStringAsFixed(2)} y: ${y.toStringAsFixed(2)} ',
          style: const TextStyle( fontSize: 30),
        ),
      ],
    );
  }
}

class Ball extends StatelessWidget {
  const Ball({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(100)
      ),
    );
  }
}