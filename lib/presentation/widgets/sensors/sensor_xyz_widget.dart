import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/domain/domain.dart';
import 'package:saig_app/presentation/widgets/widgets.dart';

class SensorXYZWidget extends StatelessWidget {
  
  final AsyncValue<SensorValue> asyncValue;
  final IconData icon;
  final String caption;


  const SensorXYZWidget({
    required this.asyncValue, 
    required this.icon,
    required this.caption,
    super.key
  });


  @override
  Widget build(BuildContext context) {

    return asyncValue.when(
      data: (data) => (
        ValueXYZWidget(
          value: data,
          icon: icon, 
          caption: caption
        )
      ), 
      error: (error, stackTrace) => Column(
        children: [
          Icon(icon),
          Text(caption),
          const Text('No sensor'),
        ],
      ), 
      loading: () => const CircularProgressIndicator(),
    ); 
  }
}

