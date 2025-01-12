import 'dart:ffi';
import 'dart:io';

import 'package:notes_app/notes_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatabase {
  static late Database _db;

  static Future<Database> initialiseDatabase() async {
    // applicationDirectory = await getApplicationDocumentsDirectory();
    //String databasePath = "${applicationDirectory.path}notes.db";
    var dbPath = await getDatabasesPath();
    var databasePath = join(dbPath, 'notes.db');

    _db = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE Notes (id INTEGER PRIMARY KEY, title TEXT, description TEXT, time INTEGER)');
      },
    );
    return _db;
  }

  static Future<List<NotesModel>> getDataFromDatabase() async {
    final result = await _db.query("Notes");

    List<NotesModel> notesModel =
        result.map((e) => NotesModel.fromJson(e)).toList();

    return notesModel;
  }

  static Future<void> insertData(NotesModel model) async {
    final result = await _db.insert("Notes", model.toJson());

    print(result);
  }

  static Future<void> deleteDataFromDatabase(int time) async {
    final result =
        await _db.delete("Notes", where: "time = ?", whereArgs: [time]);

    print(result);
  }

  static Future<void> updateDataInDatabase(NotesModel model, int time) async {
    final result = await _db
        .update("Notes", model.toJson(), where: "time = ?", whereArgs: [time]);

    print(result);
  }
}
