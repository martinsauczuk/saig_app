import 'dart:io';

import 'package:flutter/material.dart';
import 'package:saig_app/src/providers/uploads_provider.dart';
import 'package:saig_app/src/widgets/item_list_tile.dart';
import 'package:saig_app/src/widgets/menu_widget.dart';
import 'package:saig_app/src/widgets/upload_button.dart';
import 'package:provider/provider.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  @override
  Widget build(BuildContext context) {
    final UploadsProvider uploadsProvider = context.watch<UploadsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carga de imagen y coordenadas'),
      ),
      drawer: MenuWidget(),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: uploadsProvider.getItems().length,
        itemBuilder: (context, index) {
          final item = uploadsProvider.getItems()[index];
          return ItemListTile(
            item: item, 
            onPress: (){
              uploadsProvider.upload(item);
            }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, 'precarga');
        },
      ),
    );
  }
}
