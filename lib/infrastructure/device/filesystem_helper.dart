import 'dart:io';

class FilesHelper {

  static Future<void> deleteFile(String path) {
    
    final file = File(path);
    return file.delete();
      // .then((value) => return  )
      // .onError((error, stackTrace) => print('no se puede eliminar porque no seguramente no existia el archivo') );
  }

}