import 'package:flutter/material.dart';
import 'package:saig_app/domain/domain.dart';

class ValueXYZWidget extends StatelessWidget {

  const ValueXYZWidget({
    super.key,
    required this.icon,
    required this.caption,
    required this.value
  });

  final SensorValue value;
  final IconData icon;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon),
        Text(caption),
        Text('x: ${value.x.toStringAsFixed(2)}'),
        Text('y: ${value.y.toStringAsFixed(2)}'),
        Text('z: ${value.z.toStringAsFixed(2)}'),
      ],
    );
  }
}