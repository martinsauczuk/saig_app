import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saig_app/domain/entities/upload_item.dart';
import 'package:saig_app/presentation/menu_widget.dart';
import 'package:saig_app/presentation/providers/uploads_provider.dart';
import 'package:saig_app/presentation/widgets/upload_item_list_tile.dart';

class UploadsMainScreen extends StatelessWidget {


  // final UploadsLocalRepository repository = UploadsLocalRepositoryImpl( datasource: UploadsLocalMemoryDatasource() );

  const UploadsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {

    print('>>>>>>>>>>building......');

    final UploadsProvider provider = context.watch<UploadsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carga de imagen y coordenadas'),
      ),
      drawer: const MenuWidget(),
      body: FutureBuilder<List<UploadItem>>(
        future: provider.getVisibles(),
        builder: (BuildContext context,
            AsyncSnapshot<List<UploadItem>> snapshot) {
          
          if (snapshot.hasData) {

            final items = snapshot.data;

            if (items!.isEmpty) {
              return const Center(
                child: Text('No hay elementos'),
              );
            }

            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Dismissible(
                  key: UniqueKey(),
                    background: Container(
                      color: Colors.red,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: const Row(
                          children: <Widget>[
                            Icon( Icons.delete_forever ),
                          ],
                        ),
                      ),
                    ),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (DismissDirection direction) => { // TODO
                      provider.deleteItem(item),
                      // ScaffoldMessenger.of(context)
                      //   .showSnackBar(SnackBar(
                      //     content: Text('${item.id} - ${item.descripcion} eliminado')
                      //   ))
                    }, 
                  child: UploadItemListTile(
                    item: item,
                    onPress: () {
                      onPressUploadButton(item);
                    },
                  )
                );
              },
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: const _FlotingActionButtons(),
    );
  }

  void onPressUploadButton(UploadItem item) {
    
    print('uploading...$item');
  }

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
            // context.read<UploadsProvider>().newMockItem();
            // await getPosition().then((value) => print( value ));
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
