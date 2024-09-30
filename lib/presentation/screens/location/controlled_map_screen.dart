import 'package:flutter/material.dart';
import 'package:saig_app/presentation/widgets/widgets.dart';

class ControlledMapScreen extends StatelessWidget {
  const ControlledMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controlled Screen'),
      ),
      drawer: const MenuWidget(),
      body: const Placeholder()
    );
  }
}