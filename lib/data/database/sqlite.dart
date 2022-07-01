import 'dart:async';
import "package:path/path.dart";

import 'package:sqflite/sqflite.dart';

class DBManager {
  DBManager._();
  static DBManager instance = DBManager._();

  Database? _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  /// Initialize DB
  Future<Database> initDb() async {
    String path = join(
      await getDatabasesPath(),
      "Rada-Database.db",
    );
    final taskDb = await openDatabase(
      path,
      version: 2,
      onCreate: createDb,
    );
    return taskDb;
  }

  FutureOr<void> createDb(
    Database db,
    int version,
  ) async {
    //create user table
    await db.execute("""
      CREATE TABLE users(
        _id int PRIMARY KEY,
        name TEXT,
        email TEXT,
        profilePic TEXT,
        gender TEXT,
        dob TEXT,
        status TEXT,
        account_status TEXT,
        synced TEXT,
        joined TEXT,
        phone TEXT
      )""");

    // store chats
    await db.execute("""
       CREATE TABLE chats(
        _id int PRIMARY KEY,
        imageUrl TEXT,
        message TEXT,
        sender_id TEXT,
        Groups_id TEXT,
        reply TEXT,
        status TEXT,
        reciepient TEXT,
        user_type TEXT
       )""");

    // Groups
    await db.execute("""
       CREATE TABLE groups(
        id int PRIMARY KEY,
        image TEXT,
        title TEXT,
        forumn INTEGER
       )""");
  }

  Future<Map<String, dynamic>> insertItem(
    Map<String, dynamic> item, {
    required String tableName,
  }) async {
    db.then(
      (db) => db.insert(
        tableName,
        item,
        conflictAlgorithm: ConflictAlgorithm.replace,
      ),
    );
    return item;
  }

  Future<void> delete({
    required Map<String, dynamic> args,
    required String tableName,
  }) async {
    db.then(
      (db) => db.delete(
        tableName,
        where: args.keys.map((k) => "$k = ?").join(' and '),
        whereArgs: args.values.toList(),
      ),
    );
  }

  Future<Map<String, dynamic>?> getItem({
    required String tableName,
    required Map<String, dynamic> args,
  }) async {
    List<Map<String, dynamic>> query = await db.then(
      (db) => db.query(
        tableName,
        where: args.keys.map((k) => "$k = ?").join(' and '),
        whereArgs: args.values.toList(),
      ),
    );
    if (query.isNotEmpty) {
      return query[0];
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getItems(
    String tableName,
  ) async {
    Database database = await db;
    List<Map<String, dynamic>> query = await database.query(tableName);
    return query;
  }
}

