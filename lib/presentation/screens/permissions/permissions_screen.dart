import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/presentation/widgets/widgets.dart';
import 'package:saig_app/presentation/providers/providers.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permisos de la app'),
      ),
      drawer: const MenuWidget(),
      body: _PermissionsView(),
    );
  }
}

class _PermissionsView extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final permissions = ref.watch(permissionsProvider);

    return ListView(
          children: [
            ListTile(
              title: const Text('Camera'),
              subtitle: Text('$permissions.camera'),
              trailing: PermissionStatusIndicator(
                status: permissions.camera
              ),
              onTap: () => ref.read(permissionsProvider.notifier).requestLocationCamera(),
            ),
            ListTile(
              title: const Text('Location'),
              subtitle: Text('${permissions.location}'),
              trailing: PermissionStatusIndicator(
                status: permissions.location
              ),
              onTap: () => ref.read(permissionsProvider.notifier).requestLocationAccess(),
            ),
            ListTile(
              title: const Text('Location always'),
              subtitle: Text('${permissions.locationAlways}'),
              trailing: PermissionStatusIndicator(
                status: permissions.locationAlways
              ),
              onTap: () => ref.read(permissionsProvider.notifier).requestLocationAlwaysAccess(),
            ),
            ListTile(
              title: const Text('Location when is in use'),
              subtitle: Text('${permissions.locationWhenInUse}'),
              trailing: PermissionStatusIndicator(
                status: permissions.locationWhenInUse
              ),
              onTap: () => ref.read(permissionsProvider.notifier).requestLocationWhenInUseAccess(),

        ),
      ],
    );

  }


}