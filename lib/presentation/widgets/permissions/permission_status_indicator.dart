import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionStatusIndicator extends StatelessWidget {
  
  final PermissionStatus status;

  const PermissionStatusIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {

    final colorSchema = Theme.of(context).colorScheme;

    switch (status) {
      case PermissionStatus.denied: 
        return Icon(Icons.block, color: colorSchema.error );
      case PermissionStatus.granted: 
        return Icon(Icons.check_circle, color: colorSchema.primary );
      default:
        return Icon(Icons.help, color: colorSchema.primary );
    }
  }
}