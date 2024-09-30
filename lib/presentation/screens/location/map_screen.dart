import 'package:flutter/material.dart';
import 'package:saig_app/presentation/widgets/widgets.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Screen'),
      ),
      drawer: const MenuWidget(),
      body: const Placeholder()
    );
  }
}