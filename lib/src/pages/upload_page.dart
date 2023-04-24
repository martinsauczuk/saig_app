import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:saig_app/src/models/upload_item_model.dart';
import 'package:saig_app/src/providers/uploads_provider.dart';
import 'package:saig_app/src/widgets/item_list_tile.dart';
import 'package:saig_app/src/widgets/menu_widget.dart';
import 'package:provider/provider.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

Future<Position> getPosition() async {
  Future<Position> position =
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  return position;
}


class _UploadPageState extends State<UploadPage> {

  // @override
  // void initState() {
  //   super.initState();
  //   Future<Position> position = Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  // }

  @override
  Widget build(BuildContext context) {
    final UploadsProvider uploadsProvider = context.watch<UploadsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carga de imagen y coordenadas'),
      ),
      drawer: MenuWidget(),
      body: FutureBuilder<List<UploadItemModel>?>(
        future: uploadsProvider.getVisibles(),
        builder: (BuildContext context,
            AsyncSnapshot<List<UploadItemModel>?> snapshot) {
          if (snapshot.hasData) {
            final items = snapshot.data;

            if (items!.isEmpty) {
              return Center(
                child: Text('No hay elementos'),
              );
            }

            return ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Dismissible(
                  key: Key(item.id.toString()), 
                  child: ItemListTile(
                    item: item,
                    onPress: () {
                      uploadsProvider.upload(item);
                    }),
                    background: Container(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: <Widget>[
                            Icon( Icons.delete_forever ),
                          ],
                        ),
                      ),
                      color: Colors.red,
                    ),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (DismissDirection direction) => {
                      uploadsProvider.deleteItem(item),
                      ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                          content: Text('${item.id} - ${item.descripcion} eliminado')
                        ))
                    },
                );
              },
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'precarga',
            child: Icon(Icons.add),
            onPressed: () async {
              await getPosition().then((value) => print( value ));
              Navigator.pushNamed(context, 'precarga');
            },
          ),
          FloatingActionButton(
            heroTag: 'multi',
            child: Icon(Icons.add_to_photos_sharp),
            onPressed: () {
              Navigator.pushNamed(context, 'multi');
            }
          ),
          FloatingActionButton(
            heroTag: 'routing',
            child: Icon(Icons.route_rounded),
            onPressed: () {
              Navigator.pushNamed(context, 'routing');
            }
          )
        ],
      ),
    );
  }
}
