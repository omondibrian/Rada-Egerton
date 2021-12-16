import 'package:flutter_test/flutter_test.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/entities/CounsellorsDTO.dart';
import 'package:rada_egerton/entities/PeerCounsellorDTO.dart';
import 'package:rada_egerton/entities/UserDTO.dart';
import 'package:rada_egerton/entities/informationData.dart';
import 'package:rada_egerton/utils/sqlite.dart';
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart" as Path;

class SqlTest {
  late DBManager sql;
  User user = User(
    id: 1,
    name: "ojay",
    email: "test@gmail.com",
    profilePic: "",
    gender: "m",
    phone: "1234",
    dob: "123",
    status: "",
    accountStatus: "open",
    synced: "true",
    joined: "1223",
  );
  User user2 = User(
    id: 112,
    name: "john",
    email: "test@gmail.com",
    profilePic: "",
    gender: "m",
    phone: "1234",
    dob: "123",
    status: "",
    accountStatus: "open",
    synced: "true",
    joined: "1223",
  );
  SqlTest() {
    this.sql = DBManager();
  }
  Future<void> deleteDB() async {
    String path = Path.join(await getDatabasesPath(), "Rada-Database.db");
    await deleteDatabase(path);
  }

  Future<Model> saveUser() async {
    final res = await sql.insertItem(user);
    return res;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final sqlTest = SqlTest();
  testWidgets("Deleting database", (WidgetTester tester) async {
    sqlTest.deleteDB();
  });
  testWidgets("User insert into database", (WidgetTester tester) async {
    await sqlTest.saveUser().then((user) {
      expect(user is User, true);
    });
  });
  testWidgets("Query all user should return a list with map objects",
      (WidgetTester tester) async {
    final _userList = await sqlTest.sql.getItems(User.tableName_);
    expect(_userList is List, true);
    expect(User.fromJson(_userList[0]) is User, true);
    expect(_userList.length, 1);
  });

  testWidgets("Query a user  by id should return map objects",
      (WidgetTester tester) async {
    await sqlTest.sql.db.then((db) async {
      final _res = await db.query(User.tableName_,
          where: "_id = ?", whereArgs: [sqlTest.user.id]);
      print(_res[0]);
      expect(_res[0] is Map, true);
      // expect(_userList.length, 1);
    });
  });
  testWidgets("insert counsellor", (WidgetTester tester) async {
    await sqlTest.sql
        .insertItem(Counsellor(
            user: sqlTest.user,
            rating: 1,
            isOnline: false,
            expertise: "expertise",
            counsellorId: 1))
        .then((res) {
      expect(res is Model, true);
    });
  });

  testWidgets("insert peer counsellor", (WidgetTester tester) async {
    await sqlTest.sql
        .insertItem(PeerCounsellorDto(
      user: sqlTest.user,
      peerCounsellorId: 1,
      regNo: "1233",
      expertise: "test",
    ))
        .then((res) {
      expect(res is Model, true);
    });
  });
  testWidgets("Query a  counsellor   by  user id", (WidgetTester tester) async {
    await sqlTest.sql.db.then((db) async {
      final _res = await db.query(Counsellor.tableName_,
          where: "_id = ?", whereArgs: [sqlTest.user.id]);
      print(_res[0]);
      expect(_res[0] is Map, true);
      // expect(_userList.length, 1);
    });
  });
  testWidgets("Query a peer counsellor   by  user id",
      (WidgetTester tester) async {
    await sqlTest.sql.db.then((db) async {
      final _res = await db.query(PeerCounsellorDto.tableName_,
          where: "_id = ?", whereArgs: [sqlTest.user.id]);
      print(_res[0]);
      expect(_res[0] is Map, true);
      // expect(_userList.length, 1);
    });
  });
  //join table
  testWidgets("Query a peer counsellor   by  user id-  join to use table",
      (WidgetTester tester) async {
    await sqlTest.sql.db.then((db) async {
      final _res = await db.rawQuery("""
          SELECT * FROM  ${PeerCounsellorDto.tableName_} 
          INNER JOIN  ${User.tableName_} 
          ON ${PeerCounsellorDto.tableName_}._id = ${User.tableName_}._id""",
          []);
      print(_res[0]);

      expect(PeerCounsellorDto.fromJson(_res[0]) is PeerCounsellorDto, true);
    });
  });
  testWidgets("Query a  counsellor   by  user id -  join to use table",
      (WidgetTester tester) async {
    await sqlTest.sql.db.then(
        (db) => db.query(Counsellor.tableName_).then((res) => print(res)));
    await sqlTest.sql.db.then((db) async {
      final _res = await db.rawQuery("""
          SELECT * FROM  ${Counsellor.tableName_} 
          INNER JOIN  ${User.tableName_} 
          ON ${Counsellor.tableName_}._id = ${User.tableName_}._id""", []);
      print("----res $_res");
      expect(_res.length > 0, true);
      expect(Counsellor.fromJson(_res[0]) is Counsellor, true);
      // expect(_userList.length, 1);
    });
  });
  //create information item
  testWidgets("create information", (WidgetTester tester) async {
    await sqlTest.sql
        .insertItem(InformationData(
            content: [],
            id: 1111,
            metadata: InformationMetadata(
                category: "1", thumbnail: "", title: "test")))
        .then((res) {
      expect(res is Model, true);
    });
  });
  //create information item
  testWidgets("create chat item", (WidgetTester tester) async {
    await sqlTest.sql
        .insertItem(
      ChatPayload(
          reply: null,
          groupsId: null,
          id: 11,
          message: "message",
          imageUrl: "imageUrl",
          senderId: sqlTest.user2.id.toString(),
          status: "status",
          reciepient: sqlTest.user.id.toString()),
    )
        .then((res) {
      expect(res is Model, true);
    });
  });
}
