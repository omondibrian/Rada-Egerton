import 'dart:async';
import "package:path/path.dart";
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/entities/CounsellorsDTO.dart';
import 'package:rada_egerton/entities/GroupDTO.dart';
import 'package:rada_egerton/entities/PeerCounsellorDTO.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/entities/informationData.dart';
import 'package:sqflite/sqflite.dart';

class DBManager {
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
      CREATE TABLE ${User.tableName_}(
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
      CREATE TABLE ${Counsellor.tableName_}(
        counsellorId int PRIMARY KEY, 
        rating float,
        expertise TEXT,
        _id int,
        status TEXT,
        FOREIGN KEY(_id) REFERENCES User(_id)
      )""");
    // create peerCounsellor table
    await db.execute("""
      CREATE TABLE ${PeerCounsellorDto.tableName_}(
        peer_counsellorId int PRIMARY KEY, 
        regNo TEXT,
        campuses_id int,
        expertise TEXT,
        _id int,
        student_id TEXT,
        FOREIGN KEY(_id) REFERENCES User(_id)
      )""");
    await db.execute("""
       CREATE TABLE ${InformationData.tableName_}(
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
       CREATE TABLE Group(
        id int PRIMARY KEY,
        image TEXT,
        title TEXT
       )""");

    // Groups
    await db.execute("""
       CREATE TABLE ${GroupDTO.tableName_}(
        id int PRIMARY KEY,
        image TEXT,
        title TEXT
       )""");
    //forums
    await db.execute("""
       CREATE TABLE Forum(
        id int PRIMARY KEY,
        image TEXT,
        title TEXT
       )""");
  }

  Future<Model> insertItem(Model item, {String? tableName}) async {
    db.then((_db) => _db.insert(
          tableName ?? item.tableName,
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        ));
    return item;
  }

  Future<Model> deleteModel(Model item) async {
    db.then((_db) =>
        _db.delete(item.tableName, where: "_id = ?", whereArgs: [item.getId]));
    return item;
  }

  Future<Map<String, dynamic>?> getItem(String tableName, int id) async {
    List<Map<String, dynamic>> query = await db
        .then((_db) => _db.query(tableName, where: "_id = ?", whereArgs: [id]));
    if (query.length > 0) {
      return query[0];
    }
  }

  Future<List<Map<String, dynamic>>> getItems(String tableName) async {
    Database database = await db;
    List<Map<String, dynamic>> _query = await database.query(tableName);
    return _query;
  }
}

abstract class Model {
  Map<String, dynamic> toMap();
  int get getId;
  String get tableName;
}
