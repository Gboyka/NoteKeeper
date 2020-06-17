
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:notekeeper/models/note.dart';


class DatabaseHelper {
//declare singleton object,i.e.,instance which will be initialized only once
//throughout the lifecycle of our app.
//only one instance exist
  static DatabaseHelper _databaseHelper; //singleton object static is used

  static Database _database; //Singleton database

//define all the attributes of the database for the structure of database

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';


  DatabaseHelper._createInstance(); //named constructor to create instance of Database Helper

  factory DatabaseHelper(){
    if (_databaseHelper == null) { //ensures executed only once.
      _databaseHelper = DatabaseHelper._createInstance(); //named Constructor
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null)
      _database =
      await initializeDatabase(); //for first time of database creation

    return _database; // return the new/old instance of database
  }

  Future<Database> initializeDatabase() async {
    //get the directory path for both Android and iOS to store database
    Directory directory = await getApplicationDocumentsDirectory();

    //define path for location of database.
    String path = directory.path + 'note.db'; //

    // open/Create the database at a given path:

    var noteDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    return noteDatabase; //return our new database
  }


  //create database
  //use async and await to create database in parallel
  void _createDb(Database db, int newVersion) async {
    //create table using SQL query
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
            '$colTitle TEXT, $colDescription TEXT, $colPriority INTEGER,$colDate TEXT)');
  }

  //CRUD operations

  //Fetch Operation
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    //var result =await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC'); //raw query
    // OR we can use
    var result = await db.query(
        noteTable, orderBy: '$colPriority ASC'); // inbuilt query function
    return result; //future object of  list of  map it will be converted later to note object
  }

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable,note.toMap()); //convert to Map object
    return result;
  }
  Future<int>  updateNote(Note note) async{

    var db=await this.database;
    var result= await db.update(noteTable,note.toMap(),where:'$colId=?',whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async{
    var db=await this.database;
    int result=await db.rawDelete('DELETE FROM $noteTable WHERE $colId=$id ');
    return result;
  }

  //get number of notes

  Future<int> getCount() async{
    Database db= await this.database;

    List<Map<String,dynamic>> x=await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result=Sqflite.firstIntValue(x);
    return result;
  }

}

