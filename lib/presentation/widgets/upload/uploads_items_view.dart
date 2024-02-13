import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/presentation/providers/providers.dart';
import 'package:saig_app/presentation/widgets/widgets.dart';


class UploadItemsView extends ConsumerWidget {
  
  const UploadItemsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final items = ref.watch(uploadItemsProvider);
    print('/M Lengh: ${items.length}');
    print('/M Building');

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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
                  ref.read(uploadItemsProvider.notifier).deleteItem(item);
                }, 
                child: UploadItemListTile(
                  item: item,
                  onPress: () {
                    ref.read(uploadItemsProvider.notifier).uploadItem(item);
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