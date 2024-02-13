import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/presentation/widgets/widgets.dart';

class UploadsMainScreen extends StatelessWidget {

  const UploadsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carga de imagen y coordenadas'),
      ),
      drawer: const MenuWidget(),
      body: const UploadItemsView(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
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
          heroTag: 'precarga',
          child: const Icon(Icons.add),
          onPressed: () { //TODO
            Navigator.pushNamed(context, 'one_shoting'); //TODO
          },
        ),
      ],
    );
  }
}

