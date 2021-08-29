import 'package:flutter/material.dart';
import 'package:saig_app/src/enums/upload_status.dart';
import 'package:saig_app/src/models/upload_item_model.dart';
import 'package:saig_app/src/providers/uploads_provider.dart';
import 'package:saig_app/src/widgets/item_list_tile.dart';
import 'package:saig_app/src/widgets/menu_widget.dart';
import 'package:provider/provider.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  @override
  Widget build(BuildContext context) {
    final UploadsProvider uploadsProvider = context.watch<UploadsProvider>();
    // uploadsProvider.init();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carga de imagen y coordenadas'),
      ),
      drawer: MenuWidget(),
      body: FutureBuilder<List<UploadItemModel>?>(
        future: uploadsProvider.getItems(),
        // initialData: [],
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
                return ItemListTile(
                    item: item,
                    onPress: () {
                      uploadsProvider.upload(item);
                    });
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, 'precarga');
        },
      ),
    );
  }
}
