import 'package:flutter_exercise/models/note.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_exercise/constant/constant.dart';

class DatabaseHelper{

  static DatabaseHelper _databaseHelper;
  static Database _database;



  // factory helps to return object from constructor
  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  // name constructor
  DatabaseHelper._createInstance();

  Future<Database> get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  //---------initialize database-----------
  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + kNoteDatabaseName;

    //open/create database
    var noteDatabase = await openDatabase(path,version: 1,onCreate: _createNoteDb);
    return noteDatabase;
  }

  //--------create database--------------
  void _createNoteDb(Database db, int databaseVersion) async{
    String _query = "CREATE TABLE $kNoteTable ( $kNoteId INTEGER PRIMARY KEY AUTOINCREMENT, $kNoteTitle TEXT, $kNoteDescription TEXT, $kNotePriority INTEGER, $kNoteDate TEXT)";
    await db.execute(_query);
  }


  //--------FETCH operation-----------
  Future<List<Map<String,dynamic>>>getNoteMapList() async{
    Database database = await this.database;
    //var result = await database.rawQuery("SELECT * FROM $kNoteTable order by $kNotePriority ASC");
    var result = await database.query(kNoteTable,orderBy: "$kNotePriority ASC");
    return result;

  }

  //----------INSERT DATA---------------
  Future<int> insertNote(Note note) async{
    Database database = await this.database;
    var result = await database.insert(kNoteTable, note.toMap());
    return result;
  }

  //--------UPDATE DATA---------------
  Future<int> updateNote(Note note) async{
    Database database = await this.database;
    var result = await database.update(kNoteTable, note.toMap(), where: '$kNoteId =?',whereArgs: [note.id]);
    return result;
  }

  //--------- DELETE DATA----------
  Future<int> deleteNote(int id) async{
    Database database = await this.database;
    var result = await database.rawDelete("DELETE FROM $kNoteTable WHERE $kNoteId = $id");
    return result;
  }

  // get count
  Future<int> getCount() async{
      Database database = await this.database;
      List<Map<String,dynamic>> x = await database.rawQuery("SELECT COUNT (*) FROM $kNoteTable");
      int result = Sqflite.firstIntValue(x);
      return result;
  }

  //get note list
  Future<List<Note>> getNoteList() async{
    var noteMapList  = await getNoteMapList();
    print(noteMapList.length);
    List<Note> noteList  = List<Note>();
    for(int i = 0 ; i<noteMapList.length ; i++){
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }



}