import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saig_app/domain/datasources/uploads_local_datadource.dart';
import 'package:saig_app/domain/entities/upload_item.dart';
import 'package:saig_app/domain/enums/upload_status.dart';
import 'package:sqflite/sqflite.dart';

class UploadsLocalSqliteDatasource implements UploadsLocalDatasource {

  static Database? _database;
  static final UploadsLocalSqliteDatasource db = UploadsLocalSqliteDatasource._();

  UploadsLocalSqliteDatasource._();

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
      version: 6,
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
            magnetometerX REAL,
            magnetometerY REAL,
            magnetometerZ REAL,
            accuracy REAL,
            heading REAL,
            altitude REAL,
            speed REAL,
            speedAccuracy REAL,
            timestamp TEXT,
            public_id TEXT)
        ''');
      },
    );
  }

  @override
  Future<int> deleteItemById(int id) {
    // TODO: implement deleteItemById
    throw UnimplementedError();
  }

  @override
  Future<List<UploadItem>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<UploadItem>> getVisibles() async {
    
    int index = UploadStatus.archived.index;
    final db = await database;
    final res = await db!.query(
      'Items', 
      where: 'status != $index',
      orderBy: 'id desc'
    );

    List<UploadItem> list = res.isNotEmpty
        ? res.map((e) => UploadItem.fromMap(e)).toList()
        : [];

    return list;
  }


  @override
  Future<int> insertItem(UploadItem newItem) async{
    
    final db = await database;

    final id = await db!.insert('Items', newItem.toMap());
    return id;
  }

  @override
  Future<int> updateItem(UploadItem itemToUpdate) {
    // TODO: implement updateItem
    throw UnimplementedError();
  }

}