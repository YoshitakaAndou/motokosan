import '../quiz/quiz_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseModel {
  Future<Database> databaseQuiz() async {
    return openDatabase(
      join(await getDatabasesPath(), 'MyDatabase.db'),
      onCreate: (db, version) {
        return db.execute('''CREATE TABLE IF NOT EXISTS my_table (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          questionId TEXT,
          category TEXT,
          question TEXT,
          option1 TEXT,
          option2 TEXT,
          option3 TEXT,
          option4 TEXT,
          correctOption TEXT,
          answerDescription TEXT,
          updateAt INTEGER,
          createAt INTEGER,
          answered TEXT,
          favorite TEXT
          )''');
      },
      version: 1,
    );
  }

  Future<void> insertQuiz(Question _dataDB) async {
    final Database db = await databaseQuiz();
    await db.insert(
      'my_table',
      _dataDB.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertQuizzes(List<Question> _datesDB) async {
    final Database db = await databaseQuiz();
    for (Question _dataDB in _datesDB) {
      await db.insert(
        'my_table',
        _dataDB.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Question>> getQuizzes() async {
    final Database db = await databaseQuiz();
    final List<Map<String, dynamic>> maps = await db.query('my_table');
    return Future.value(convert(maps));
  }

  Future<List<Question>> getSortedQuiz() async {
    final Database db = await databaseQuiz();
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM my_table ORDER BY answered ASC');
    return Future.value(convert(maps));
  }

  Future<List<Question>> getWhereQuizzes(String _key) async {
    final Database db = await databaseQuiz();
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM my_table WHERE answered = ?', [_key]);
    return Future.value(convert(maps));
  }

  Future<List<Question>> getQuizzesNotKey(String _key) async {
    final Database db = await databaseQuiz();
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM my_table WHERE answered <> ?', [_key]);
    return Future.value(convert(maps));
  }

  List<Question> convert(maps) {
    return List.generate(maps.length, (i) {
      return Question(
        id: maps[i]['id'],
        questionId: maps[i]['questionId'],
        category: maps[i]['category'],
        question: maps[i]['question'],
        option1: maps[i]['option1'],
        option2: maps[i]['option2'],
        option3: maps[i]['option3'],
        option4: maps[i]['option4'],
        correctOption: maps[i]['correctOption'],
        answerDescription: maps[i]['answerDescription'],
        updateAt: maps[i]['updateAt'],
        createAt: maps[i]['createAt'],
        answered: maps[i]['answered'],
        favorite: maps[i]['favorite'],
      );
    });
  }

  Future<void> updateQuizAtId(Question _dataDB) async {
    final db = await databaseQuiz();
    await db.update(
      'my_table',
      _dataDB.toMap(),
      where: "id = ?",
      whereArgs: [_dataDB.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> updateQuizAtQId(List<Question> _datesFB) async {
    final db = await databaseQuiz();
    for (Question _dataFB in _datesFB) {
      await db.update(
        'my_table',
        _dataFB.toMapQId(),
        where: "questionId = ?",
        whereArgs: [_dataFB.questionId],
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }
  }

  Future<void> updateQuizAnswered(String _key) async {
    final db = await databaseQuiz();
    await db.rawUpdate('UPDATE my_table SET answered = ?', [_key]);
  }

  Future<void> deleteQuiz(int _id) async {
    final db = await databaseQuiz();
    await db.delete(
      'my_table',
      where: "id = ?",
      whereArgs: [_id],
    );
  }

  Future<void> deleteQuizQid(String _questionId) async {
    final db = await databaseQuiz();
    await db.delete(
      'my_table',
      where: "questionId = ?",
      whereArgs: [_questionId],
    );
  }

  Future<void> deleteAllQuiz() async {
    final db = await databaseQuiz();
    await db.delete('my_table');
  }
}
