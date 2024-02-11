import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/domain/entities/upload_item.dart';
import 'package:saig_app/presentation/menu_widget.dart';
import 'package:saig_app/presentation/providers/providers.dart';
import 'package:saig_app/presentation/widgets/upload_item_list_tile.dart';

class UploadsMainScreen extends StatelessWidget {

  const UploadsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // final UploadsProvider provider = context.watch<UploadsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carga de imagen y coordenadas'),
      ),
      drawer: const MenuWidget(),
      body: const _UploadItemsView(),

      // body: FutureBuilder<List<UploadItem>>(
      //   future: provider.getVisibles(),
      //   builder: (BuildContext context,
      //       AsyncSnapshot<List<UploadItem>> snapshot) {
          
      //     if (snapshot.hasData) {

      //       final items = snapshot.data;

      //       if (items!.isEmpty) {
      //         return const Center(
      //           child: Text('No hay elementos'),
      //         );
      //       }

      //       return ListView.separated(
      //         separatorBuilder: (context, index) => const Divider(),
      //         itemCount: items.length,
      //         itemBuilder: (context, index) {
      //           final item = items[index];
      //           return Dismissible(
      //             key: UniqueKey(),
      //             background: const _ItemBackground(),
      //             direction: DismissDirection.startToEnd,
      //             onDismissed: (DismissDirection direction) => onDismissed(context, item), 
      //             child: UploadItemListTile(
      //               item: item,
      //               onPress: () => onPressUploadButton(context, item),
      //             )
      //           );
      //         },
      //       );
      //     }

      //     if (snapshot.hasError) {
      //       return Center(
      //         child: Text(snapshot.error.toString()),
      //       );
      //     }

      //     return const Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   },
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: const _FlotingActionButtons(),
    );
  }

}

class _UploadItemsView extends ConsumerWidget {
  
  const _UploadItemsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final items = ref.watch(uploadItemsProvider);

    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Dismissible(
          key: UniqueKey(),
          background: const _ItemBackground(),
          direction: DismissDirection.startToEnd,
          onDismissed: (DismissDirection direction) => onDismissed(context, item), 
          child: UploadItemListTile(
            item: item,
            onPress: () => onPressUploadButton(context, item),
          )
        );
      },
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


///
///
///
void onPressUploadButton(BuildContext context,  UploadItem item) {
  
  // final UploadsProvider provider = context.read<UploadsProvider>();
  // provider.uploadItem(item);

}


///
///
///
void onDismissed(BuildContext context, UploadItem item) {

  // final UploadsProvider provider = context.read<UploadsProvider>();


  // provider.deleteItem(item)
    // .then( (onValue) { 
        // ScaffoldMessenger.of(context)
          // .showSnackBar(SnackBar(
            // content: Text('${item.id} - ${item.descripcion} eliminado')
          // )
        // );
      // });

}

class _FlotingActionButtons extends StatelessWidget {

  const _FlotingActionButtons();

  @override
  Widget build(BuildContext context) {
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
        // FloatingActionButton(
        //   heroTag: 'multi',
        //   child: const Icon(Icons.add_to_photos_sharp),
        //   onPressed: () {
        //     Navigator.pushNamed(context, 'multi');
        //   }
        // ),
        // FloatingActionButton(
        //   heroTag: 'routing',
        //   child: const Icon(Icons.route_rounded),
        //   onPressed: () {
        //     Navigator.pushNamed(context, 'routing');
        //   }
        // )
      ],
    );
  }
}

// 
// Future<Position> getPosition() async {
//   Future<Position> position =
//       Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high); // TODO
//   return position;
// }
