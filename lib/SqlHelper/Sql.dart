import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBhelper {
  static Future<sql.Database> intitialisedb() async {
    String dbpath = await sql.getDatabasesPath();
    return await sql
        .openDatabase(path.join(dbpath, "usermessages.db".toString()));
  }

  static Future<void> insert(
      String tablename, Map<String, dynamic> data) async {
    log('dbhelper insert ran');
    sql.Database db = await DBhelper.intitialisedb();
    // await db.execute("drop table " + data['sentto'].toString());
    await db.execute("create table if not exists " +
        data['sentto'].toString() +
        "(msgid TEXT,sentby TEXT,sentto TEXT,text TEXT,time TEXT,seen BOOL)");
    db.insert(data['sentto'].toString(), data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> givemessages(String userid) async {
    sql.Database db = await DBhelper.intitialisedb();
    return await db.query(userid.toString()); //TODO:: WE HAVE TO ADD ORDER BY
  }
  //TODO::TEST THIS SETUP
}
