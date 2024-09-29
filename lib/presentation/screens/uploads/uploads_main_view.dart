import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/presentation/providers/providers.dart';
import 'package:saig_app/presentation/widgets/widgets.dart';


class UploadMainView extends ConsumerWidget {
  
  const UploadMainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final items = ref.watch(filteredItemsProvider);
    final currentFilter = ref.watch(uploadsFilterProvider);

    final pendingCount = ref.watch(uploadsPendingCountProvider);
    final completedCount = ref.watch(uploadsCompletedCountProvider);
    final errorCount = ref.watch(uploadsErrorCountProvider);


    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SegmentedButton(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: UploadsFilter.pending,
              label: Text('Pendientes ($pendingCount)'), 
              icon: const Icon(Icons.upload),
            ),
            ButtonSegment(
              value: UploadsFilter.completed,
              label: Text('Completos ($completedCount)'),  
              icon: const Icon(Icons.check)
            ),
            ButtonSegment(
              value: UploadsFilter.error, 
              label: Text('Error ($errorCount)'),
              icon: const Icon(Icons.warning)
            ),
          ], 
          selected: <UploadsFilter>{ currentFilter },
          onSelectionChanged: (value) {
            ref.read( uploadsFilterProvider.notifier).update((state) => value.first );
          },
        ),
        const SizedBox(
          height: 10
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Dismissible(
                key: UniqueKey(),
                background: const _ItemBackground(),
                direction: DismissDirection.startToEnd,
                onDismissed: (DismissDirection direction) {
                  ref.read(uploadGalleryProvider.notifier).deleteItem(item);
                }, 
                child: UploadItemListTile(
                  item: item,
                  onPress: () {
                    ref.read(uploadGalleryProvider.notifier).uploadItem(item);
                  },
                )
              );
            },
          ),
        ),
      ]
    );
  }
}

class _ItemBackground extends StatelessWidget {
  
  const _ItemBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: const Row(
          children: <Widget>[
            Icon( Icons.delete_forever ),
          ],
        ),
      ),
    );
  }
}