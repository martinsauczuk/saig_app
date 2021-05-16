import 'package:flutter/material.dart';
import 'package:saig_app/src/widgets/menu_widget.dart';

class SettingsPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Contenido de la nube'),
        ),
        drawer: MenuWidget(),
        body: Column(
          children: <Widget>[
            FlutterLogo()
          ],
        ));
  }
    
}