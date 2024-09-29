import 'package:path/path.dart';
import 'package:saig_app/config/sqlite/sqlite_config.dart';
import 'package:saig_app/domain/datasources/uploads_local_datasource.dart';
import 'package:saig_app/domain/entities/upload_item.dart';
import 'package:saig_app/domain/enums/upload_status.dart';
import 'package:sqflite/sqflite.dart';

class UploadsLocalSqliteDatasource implements UploadsLocalDatasource {

  static final UploadsLocalSqliteDatasource instance = UploadsLocalSqliteDatasource._init();
  static Database? _database;

  UploadsLocalSqliteDatasource._init();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDB( SqliteConfig.databaseName );
    return _database;
  }

  ///
  ///
  ///
  Future<Database> _initDB(String dbName ) async {

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    print('Path a DB: $path');

    return await openDatabase(
      path,
      version: SqliteConfig.databaseVersion,
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
  Future<int> deleteItemById(int id) async {
    
    final db = await database;
    final res = await db!
        .delete('Items',
          where: 'id = ?',
          whereArgs: [id]
        );
    return res;

  }

  @override
  Future<List<UploadItem>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<UploadItem>> getVisibles() async {
    
    // TODO: Esto es regla de negocio no debe ir en el datasource
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
  Future<int> updateItem(UploadItem itemToUpdate) async {
    final db = await database;
    final res = await db!
        .update('Items', itemToUpdate.toMap(), where: 'id = ?', whereArgs: [itemToUpdate.id]);

    return res;
  }

}