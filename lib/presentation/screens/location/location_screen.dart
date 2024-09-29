import 'package:flutter/material.dart';
import 'package:saig_app/presentation/widgets/widgets.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Screen'),
      ),
      drawer: const MenuWidget(),
      body: const Placeholder()
    );
  }
}