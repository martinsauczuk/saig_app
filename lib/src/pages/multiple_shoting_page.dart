import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class MultipleShotingPage extends StatefulWidget {
  const MultipleShotingPage({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<MultipleShotingPage> createState() => _MultipleShotingPageState();
}

class _MultipleShotingPageState extends State<MultipleShotingPage> {
  int count = 1;
  late Timer timer1;

  @override
  void initState() {
    super.initState();
    starTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer1.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Múltiple fotos'),
      ),
      body: Center(
        child: Text(count.toString()),
      ),
    );
  }

  starTimer() {
    timer1 = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      // print(timer.tick);
      setState(() {
        count++;
        print('<<< count $count >>>');
      });
    });

    // Timer.periodic(Duration(milliseconds: 1500), increment);
  }

  increment(Timer timer) {
    print('holaMundo callback ${timer.tick}');
  }
}
