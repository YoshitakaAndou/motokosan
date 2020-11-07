import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../question_class.dart';

class QuestionDatabase {
  static final QuestionDatabase instance = QuestionDatabase();

  Future<Database> dbQuestion() async {
    return openDatabase(
      join(await getDatabasesPath(), 'motoko.db'),
      onCreate: (db, version) {
        print("question_result無かった");
        return db.execute('''CREATE TABLE IF NOT EXISTS question_results (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          questionId TEXT,
          answerResult TEXT,
          answerAt INTEGER,
          lectureId TEXT,
          flag1 TEXT
          )''');
      },
      version: 1,
    );
  }

  Future<void> saveValue(QuestionResult _data) async {
    final Database db = await dbQuestion();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM question_results WHERE questionId = ?',
        [_data.questionId]);
    if (maps.length == 0) {
      await _insert(_data);
    } else {
      await _update(_data);
    }
  }

  Future<void> _update(QuestionResult _data) async {
    final Database db = await dbQuestion();
    await db.update(
      'question_results',
      _data.toMap(),
      where: "questionId = ?",
      whereArgs: [_data.questionId],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> _insert(QuestionResult _data) async {
    final Database db = await dbQuestion();
    await db.insert(
      'question_results',
      _data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> flag1Reset(_value) async {
    final Database db = await dbQuestion();
    await db.rawUpdate('UPDATE question_results SET flag1 = ?', [_value]);
  }

  Future<List<QuestionResult>> getAnswerResultQuestionId(
      String _questionId) async {
    final Database db = await dbQuestion();
    final maps = await db.query(
      'question_results',
      where: 'questionId = ?',
      whereArgs: [_questionId],
    );
    return Future.value(convert(maps));
  }

  Future<List<QuestionResult>> getAnswerResultLectureId(
      String _lectureId) async {
    final Database db = await dbQuestion();
    final maps = await db.query(
      'question_results',
      where: 'lectureId = ?',
      whereArgs: [_lectureId],
    );
    return Future.value(convert(maps));
  }

  List<QuestionResult> convert(maps) {
    return List.generate(maps.length, (i) {
      return QuestionResult(
        id: maps[i]['id'],
        questionId: maps[i]['questionId'],
        answerResult: maps[i]['answerResult'],
        answerAt: maps[i]['answerAt'],
        lectureId: maps[i]['lectureId'],
        // flag1: maps[i]['flag1'],
      );
    });
  }

  Future<int> countAnswerResult(String _lectureId, String _answerResult) async {
    final Database db = await dbQuestion();
    final maps = await db.query(
      'question_results',
      where: 'lectureId = ? and answerResult = ?',
      whereArgs: [_lectureId, _answerResult],
    );
    return maps.length;
  }

  Future<void> deleteFlag1(String _lectureId, String _flag1) async {
    final Database db = await dbQuestion();
    await db.delete(
      'question_results',
      where: "lectureId = ? and flag1 = ?",
      whereArgs: [_lectureId, _flag1],
    );
  }

  Future<void> deleteQuestionResults() async {
    final Database db = await dbQuestion();
    await db.delete(
      'question_results',
    );
  }
}
