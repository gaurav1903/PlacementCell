import 'dart:developer';
import 'package:placement_cell/userdata.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBhelper {
  static Future<sql.Database> intitialisedb() async {
    String dbpath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
        path.join(dbpath, "usermessages+${User.userid}.db".toString()));
    // db.delete("hCjX8UMklSfohvjfFo97HXiCBah1recv");
    return db;
  }

  static Future<void> insert(
      String tablename, Map<String, dynamic> data) async {
    log('dbhelper insert ran tablename= $tablename');
    sql.Database db = await DBhelper.intitialisedb();

    await db.execute("create table if not exists " +
        tablename +
        "(msgid TEXT,sentby TEXT,sentto TEXT,text TEXT,time BIGINT,seen BOOL)");
    db.insert(tablename, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> givemessages(
      String tablename) async {
    log("givemessages ran $tablename");
    sql.Database db = await DBhelper.intitialisedb();
    // db.execute("DROP TABLE $tablename");
    return await db.query(tablename, orderBy: "time");
  }
  //TODO::TEST THIS SETUP
}
