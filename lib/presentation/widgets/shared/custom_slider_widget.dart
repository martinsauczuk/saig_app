import 'package:flutter/material.dart';

class CustomSliderWidget extends StatelessWidget {
  const CustomSliderWidget({
    super.key, 
    required this.currentValue, 
    required this.onChanged,
    this.enabled = true, 
    this.unitLabel = '',
    this.minValue = 0,
    this.maxValue = 10,
    this.divisions = 10
  });

  final double currentValue;
  final void Function(double) onChanged;
  final bool enabled;
  final String unitLabel;
  final double minValue;
  final double maxValue;
  final int divisions;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$currentValue$unitLabel'),
        Expanded(
          child: Slider(
            value: currentValue,
            min: minValue,
            max: maxValue,
            divisions: divisions,
            label: currentValue.toString(),
            onChanged: enabled ? onChanged : null,
          ),
        ),
      ],
    );
  }
}