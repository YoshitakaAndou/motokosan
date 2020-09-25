import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'lec_model.dart';

class LecDatabaseModel {
  Future<Database> databaseLec() async {
    return openDatabase(
      join(await getDatabasesPath(), 'MyDatabase2.db'),
      onCreate: (db, version) {
        return db.execute('''CREATE TABLE IF NOT EXISTS lec_table (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          lecId TEXT,
          category TEXT,
          subcategory TEXT,
          lecTitle TEXT,
          videoUrl TEXT,
          lecNo TEXT,
          description TEXT,
          correctQuestion TEXT,
          correctAnswer TEXT,
          incorrectQuestion TEXT,
          incorrectAnswer TEXT,
          slideUrl TEXT,
          updateAt INTEGER,
          createAt INTEGER,
          favorite TEXT,
          viewed TEXT,
          answered TEXT,
          answeredDate INTEGER
          )''');
      },
      version: 1,
    );
  }

  Future<void> insertLec(Lecture _dataDB) async {
    final Database db = await databaseLec();
    await db.insert(
      'lec_table',
      _dataDB.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertLecs(List<Lecture> _datesDB) async {
    final Database db = await databaseLec();
    for (Lecture _dataDB in _datesDB) {
      await db.insert(
        'lec_table',
        _dataDB.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Lecture>> getLecs() async {
    final Database db = await databaseLec();
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM lec_table ORDER BY lecNo ASC');
    // await db.query('lec_table');
    return Future.value(convert(maps));
  }

  Future<List<Lecture>> getSortedLec() async {
    final Database db = await databaseLec();
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM lec_table ORDER BY category ASC');
    return Future.value(convert(maps));
  }

  Future<List<Lecture>> getWhereLecsCategory(String _key) async {
    final Database db = await databaseLec();
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM lec_table WHERE category = ?', [_key]);
    return Future.value(convert(maps));
  }

  Future<List<Lecture>> getWhereCategoryAnswered(
      String _category, _answered) async {
    final Database db = await databaseLec();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM lec_table WHERE category = ? AND answered = ? ORDER BY lecNo ASC',
        [_category, _answered]);
    return Future.value(convert(maps));
  }

  List<Lecture> convert(maps) {
    return List.generate(maps.length, (i) {
      return Lecture(
        id: maps[i]['id'],
        lecId: maps[i]['lecId'],
        category: maps[i]['category'],
        subcategory: maps[i]['subcategory'],
        lecTitle: maps[i]['lecTitle'],
        videoUrl: maps[i]['videoUrl'],
        lecNo: maps[i]['lecNo'],
        description: maps[i]['description'],
        correctQuestion: maps[i]['correctQuestion'],
        correctAnswer: maps[i]['correctAnswer'],
        incorrectQuestion: maps[i]['incorrectQuestion'],
        incorrectAnswer: maps[i]['incorrectAnswer'],
        slideUrl: maps[i]['slideUrl'],
        updateAt: maps[i]['updateAt'],
        createAt: maps[i]['createAt'],
        favorite: maps[i]['favorite'],
        viewed: maps[i]['viewed'],
        answered: maps[i]['answered'],
        answeredDate: maps[i]['answeredDate'],
      );
    });
  }

  Future<void> updateLecAtId(Lecture _dataDB) async {
    final db = await databaseLec();
    await db.update(
      'lec_table',
      _dataDB.toMap(),
      where: "id = ?",
      whereArgs: [_dataDB.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> updateLecAtLecId(List<Lecture> _datesFB) async {
    final db = await databaseLec();
    for (Lecture _dataFB in _datesFB) {
      await db.update(
        'lec_table',
        _dataFB.toMapLecId(),
        where: "lecId = ?",
        whereArgs: [_dataFB.lecId],
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }
  }

  Future<void> resetLecAnswered(String _answered, _viewed) async {
    final db = await databaseLec();
    await db.rawUpdate('UPDATE lec_table SET answered = ?', [_answered]);
    await db.rawUpdate('UPDATE lec_table SET viewed = ?', [_viewed]);
  }

  Future<void> deleteLec(int _id) async {
    final db = await databaseLec();
    await db.delete(
      'lec_table',
      where: "id = ?",
      whereArgs: [_id],
    );
  }

  Future<void> deleteLecLecId(String _lecId) async {
    final db = await databaseLec();
    await db.delete(
      'lec_table',
      where: "lecId = ?",
      whereArgs: [_lecId],
    );
  }

  Future<void> deleteAllLec() async {
    final db = await databaseLec();
    await db.delete('lec_table');
  }
}
