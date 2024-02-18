import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/presentation/screens/screens.dart';
import 'package:saig_app/presentation/widgets/widgets.dart';

class UploadsMainScreen extends StatelessWidget {

  const UploadsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contenido'),
      ),
      drawer: const MenuWidget(),
      body: const UploadMainView(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: const _FlotingActionButtons(),
    );
  }

}


class _FlotingActionButtons extends ConsumerWidget {

  const _FlotingActionButtons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'one_shoting',
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, 'one_shoting');
          },
        ),
      ],
    );
  }
}

