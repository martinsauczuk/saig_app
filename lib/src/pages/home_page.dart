import 'package:flutter/material.dart';
import 'package:saig_app/src/widgets/menu_widget.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Subida de imagenes'),
      ),
      drawer: MenuWidget(),
      body: Container(
        child: Center(
          child: Text('subiendo'),
        ),
      ),
    );
    
  }
}