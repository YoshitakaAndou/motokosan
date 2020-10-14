import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'question_model.dart';

class QuestionDatabase {
  Future<Database> dbQuestion() async {
    return openDatabase(
      join(await getDatabasesPath(), 'motoko.db'),
      onCreate: (db, version) {
        return db.execute('''CREATE TABLE IF NOT EXISTS question_result (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          questionId TEXT,
          answerResult TEXT,
          answerAt INTEGER
          )''');
      },
      version: 1,
    );
  }

  Future<void> saveValue(QuestionResult _data) async {
    final Database db = await dbQuestion();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM question_result WHERE questionId = ?',
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
      'question_result',
      _data.toMap(),
      where: "questionId = ?",
      whereArgs: [_data.questionId],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> _insert(QuestionResult _data) async {
    final Database db = await dbQuestion();
    await db.insert(
      'question_result',
      _data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<QuestionResult>> getAnswerResult(String _questionId) async {
    final Database db = await dbQuestion();
    final maps = await db.query(
      'question_result',
      where: 'questionId = ?',
      whereArgs: [_questionId],
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
      );
    });
  }

  Future<int> countAnswerResult(String _answerResult) async {
    final Database db = await dbQuestion();
    final maps = await db.query(
      'question_result',
      where: 'answerResult = ?',
      whereArgs: [_answerResult],
    );
    return maps.length;
  }
}
