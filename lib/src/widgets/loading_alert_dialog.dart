import 'package:flutter/material.dart';

///
/// Alert de subiendo imagen
///
class LoadingAlertDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AlertDialog (
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Cargando'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget> [
          Text('Subiendo imagen a la nube, este proceso puede tardar varios minutos dependiendo de su conexión.'),
          Divider(),
          LinearProgressIndicator()
        ]
      ),
    );
  }
}