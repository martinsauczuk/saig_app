import 'package:flutter/material.dart';

class ErrorIndicatorWidget extends StatelessWidget {

  final String message;
  const ErrorIndicatorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.green.shade50,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_rounded,
              size: 50.0,
            ),
            Text(message)
          ],
        ),
      ),
    );
  }
}