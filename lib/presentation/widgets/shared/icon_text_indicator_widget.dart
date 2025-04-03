import 'package:flutter/material.dart';

class IconTextIndicatorWidget extends StatelessWidget {
  const IconTextIndicatorWidget({
    super.key, 
    required this.icon, 
    required this.caption,
  });

  final IconData icon;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100,
        border: Border.all(
          width: 2.0,
          color: Colors.teal
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 30,),
          Text(caption, style: TextStyle(fontSize: 20),)
        ],
      ),  
    );
  }
}