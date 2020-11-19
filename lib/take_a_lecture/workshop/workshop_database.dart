import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'workshop_class.dart';

class WorkshopDatabase {
  static final WorkshopDatabase instance = WorkshopDatabase();

  // table毎に新しくDatabaseを作らないとエラーになるよ！

  Future<Database> dbWorkshop() async {
    return openDatabase(
      join(await getDatabasesPath(), 'motoko2.db'),
      onCreate: (db, version) {
        return db.execute('''CREATE TABLE IF NOT EXISTS workshop_result (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          workshopId TEXT,
          isTaken TEXT,
          graduaterId TEXT,
          lectureCount INTEGER,
          takenCount INTEGER,
          isTakenAt INTEGER,
          isSendAt INTEGER
          )''');
      },
      version: 1,
    );
  }

  Future<void> saveValue(WorkshopResult _data, bool _isUpDate) async {
    final Database db = await dbWorkshop();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM workshop_result WHERE workshopId = ?',
        [_data.workshopId]);
    // todo
    print("DB saveValueのworkshopId:${_data.workshopId}");
    if (maps.length == 0) {
      await _insert(_data);
      print("WorkshopResultを${_data.isTaken}で新規登録したよ");
    } else {
      if (_isUpDate) {
        await _update(_data);
        print("WorkshopResultを${_data.isTaken}で更新したよ");
      } else {
        print("WorkshopResultを登録しなかったよ");
      }
    }
  }

  Future<void> _update(WorkshopResult _data) async {
    final Database db = await dbWorkshop();
    await db.update(
      'workshop_result',
      _data.toMap(),
      where: "workshopId = ?",
      whereArgs: [_data.workshopId],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> _insert(WorkshopResult _data) async {
    final Database db = await dbWorkshop();
    await db.insert(
      'workshop_result',
      _data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteWorkshopResult(String _workshopId) async {
    final Database db = await dbWorkshop();
    await db.delete(
      'workshop_result',
      where: "lectureId = ?",
      whereArgs: [_workshopId],
    );
  }

  Future<List<WorkshopResult>> getWorkshopResult(String _workshopId) async {
    final Database db = await dbWorkshop();
    final maps = await db.query(
      'workshop_result',
      where: 'workshopId = ?',
      whereArgs: [_workshopId],
    );
    return Future.value(convert(maps));
  }

  List<WorkshopResult> convert(maps) {
    return List.generate(maps.length, (i) {
      return WorkshopResult(
        id: maps[i]['id'],
        workshopId: maps[i]['workshopId'],
        isTaken: maps[i]['isTaken'],
        graduaterId: maps[i]['graduaterId'],
        lectureCount: maps[i]['lectureCount'],
        takenCount: maps[i]['takenCount'],
        isTakenAt: maps[i]['isTakenAt'],
        isSendAt: maps[i]['isSendAt'],
      );
    });
  }

  Future<void> deleteWorkshopResults() async {
    final Database db = await dbWorkshop();
    await db.delete(
      'workshop_result',
    );
  }
}
