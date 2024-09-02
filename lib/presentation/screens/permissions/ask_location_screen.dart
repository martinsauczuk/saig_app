import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/presentation/providers/permissions/permissions_provider.dart';

class AskPermissionScreen extends ConsumerWidget {
  
  const AskPermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permiso requerido'),
      ),
      body: Center(
        child: FilledButton(
          child: const Text('Localizacion necesaris'),
          onPressed: () {
            // ref.read(permissionsProvider.notifier).req
          },
        ),
      ),
    );
  }
}