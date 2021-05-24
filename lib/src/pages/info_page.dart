import 'package:flutter/material.dart';
import 'package:saig_app/src/widgets/menu_widget.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información'),
      ),
      drawer: MenuWidget(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Esta aplicación forma parte del plan de trabajo dentro del convenio de Investigación y desarrollo entre la Universidad Nacional de Quilmes y la Facultad de Agronomía de la Universidad de Buenos Aires'),
          Divider(),
          Image(image: AssetImage('assets/unq-logo.png')),
          Image(image: AssetImage('assets/fauba-logo.png')),
          Divider(),
          Text('Desarrollada por Martin Sauczuk', style: Theme.of(context).textTheme.subtitle1 ),
          Text('martin.sauczuk@gmail.com', style: Theme.of(context).textTheme.subtitle2 ),
          Text('v1.1.0', style: Theme.of(context).textTheme.button),
        ]
      )
    );
  }
}