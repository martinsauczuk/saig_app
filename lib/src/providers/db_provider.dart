import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saig_app/src/enums/upload_status.dart';
import 'package:saig_app/src/models/upload_item_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  ///
  ///
  ///
  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'PlantAr.db');

    print('Path a DB: $path');

    return await openDatabase(
      path,
      version: 3,
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
            accelerometerX REAL,
            accelerometerY REAL,
            accelerometerZ REAL,
            magenetometerX REAL,
            magenetometerY REAL,
            magenetometerZ REAL,
            public_id TEXT)
        ''');
      },
    );
  }

  ///
  ///
  ///
  Future<int> insertItem(UploadItemModel nuevoItem) async {

    print(nuevoItem);

    final db = await database;

    final id = await db!.insert('Items', nuevoItem.toMap());
    return id;
  }

  ///
  /// Obtener todos
  ///
  Future<List<UploadItemModel>> getAll() async {
    final db = await database;
    final res = await db!.query('Items', orderBy: 'id desc');

    List<UploadItemModel> list = res.isNotEmpty
        ? res.map((e) => UploadItemModel.fromMap(e)).toList()
        : [];

    return list;
  }

  // ///
  // /// Update
  // ///
  updateItem(UploadItemModel item) async {
    final db = await database;
    final res = await db!
        .update('Items', item.toMap(), where: 'id = ?', whereArgs: [item.id]);

    return res;
  }


  ///
  /// Obtener todos lo que no son archived
  ///
  Future<List<UploadItemModel>> getVisibles() async {
    int index = UploadStatus.archived.index;
    final db = await database;
    final res = await db!.query(
      'Items', 
      where: 'status != $index',
      orderBy: 'id desc'
    );

    List<UploadItemModel> list = res.isNotEmpty
        ? res.map((e) => UploadItemModel.fromMap(e)).toList()
        : [];

    return list;
  }
  
}
