import 'dart:io';
import 'package:path/path.dart';

import 'package:burnout/src/models/TestModel.dart';
export 'package:burnout/src/models/TestModel.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;



class DBProvider {

  static Database? _database;

  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async{
    if(_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    final documentsDirectory = await getDatabasesPath();
    final path = p.join(documentsDirectory, 'TestsDB.db');
  
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Tests ( '
          ' id TEXT,'
          ' nroTest INTEGER,'
          ' date TEXT,'
          ' isBurnout INT'
          ')'
        );
        await db.execute(
          'CREATE TABLE Results ( '
          ' id TEXT,'
          ' idTest TEXT,'
          ' idQuestion INTEGER,'
          ' idSelection INTEGER'
          ')'
        );
      }
    );
  }
  
  nuevoTest(TestModel test) async {
    final db = await database;
    final res = await db?.insert('Tests', test.toJson());
    return res;
  }

  nuevoResult(Result result) async {
    final db = await database;
    final res = await db?.insert('Results', result.toJson());
    return res;
  }
  Future<void> deleteDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'TestsDB.db');
    databaseFactory.deleteDatabase(path);
  }

  Future<List<TestModel>> getTodosTests() async {
    final db = await database;
    final res = await db?.query('Tests',orderBy: 'date DESC');

    List<TestModel> list = res!.isNotEmpty ? res.map((c) => TestModel.fromJson(c)).toList() : [];

    return list;
  }

  //Eliminar registros
  Future<int?> deleteTest(String id) async {
    final db = await database;
    final res = await db?.delete('Tests',where: 'id=?',whereArgs: [id]);
    return res;
  }

  Future<List<Result>> getResults(String idTest) async {
    final db  = await database;
    final res = await db?.query('Results', where: 'idTest = ?', whereArgs: [idTest]) as List<Map<String, Object?>>;
    return res.isNotEmpty ? res.map((e) => Result.fromJson(e)).toList() : [];
  }

  Future<dynamic> alterTable(String TableName, String ColumneName) async {
    var dbClient = await database;
    var count = await dbClient?.execute("ALTER TABLE $TableName ADD "
        "COLUMN $ColumneName INT;");
    print(await dbClient?.query('Tests'));
    return count;
  }

  Future<List<TestModel>> obtenerTestsUltimoMes() async {
    final db = await database;
    DateTime now = DateTime.now();
    DateTime todayMidnight = DateTime(now.year,now.month,now.day);
    DateTime fechaMesAnterior = todayMidnight.subtract(Duration(days: 30));
    final res = await db?.rawQuery("SELECT * FROM Tests WHERE date >= ? AND date <= ?", [fechaMesAnterior.toString(), todayMidnight.toString()]);
    
    return res!.isNotEmpty ? res.map((e) => TestModel.fromJson(e)).toList() : [];
  }

  Future<List<TestModel>> obtenerTestsUltimaSemana() async {
    final db = await database;
    DateTime now = DateTime.now();
    DateTime todayMidnight = DateTime(now.year,now.month,now.day);
    DateTime oneWeekAgo = todayMidnight.subtract(Duration(days: 7));
    final res = await db?.rawQuery('SELECT id, date, isBurnout FROM Tests WHERE date >= ? AND date <= ?',[oneWeekAgo.toString(), todayMidnight.toString()]);
    
    List<TestModel> list = res!.isNotEmpty ? res.map((e) => TestModel.fromJson(e)).toList() : [];
    return list;
  }

  Future<List<TestModel>> obtenerTestsAyer() async {
    final db = await database;
    DateTime now = DateTime.now();
    DateTime todayMidnight = DateTime(now.year,now.month,now.day);
    DateTime yesterdayMidnight = todayMidnight.subtract(Duration(days: 1));
    /* await alterTable('Tests', 'isBurnout'); */
    final res = await db?.rawQuery('SELECT id, date, isBurnout FROM Tests WHERE date >= ? AND date <= ?',[yesterdayMidnight.toString(), todayMidnight.toString()]);
    List<TestModel> list = res!.isNotEmpty ? res.map((e) => TestModel.fromJson(e)).toList() : [];
    return list;
  }

}