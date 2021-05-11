import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Subida de imagenes'),
      ),
      body: Container(
        child: Center(
          child: Text('subiendo'),
        ),
      ),
    );
    
  }
}