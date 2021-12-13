import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// Pagina para ver como quedo la imagen 
/// sin implementar por el momento
/// aca puede llegar a ir el formulario
///
class PreviewItem extends StatelessWidget {
  final String imagePath;

  const PreviewItem({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Imagen capturada')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}