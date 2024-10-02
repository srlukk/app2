
//banco de dados


import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:master_books/models/livro.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'livros.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE livros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT,
        autor TEXT,
        imagem TEXT,
        resumo TEXT
      )
    ''');
  }

  Future<int> inserirLivro(Livro livro) async {
    Database db = await database;
    return await db.insert('livros', livro.toMap());
  }

  Future<List<Livro>> obterLivros() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('livros');

    return List.generate(maps.length, (i) {
      return Livro.fromMap(maps[i]);
    });
  }

  Future<int> atualizarLivro(Livro livro) async {
    Database db = await database;
    return await db.update(
      'livros',
      livro.toMap(),
      where: 'id = ?',
      whereArgs: [livro.id],
    );
  }

  Future<int> deletarLivro(int id) async {
    Database db = await database;
    return await db.delete(
      'livros',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
