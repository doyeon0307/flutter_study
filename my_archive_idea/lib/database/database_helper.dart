import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../data/idea_info.dart';

class DatabaseHelper {
  late Database database; // late->늦은 초기화

  // 데이터베이스 초기화 및 열기
  Future<void> initDatabase() async {
    // 데이터베이스 경로 가져오기
    String path = join(await getDatabasesPath(), 'archive_idea.db');

    // 데이터베이스 열기 또는 생성
    // on->생명주기, onCreate->생성되다
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // 데이터베이스가 생성될 때 실행되는 코드
        db.execute('''
          CREATE TABLE IF NOT EXISTS tb_idea (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          motive TEXT,
          content TEXT,
          priority INTEGER,
          feedback TEXT,
          createdAt INTEGER
          );
        ''');
      },
    );
  }

  // IdeaInfo 데이터 삽입 (insert)
  // 데이터가 들어올 타이밍을 모름->Future(비동기)
  Future<int> insertIdeaInfo(IdeaInfo idea) async {
    return await database.insert('tb_idea', idea.toMap());
  }

  // IdeaInfo 데이터 조회 (select)
  // 모든 데이터를 리스트 형태로 가져옴->List<IdeaInfo>
  Future<List<IdeaInfo>> getAllIdeaInfo() async {
    final List<Map<String, dynamic>> result = await database.query('tb_idea');
    return List.generate(result.length, (index) {
      return IdeaInfo.fromMap(result[index]);
    });
  }

  // IdeaInfo 데이터 수정 (update)
  Future<int> updateIdeaInfo(IdeaInfo idea) async {
    return await database.update(
      'tb_idea',
      idea.toMap(),
      where: 'id = ?', // ?에 [idea.id]가 자동으로 삽입됨
      whereArgs: [idea.id],
    );
  }

  // IdeaInfo 데이터 삭제 (delete)
  Future<int> deleteIdeaInfo(int id) async {
    return await database.delete(
      'tb_idea',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 데이터베이스 닫기 (앱 내에서 데이터베이스 사용을 하지 않게 될 경우 닫아줘야 함)
  Future<void> closeDatabase() async {
    await database.close();
  }
}
