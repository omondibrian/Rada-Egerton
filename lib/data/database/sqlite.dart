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
    String path = join(await getDatabasesPath(), "Rada-Database.db");
    final taskDb = await openDatabase(path, version: 2, onCreate: createDb);
    return taskDb;
  }

  FutureOr<void> createDb(Database db, int version) async {
    //create user table
    await db.execute("""
      CREATE TABLE ${TableNames.user.name}(
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
    // counsellor table
    await db.execute("""
      CREATE TABLE ${TableNames.counsellor.name}(
        counsellorId int PRIMARY KEY, 
        rating float,
        expertise TEXT,
        _id int,
        status TEXT,
        FOREIGN KEY(_id) REFERENCES User(_id)
      )""");
    // create peerCounsellor table
    await db.execute("""
      CREATE TABLE ${TableNames.peerCounsellor.name}(
        peer_counsellorId int PRIMARY KEY, 
        regNo TEXT,
        campuses_id int,
        expertise TEXT,
        _id int,
        student_id TEXT,
        FOREIGN KEY(_id) REFERENCES User(_id)
      )""");
    await db.execute("""
       CREATE TABLE ${TableNames.informationData.name}(
        _id int PRIMARY KEY,
        content TEXT,
        metadata TEXT
       )""");
    // // store forum messages
    // await db.execute("""
    //    CREATE TABLE ${ChatPayload.tableName_ + "Forum"}(
    //     _id int PRIMARY KEY,
    //     imageUrl TEXT,
    //     message TEXT,
    //     sender_id TEXT,
    //     Groups_id TEXT NOT NULL,
    //     reply TEXT,
    //     status TEXT,
    //     reciepient TEXT,
    //     user_type TEXT,
    //     FOREIGN KEY(sender_id) REFERENCES User(_id),
    //     FOREIGN KEY(reciepient) REFERENCES User(_id)
    //    )""");
    // store private messages
    // await db.execute("""
    //    CREATE TABLE ${ChatPayload.tableName_ + "Private"}(
    //     _id int PRIMARY KEY,
    //     imageUrl TEXT,
    //     message TEXT,
    //     sender_id TEXT NOT NULL,
    //     Groups_id TEXT,
    //     reply TEXT,
    //     status TEXT,
    //     reciepient TEXT,
    //     user_type TEXT,
    //     FOREIGN KEY(sender_id) REFERENCES User(_id),
    //     FOREIGN KEY(reciepient) REFERENCES User(_id)
    //    )""");
    // store group messages
    // await db.execute("""
    //    CREATE TABLE ${ChatPayload.tableName_ + "Group"}(
    //     _id int PRIMARY KEY,
    //     imageUrl TEXT,
    //     message TEXT,
    //     sender_id TEXT,
    //     Groups_id TEXT NOT NULL,
    //     reply TEXT,
    //     status TEXT,
    //     reciepient TEXT,
    //     user_type TEXT,
    //     FOREIGN KEY(sender_id) REFERENCES User(_id),
    //     FOREIGN KEY(reciepient) REFERENCES User(_id)
    //    )""");

    // Groups
    await db.execute("""
       CREATE TABLE ${TableNames.group.name}(
        id int PRIMARY KEY,
        image TEXT,
        title TEXT
       )""");

    //forums
    await db.execute("""
       CREATE TABLE ${TableNames.forumn.name}(
        id int PRIMARY KEY,
        image TEXT,
        title TEXT
       )""");
  }

  Future<Model> insertItem(Model item, {required TableNames tableName}) async {
    db.then(
      (db) => db.insert(
        tableName.name,
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      ),
    );
    return item;
  }

  Future<Model> delete(
      {required Model item, required TableNames tableName}) async {
    db.then(
      (db) => db.delete(
        tableName.toString(),
        where: "_id = ?",
        whereArgs: [item.getId],
      ),
    );
    return item;
  }

  Future<Map<String, dynamic>?> getItem(TableNames tableName, int id) async {
    List<Map<String, dynamic>> query = await db.then(
        (db) => db.query(tableName.name, where: "_id = ?", whereArgs: [id]));
    if (query.isNotEmpty) {
      return query[0];
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getItems(TableNames tableName) async {
    Database database = await db;
    List<Map<String, dynamic>> query = await database.query(tableName.name);
    return query;
  }
}

abstract class Model {
  factory Model.fromJson() {
    throw UnimplementedError();
  }
  Map<String, dynamic> toMap();
  int get getId;
}

enum TableNames {
  user,
  counsellor,
  informationData,
  peerCounsellor,
  group,
  forumn,
}

extension X on TableNames {
  String get name => toString();
}
