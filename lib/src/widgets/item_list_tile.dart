import 'dart:io';

import 'package:flutter/material.dart';
import 'package:saig_app/src/enums/upload_status.dart';
import 'package:saig_app/src/models/upload_item_model.dart';
import 'package:saig_app/src/widgets/upload_button.dart';

class ItemListTile extends StatelessWidget {
  
  final UploadItemModel item;
  final VoidCallback onPress;

  ItemListTile({
    required this.item,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    
    return ListTile(
      leading: Image.file(
        File(item.pickedFile!.path),
        fit: BoxFit.cover,
        // height: 20.0,
      ),
      title: Text(item.descripcion),
      subtitle: _buildSubtitle(),
      isThreeLine: true,
      trailing: SizedBox(
        width: 96.0,
        child: UploadButton(
          uploadStatus: item.status,
          onPending: onPress,
        ),
      ),
    );

  }

  Widget _buildSubtitle() {

    switch (item.status) {
      case UploadStatus.pending:
        return Text('Subida pendiente');
      case UploadStatus.uploading:
        return Text('Subiendo a la nube...');
      case UploadStatus.error:
        return Text('Error al subir');
      case UploadStatus.done:
        return Text('${item.publicId}');
    }

  }


}
