import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saig_app/src/models/upload_item_model.dart';
import 'package:sqflite/sqflite.dart';


class DBProvider {

  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {

    if( _database != null ) return _database;
    _database = await initDB();
    return _database;

  }


  ///
  ///
  ///
  Future<Database> initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join( documentsDirectory.path, 'ScansDB.db' );

    print('Path a DB: $path' );

    return await openDatabase(
      path,
      version: 5,
      onOpen: (db) {
        //  
      },
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Items (
            id INTEGER PRIMARY KEY,
            status INTEGER,
            descripcion TEXT,
            path TEXT,
            lat REAL,
            lng REAL,
            public_id TEXT)
        ''');
      },
    );

  }

  ///
  ///
  ///
  Future<int> insertItem( UploadItemModel nuevoItem ) async {

    nuevoItem.path = nuevoItem.pickedFile!.path;

    print(nuevoItem);

    final db = await database;

    final id = await db!.insert('Items', nuevoItem.toMap() );
    return id;
  }

  // nuevoScan( ScanModel nuevoScan ) async {

  //   final db = await database;
  //   final res = await db.insert('Scans', nuevoScan.toJson() );
  //   return res;

  // }

  // Future<ScanModel> getScanId( int id) async {
    
  //   final db = await database;
  //   final res = await db.query('Scans', where: 'id = ?', whereArgs: [id] );
  //   return res.isNotEmpty ? ScanModel.fromJson( res.first ) : null;

  // }

  ///
  /// Obtener todos
  ///
  Future<List<UploadItemModel>> getAll() async{

    final db = await database;
    final res = await db!.query('Items');

    List<UploadItemModel> list = res.isNotEmpty 
        ? res.map((e) => UploadItemModel.fromMap(e)).toList()
        : [];

    return list;

  }

  // ///
  // /// Buscar por tipo
  // ///
  // Future<List<ScanModel>> getByTipo(String tipo) async{

  //   final db = await database;
  //   final res = await db.rawQuery('''
  //     SELECT * FROM Scans WHERE tipo='$tipo'
  //   ''');

  //   List<ScanModel> list = res.isNotEmpty 
  //       ? res.map((e) => ScanModel.fromJson(e)).toList()
  //       : [];

  //   return list;
    
  // }

  // ///
  // /// Update
  // ///
  updateItem( UploadItemModel item ) async {

    final db = await database;
    final res = await db!.update('Items', item.toMap(), where: 'id = ?', whereArgs: [item.id] );

    return res;

  }

  // ///
  // /// Eliminar
  // ///
  // Future<int> deleteScan( int id ) async {
    
  //   final db = await database;
  //   final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id] );
  //   return res;

  // }


  // ///
  // /// Delete all
  // ///
  // Future<int> deleteAll( ) async {
    
  //   final db = await database;
  //   final res = await db.rawDelete('DELETE FROM Scans');
  //   return res;
    
  // }


}