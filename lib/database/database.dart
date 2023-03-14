import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo_desktop/model/todo.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'todo.db');
    var db = await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _onCreate,
      ),
    );
    return db;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE todo(id INTEGER PRIMARY KEY,title TEXT,description TEXT,isFinished INTEGER)
    ''');
  }

  Future<List<Todo>> getTodos() async {
    Database db = await instance.database;
    var todos = await db.query('todo');
    List<Todo> todoList = todos.isNotEmpty
        ? todos.map((todo) => Todo.fromMap(todo)).toList()
        : [];
    return todoList;
  }

  Future<int> add(Todo todo) async {
    Database db = await instance.database;
    return await db.insert('todo', todo.toMap());
  }

  Future<Todo> getTodoById(int id) async {
    Database db = await instance.database;
    var todos = await db.query('todo', where: 'id = ?', whereArgs: [id]);
    if (todos.isNotEmpty) {
      return Todo.fromMap(todos.first);
    } else {
      throw Exception('Todo not found');
    }
  }

  Future<int> update(Todo todo) async {
    Database db = await instance.database;
    return await db
        .update('todo', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int> deleteTodo(int id) async {
    Database db = await instance.database;
    return await db.delete('todo', where: 'id = ?', whereArgs: [id]);
  }
}
