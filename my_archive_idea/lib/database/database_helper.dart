import 'package:my_archive_idea/data/idea_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'archive_idea.db');
    print("Database path: $path");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) {
        print("onCreate called");
        db.execute('''
        CREATE TABLE IF NOT EXISTS tb_idea(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          motive TEXT,
          content TEXT,
          priority INTEGER,
          feedback TEXT,
          createdAt INTEGER
        )
        ''');
        print("Table created");
      },
    );
  }

  Future<int> insertIdeaInfo(IdeaInfo idea) async {
    final db = await database;
    print("Inserting idea: ${idea.title}");
    return await db.insert('tb_idea', idea.toMap());
  }

  Future<List<IdeaInfo>> getAllIdeaInfo() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('tb_idea');
    return List.generate(result.length, (index) {
      return IdeaInfo.fromMap(result[index]);
    });
  }

  Future<int> updateIdeaInfo(IdeaInfo idea) async {
    final db = await database;
    return await db.update(
      'tb_idea',
      idea.toMap(),
      where: 'id = ?',
      whereArgs: [idea.id],
    );
  }

  Future<int> deleteIdeaInfo(int id) async {
    final db = await database;
    return await db.delete(
      'tb_idea',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}