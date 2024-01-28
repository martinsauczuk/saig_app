import 'package:flutter/material.dart';

class OneShotingScreen extends StatelessWidget {

  const OneShotingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Pre carga de imagen'),
      ),
      body: Center(
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                print('onPressed');
              },
              iconSize: 50.0,
              icon: const Icon(Icons.account_tree_sharp)
            )
          ],
        ),
      )
    );
  }
  
}