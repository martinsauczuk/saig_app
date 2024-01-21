import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:saig_app/presentation/menu_widget.dart';

class SoundPlaygroundScreen extends StatefulWidget {

  const SoundPlaygroundScreen({super.key});


  @override
  State<SoundPlaygroundScreen> createState() => _SoundPlaygroundScreenState();

}

class _SoundPlaygroundScreenState extends State<SoundPlaygroundScreen> {
  final playerBeep = AudioPlayer();
  final playerCamera = AudioPlayer();

  double _currentSliderValue = 500;
  bool _enable = false;

  @override
  void initState() {
    super.initState();

    // player.setReleaseMode(ReleaseMode.loop);

    playerBeep.onPlayerStateChanged.listen((PlayerState s) {
      // print('Current player state: $s');
      // setState(() => playerState = s);
      // onComplete();
    });

    playerBeep.onPlayerComplete.listen((event) {
      onComplete();
    });
  }

  void onComplete() {
    if (_enable) {
      final future = Future.delayed(Duration(milliseconds: _currentSliderValue.toInt()));
      future.then((_) {
        // print('play again');
        playerBeep.play(AssetSource('beep.wav'));
      });
    } else {
      // print('no play');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Prueba de sonidos')),
        drawer: const MenuWidget(),
        body: Center(
          child: Column(
            children: [
              IconButton(
                iconSize: 100,
                onPressed: () {
                  // print('play sound');
                  _enable = true;
                  playerBeep.play(
                    AssetSource('beep.wav'),
                  );
                },
                icon: const Icon(Icons.play_circle_fill)),
              IconButton(
                iconSize: 100,
                onPressed: () {
                  setState(() {
                    _enable = false;
                  });
                  // print('stop sound');
                  // await player.stop();
                },
                icon: const Icon(Icons.stop)),
              IconButton(
                iconSize: 100,
                onPressed: ()  {
                  playerCamera.play(
                    AssetSource('camera.wav'),
                  );
                },
                icon: const Icon(Icons.speaker)),
              Slider(
                value: _currentSliderValue,
                min: 0,
                max: 1000,
                divisions: 100,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                    print(value);
                  });
                },
              ),
              Text(_currentSliderValue.toString())
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    playerBeep.dispose();
    playerCamera.dispose();
  }
}
