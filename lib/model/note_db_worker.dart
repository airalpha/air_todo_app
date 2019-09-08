import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

import 'note.dart';

class NoteDbWorker {
  NoteDbWorker._();

  static final NoteDbWorker db = NoteDbWorker._();

  Database _db;

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "note.db");
    Database db = await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE IF NOT EXISTS note ("
              "id INTEGER PRIMARY KEY,"
              "title TEXT,"
              "date Text"
              ")"
        );
      }
    );
    return db;
  }

  Future get database async {
    if(_db == null){
      _db = await init();
    }
    return _db;
  }

  Note noteFromMap(Map map) {
    Note note = Note();
    note.id = map["id"];
    note.title = map["title"];
    note.date = map["date"];

    return note;
  }

  Map<String, dynamic> noteToMap(Note note) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = note.id;
    map["title"] = note.title;
    map["date"] = note.date;

    return map;
  }

  Future create(Note note) async {
    Database db = await database;
    var val = await db.rawInsert(
      "INSERT INTO note (title, date)"
          "VALUES (?,?)",
      [note.title, note.date]
    );
  }

  Future<Note> get(int id) async {
    Database db = await database;
    var req = await db.query(
      "note",
      where: "id = ?",
      whereArgs: [id]
    );

    return noteFromMap(req.first);
  }

  Future<List> getAll() async {
    Database db = await database;
    var reqs = await db.query("note");
    var list = reqs.isEmpty ? [ ] : reqs.map((map) => noteFromMap(map)).toList();

    return list;
  }

  Future update(Note note) async {
    Database db = await database;
    
    return await db.update("note", noteToMap(note), where: "id = ?", whereArgs: [note.id]);
  }

  Future delete(int id) async {
    Database db = await database;
    
    return await db.delete("note", where: "id = ?", whereArgs: [id]);
  }
}
