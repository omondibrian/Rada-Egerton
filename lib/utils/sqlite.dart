import 'dart:async';
import "package:path/path.dart";
import 'package:sqflite/sqflite.dart';

class SqliteDB {
  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  /// Initialize DB
  initDb() async {
    String path = join(await getDatabasesPath(), "Rada-Database.db");
    final taskDb = await openDatabase(path, version: 1, onCreate: createDb);
    return taskDb;
  }

  FutureOr<void> createDb(Database db, int version) async {
    //create user table
    await db.execute("""
      CREATE TABLE User(
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        age INTEGER
      )""");
  }
}
  //  required this.id,
  //   required this.name,
  //   required this.email,
  //   required this.profilePic,
  //   required this.gender,
  //   required this.phone,
  //   required this.dob,
  //   required this.status,
  //   required this.accountStatus,
  //   required this.synced,
  //   required this.joined,