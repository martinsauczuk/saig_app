import 'dart:io';
import 'package:flutter/material.dart';
import 'package:saig_app/domain/domain.dart';
import 'package:saig_app/presentation/widgets/widgets.dart';


class UploadItemListTile extends StatelessWidget {
  
  final UploadItem item;
  final VoidCallback onPress;

  const UploadItemListTile({
    super.key, 
    required this.item,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    
    return ListTile(
      leading: Image.file(
        File(item.path),
        fit: BoxFit.cover,
      ),
      title: Text('${item.id.toString()} - ${item.descripcion!}'),
      subtitle: Column(
        children: [
          Text('data'),
          _buildSubtitle(),
        ],
      ),
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
        return const Text('Subida pendiente');
      case UploadStatus.uploading:
        return const Text('Subiendo a la nube...');
      case UploadStatus.error:
        return const Text('Error al subir - puede reintentar', style: TextStyle(color: Colors.red),);
      case UploadStatus.done:
        return Text('${item.publicId}');
      case UploadStatus.archived:
        return const Text('Subido ok / eliminar de esta lista');
    }
  }


}
