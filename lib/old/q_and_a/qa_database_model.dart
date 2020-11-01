import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'qa_model.dart';

class QaDatabaseModel {
  Future<Database> databaseQa() async {
    return openDatabase(
      join(await getDatabasesPath(), 'MyDatabase1.db'),
      onCreate: (db, version) {
        return db.execute('''CREATE TABLE IF NOT EXISTS qa_table (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          qaId TEXT,
          category TEXT,
          question TEXT,
          answer TEXT,
          description TEXT,
          imageUrl TEXT,
          updateAt INTEGER,
          createAt INTEGER,
          favorite TEXT
          )''');
      },
      version: 1,
    );
  }

  Future<void> insertQa(QuesAns _dataDB) async {
    final Database db = await databaseQa();
    await db.insert(
      'qa_table',
      _dataDB.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertQas(List<QuesAns> _datesDB) async {
    final Database db = await databaseQa();
    for (QuesAns _dataDB in _datesDB) {
      await db.insert(
        'qa_table',
        _dataDB.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<QuesAns>> getQas() async {
    final Database db = await databaseQa();
    final List<Map<String, dynamic>> maps = await db.query('qa_table');
    return Future.value(convert(maps));
  }

  Future<List<QuesAns>> getSortedQa() async {
    final Database db = await databaseQa();
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM qa_table ORDER BY category ASC');
    return Future.value(convert(maps));
  }

  Future<List<QuesAns>> getWhereQasCategory(String _key) async {
    final Database db = await databaseQa();
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM qa_table WHERE category = ?', [_key]);
    return Future.value(convert(maps));
  }

  List<QuesAns> convert(maps) {
    return List.generate(maps.length, (i) {
      return QuesAns(
        id: maps[i]['id'],
        qaId: maps[i]['qaId'],
        category: maps[i]['category'],
        question: maps[i]['question'],
        answer: maps[i]['answer'],
        description: maps[i]['description'],
        imageUrl: maps[i]['imageUrl'],
        updateAt: maps[i]['updateAt'],
        createAt: maps[i]['createAt'],
        favorite: maps[i]['favorite'],
      );
    });
  }

  Future<void> updateQaAtId(QuesAns _dataDB) async {
    final db = await databaseQa();
    await db.update(
      'qa_table',
      _dataDB.toMap(),
      where: "id = ?",
      whereArgs: [_dataDB.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> updateQaAtQId(List<QuesAns> _datesFB) async {
    final db = await databaseQa();
    for (QuesAns _dataFB in _datesFB) {
//      print("qaId = ${_dataFB.qaId}");
//      print("question = ${_dataFB.question}");
      await db.update(
        'qa_table',
        _dataFB.toMapQId(),
        where: "qaId = ?",
        whereArgs: [_dataFB.qaId],
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }
  }

  Future<void> deleteQa(int _id) async {
    final db = await databaseQa();
    await db.delete(
      'qa_table',
      where: "id = ?",
      whereArgs: [_id],
    );
  }

  Future<void> deleteQaQid(String _qaId) async {
    final db = await databaseQa();
    await db.delete(
      'qa_table',
      where: "qaId = ?",
      whereArgs: [_qaId],
    );
  }

  Future<void> deleteAllQa() async {
    final db = await databaseQa();
    await db.delete('qa_table');
  }
}
