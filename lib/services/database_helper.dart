import 'dart:io' as io;

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/task_model.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'Todo.db');
    var db = await openDatabase(path, version: 2, onCreate: _createDatabase);
    return db;
  }

  _createDatabase(Database db, int version) async {
    //creating table in the database
    await db.execute(
        "CREATE TABLE mytodo("
        "id INTEGER "
        "PRIMARY KEY AUTOINCREMENT,"
        "todoID TEXT NOT NULL,"
        "title TEXT NOT NULL,"
        "isDeleted INTEGER DEFAULT 0,"
        "isSynced INTEGER DEFAULT 1,"
        "description TEXT NOT NULL)"
    );
  }

  //inserting database
  Future<TodoModel> insert(TodoModel todoModel) async {
    var dbClient = await db;
    await dbClient?.insert('mytodo', todoModel.toDbMap());
    return todoModel;
  }

  Future<List<TodoModel>> insertAll(List<TodoModel> list) async {
    await deleteAll();
    await Future.forEach(list, (element) async {
      await insert(element);
    });
    return getDataList();
  }

  Future<void> deleteAll() async {
    await db;
    // ignore: non_constant_identifier_names
    final List<Map<String, dynamic>> queryResult =
        await _db!.rawQuery('SELECT * FROM mytodo');
    await Future.forEach(queryResult, (element) async {
      await delete(element['id']!);
    });
  }

  Future<List<TodoModel>> getDataList() async {
    await db;
    // ignore: non_constant_identifier_names
    final List<Map<String, Object?>> queryResult =
        await _db!.rawQuery('SELECT * FROM mytodo');
    return queryResult.map((e) {
      return TodoModel.fromDbMap(e);
    }).toList();
  }

  Future<int> update(TodoModel todoModel) async {
    var dbClient = await db;
    return await dbClient!.update('mytodo', todoModel.toDbMap(),
        where: 'id=?', whereArgs: [todoModel.dbId]);
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('mytodo',
        where: 'id=?', whereArgs: [id]);
  }
}
