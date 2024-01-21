import 'package:flutter/material.dart';
import 'package:saig_app/presentation/menu_widget.dart';

class CloudGalleryScreen extends StatelessWidget {
  const CloudGalleryScreen
({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contenido de la nube'),
      ),
      drawer: const MenuWidget(),
      body: FutureBuilder(
        future: Future<String>.delayed(
          const Duration(seconds: 2),
          () => 'Hola Mundo'
        ), 
        builder: (context, snapshot) => snapshot.hasData ? Text(snapshot.data!) : const Placeholder()
      ),
    );
  }
}