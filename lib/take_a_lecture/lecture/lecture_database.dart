import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'lecture_class.dart';

class LectureDatabase {
  static final LectureDatabase instance = LectureDatabase();

  // table毎に新しくDatabaseを作らないとエラーになるよ！

  Future<Database> dbLecture() async {
    return openDatabase(
      join(await getDatabasesPath(), 'motoko1.db'),
      onCreate: (db, version) {
        return db.execute('''CREATE TABLE IF NOT EXISTS lecture_result (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          lectureId TEXT,
          isTaken TEXT,
          questionCount INTEGER,
          correctCount INTEGER,
          isTakenAt INTEGER
          )''');
      },
      version: 1,
    );
  }

  Future<void> saveValue(LectureResult _data, bool _isUpDate) async {
    final Database db = await dbLecture();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM lecture_result WHERE lectureId = ?', [_data.lectureId]);
    // todo
    print("saveValueのlectureId:${_data.lectureId}");
    if (maps.length == 0) {
      await _insert(_data);
      print("LectureResultを新規登録したよ");
    } else {
      if (_isUpDate) {
        await _update(_data);
        print("LectureResultを更新したよ");
      } else {
        print("LectureResultを登録しなかったよ");
      }
    }
  }

  Future<void> _update(LectureResult _data) async {
    final Database db = await dbLecture();
    await db.update(
      'lecture_result',
      _data.toMap(),
      where: "lectureId = ?",
      whereArgs: [_data.lectureId],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> _insert(LectureResult _data) async {
    final Database db = await dbLecture();
    await db.insert(
      'lecture_result',
      _data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteLectureResult(String _lectureId) async {
    final Database db = await dbLecture();
    await db.delete(
      'lecture_result',
      where: "lectureId = ?",
      whereArgs: [_lectureId],
    );
  }

  Future<List<LectureResult>> getLectureResult(String _lectureId) async {
    final Database db = await dbLecture();
    final maps = await db.query(
      'lecture_result',
      where: 'lectureId = ?',
      whereArgs: [_lectureId],
    );
    return Future.value(convert(maps));
  }

  List<LectureResult> convert(maps) {
    return List.generate(maps.length, (i) {
      return LectureResult(
        id: maps[i]['id'],
        lectureId: maps[i]['lectureId'],
        isTaken: maps[i]['isTaken'],
        questionCount: maps[i]['questionCount'],
        correctCount: maps[i]['correctCount'],
        isTakenAt: maps[i]['isTakenAt'],
      );
    });
  }

  Future<void> deleteLectureResults() async {
    final Database db = await dbLecture();
    await db.delete(
      'lecture_result',
    );
  }
}
