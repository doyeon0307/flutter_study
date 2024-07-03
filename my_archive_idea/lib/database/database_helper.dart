import 'package:my_archive_idea/data/idea_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  late Database _database;

  Future<void> initDatabase() async {
    String path = join(await getDatabasesPath(), 'archive_idea.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) {
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
      }
    );
  }

  Future<int> insertIdeaInfo(IdeaInfo idea) async {
    return await _database.insert('tb_idea', idea.toMap());
  }

  Future<List<IdeaInfo>> getAllIdeaInfo() async {
    final List<Map<String, dynamic>> result = await _database.query('tb_idea');
    return List.generate(result.length, (index) {
      return IdeaInfo.fromMap(result[index]);
    });
  }

  Future<int> updateIdeaInfo(IdeaInfo idea) async {
    return await _database.update (
      'tb_idea',
      idea.toMap(),
      where: 'id = ?',
      whereArgs: [idea.id],
    );
  }

  Future<int> deleteIdeaInfo(int id) async {
    return await  _database.delete(
      'tb_idea',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> closeDatabase() async {
    await _database.close();
  }
}