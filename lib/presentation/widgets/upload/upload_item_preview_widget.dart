import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:saig_app/domain/domain.dart';
import 'package:saig_app/presentation/widgets/widgets.dart';

class UploadItemPreviewWidget extends StatelessWidget {

  final UploadItem item;
  final VoidCallback? onPressDiscard;
  final VoidCallback? onPressOk;
  final double height; 
  final double width;
  
  const UploadItemPreviewWidget({
    super.key, 
    required this.item, 
    this.onPressDiscard, 
    this.onPressOk, 
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {

    final colorSchema = Theme.of(context).colorScheme;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY:10),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colorSchema.inversePrimary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 2
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Image.file( File(item.path))
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ValueXYZWidget(
                  icon: Icons.threesixty, 
                  caption: 'Gyroscope', 
                  value: item.accelerometer!
                ),
                ValueXYZWidget(
                  icon: Icons.speed, 
                  caption: 'Accelerometer', 
                  value: item.accelerometer!
                ),
                ValueXYZWidget(
                  icon: Icons.person, 
                  caption: 'User accelerometer', 
                  value: item.accelerometer!
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon( 
                  icon: const Icon(Icons.save), 
                  onPressed: onPressOk, 
                  label: const Text('Guardar')
                ),
                ElevatedButton.icon( 
                  icon: const Icon(Icons.delete), 
                  onPressed: onPressDiscard, 
                  label: const Text('Descartar')
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }
}