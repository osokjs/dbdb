// ignore_for_file: use_rethrow_when_possible

// import 'dart:io';
import 'dart:developer';

// import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:dbdb/model/favorite_data.dart';
import 'package:dbdb/model/group_data.dart';

class DatabaseHelper {
  static const _databaseName = "gobal.db";
  static const _databaseVersion = 1;

  // table names
  static const _groupTable = "groupCode";
  static const _favoritesTable = "favorites";
  static const _routeCodeTable = "routeCode";
  static const _routesTable = "routes";


  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  // factory DatabaseHelper() => _db;
  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  // Future<Database> get database async {
  //   // _database ??= await _initDatabase();
  //
  //   if (_database != null) return _database;
  //     _database = await _initDatabase();
  //   return _database;
  // }

  Future<Database> _initDatabase() async {
    // Directory directory = await getApplicationDocumentsDirectory();
    final String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate
    );
  }

  void myDeleteDatabase() async {
    // Directory directory = await getApplicationDocumentsDirectory();
    final String path = join(await getDatabasesPath(), _databaseName);
    log('$path database will be deleted.');
    await deleteDatabase(path);
    log('database deleted.');
  }


  Future _onCreate(Database db, int version) async {

    // ※ 컬럼 이름은 대소문자가 구별되므로 엄청나게 주의해야 한다.
    log('---- create table starting...');
    // groupCode table
    await db.execute('''
          CREATE TABLE $_groupTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name text NOT NULL
          ) ''');

    log('-- groupCode table successfully created.');
// 주의: 여기에서 INSERT하면 안되는 것 같다. 왜냐하면 아직데이터베이스가 완성되지 않은 상태이니까... 그룹코드에 기본값 추가
//     await insertGroupCode('일반');
//     await insertGroupCode('집');
//     await insertGroupCode('산책');
//     log('-- default data are inserted into groupCode table successfully.');

    // favorites table
    await db.execute('''
          CREATE TABLE $_favoritesTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            groupId INTEGER default 1, 
            name text NOT NULL,
            latitude DOUBLE NOT NULL,
            longitude DOUBLE NOT NULL,
            accuracy DOUBLE NOT NULL,
            updated TEXT
                      ) ''');
    log('-- favorites table successfully created.');

    // ROUTE CODE TABLE
    await db.execute('''
    CREATE TABLE $_routeCodeTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name text NOT NULL,
      updated TEXT
    ) ''');
    log('-- routeCode table successfully created.');

// ROUTES TABLE
    await db.execute('''
          CREATE TABLE $_routesTable (
            routeId INTEGER NOT NULL,
            idx INTEGER NOT NULL,
            name text NOT NULL,
            latitude DOUBLE NOT NULL,
            longitude DOUBLE NOT NULL,
            accuracy DOUBLE NOT NULL,
            PRIMARY KEY (routeId, idx)
          ) ''');
    log('-- routes table successfully created.');
    log('-- all tables are successfully created.');

  } // _onCreate


  // Data insert methods
  Future<int> insertGroupCode(String name) async {
    int result = 0; // insert를 한 후 테이블의 레코드 수를 반환하는 것 같다.
    const String _tableName =_groupTable;

    try {
      Database db = await DatabaseHelper.instance.database;
          result = await db.rawInsert(
              'INSERT INTO $_tableName (name) VALUES (?)',
              [name]);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
    log('insert: $_tableName, $result rows.');
    return result;
  }

  Future<int> insertFavorite(FavoriteData fd) async {
    int result = 0; // insert를 한 후 생성된 id를 반환하는 것 같다.
    const String _tableName = _favoritesTable;

    try {
      Database db = await DatabaseHelper.instance.database;
      // toJson에서 id는 autoincrement field이므로 제외된다.
      result = await db.insert(_tableName, fd.toJson());
      // result = await db.rawInsert(
      //     'INSERT INTO $_tableName (groupId, name, latitude, longitude, accuracy, updated) VALUES (?, ?, ?, ?, ?, ?)',
      //     [fd.groupId, fd.name, fd.latitude, fd.longitude, fd.accuracy, fd.updated]);
    } catch (e) {
      log('insert favorites table ERROR: ${e.toString()}');
      rethrow;
    }
    log('insert: $_tableName, id: $result.');
    return result;
  } // insertFavorite


  // read data
  Future<List<GroupData>> queryAllGroupCode() async {
    const String _tableName = _groupTable;
    try {
      Database db = await DatabaseHelper.instance.database;

      List<Map<String, dynamic>> result = await db.rawQuery(
              'SELECT * FROM $_tableName ORDER BY NAME'
          );

      if(result.isEmpty) return [];
      List<GroupData> list = result.map((val) => GroupData(
              id: val['id'],
              name: val['name']))
              .toList();
      return list;
    } catch (e) {
      log('Query groupCode error: $e');
      return [];
    }
  } // queryAllGroupCode

  Future<List<FavoriteData>> queryAllFavorite() async {
    const String _tableName = _favoritesTable;
    try {
      Database db = await DatabaseHelper.instance.database;

// 모든 즐겨찾기를 얻기 위해 테이블에 질의합니다.
      final List<Map<String, dynamic>> result = await db.query(_tableName);

// List<Map<String, dynamic>를 List<FavoriteData>으로 변환합니다.
      // if(maps.isEmpty || maps.length < 1) return [];
      // print(result);

      List<FavoriteData> list = result.map((val) => FavoriteData.fromJson(val)).toList();
      // List<FavoriteData> list =  List.generate(maps.length, (i) {
      //   return FavoriteData(
      //     id: maps[i]["id"],
      //     groupId: maps[i]["groupId"],
      //     name: maps[i]["name"],
      //     latitude: maps[i]["latitude"],
      //     longitude: maps[i]["longitude"],
      //     accuracy: maps[i]["accuracy"],
      //     updated: maps[i]["updated"]
      //   );
      // });
      return list;
    } catch (e) {
      log('query favorites table error: $e');
      return [];
    }
  } // queryAllFavorite

  // Future<List<FavoriteData>> queryAllFavorite() async {
  //   const String _tableName = _favoritesTable;
  //   try {
  //     Database db = await DatabaseHelper.instance.database;
  //
  //     List<Map<String, dynamic>> result = await db.rawQuery(
  //         'SELECT * FROM $_tableName ORDER BY NAME'
  //     );
  //
  //     log('map length: ${result.length}');
  //     if(result.isEmpty) return [];
  //     List<FavoriteData> list = result.map((val) => FavoriteData(
  //       id: val["id"],
  //       groupId: val["groupId"],
  //       name: val["name"],
  //       latitude: val["latitude"].toDouble(),
  //       longitude: val["longitude"].toDouble(),
  //       accuracy: val["accuracy"].toDouble(),
  //       updated: val["updated"],))
  //         .toList();
  //     return list;
  //   } catch (e) {
  //     log('query favorites table error: $e');
  //     return [];
  //   }
  // } // queryAllFavorite


  // delete data
  Future<int> deleteGroupCode(int id) async {
    const String _tableName = _groupTable;
    Database db = await DatabaseHelper.instance.database;
    int result = await db.rawDelete(
        'DELETE FROM $_tableName WHERE id = ?',
        [id]
    );
    // assert(result == 1);
    return result;
  }

  Future<void> deleteAllGroupCode() async {
    const String _tableName = _groupTable;
    Database db = await DatabaseHelper.instance.database;
    await db.rawDelete(
        'DELETE FROM $_tableName'
    );
  }

  //Update
  Future<int>  updateGroupCode(GroupData data) async {
    const String _tableName = _groupTable;
    Database db = await DatabaseHelper.instance.database;
    int result = await db.rawUpdate(
        'UPDATE $_tableName SET name = ? WHERE id = ?',
        [data.name, data.id]
    );
    // assert(result == 1);
    return result;
  }


} // class DatabaseHelper
