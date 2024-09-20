import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:saig_app/domain/domain.dart';
import 'package:saig_app/presentation/widgets/widgets.dart';

class UploadItemPreviewWidget extends StatelessWidget {

  final UploadItem item;
  final VoidCallback? onTapFilePreview;
  final VoidCallback? onPressOk;
  final double height; 
  
  const UploadItemPreviewWidget({
    super.key, 
    required this.item, 
    this.onTapFilePreview, 
    this.onPressOk, 
    required this.height
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY:10),
        child: GestureDetector(
          onTap: onTapFilePreview,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color:Colors.black
              )
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: height,
                  child: Image.file( File(item.path)),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
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
                          onPressed: onPressOk, 
                          label: const Text('Descartar')
                        ),
                      ],
                    )
                    ,
                  ]
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}