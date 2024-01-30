import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      relationship TEXT,
      birthdate DATE
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'a.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

//add
  static Future<int> createItem(
      String name, String relationship, String birthdate) async {
    final db = await SQLHelper.db();
    final Map<String, dynamic> map = <String, dynamic>{
      'name': name,
      'relationship': relationship,
      'birthdate': birthdate,
    };

    final id = await db.insert('users', map,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

//get
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('users', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('users', where: "id = ?", whereArgs: [id], limit: 1);
  }

  //update
  static Future<int> updateItem(
      int id, String name, String relationship, String birthdate) async {
    final db = await SQLHelper.db();
    final Map<String, dynamic> map = <String, dynamic>{
      'name': name,
      'relationship': relationship,
      'birthdate': birthdate,
    };

    final result =
        await db.update('users', map, where: "id = ?", whereArgs: [id]);
    return result;
  }

  //delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('users', where: "id = ?", whereArgs: [id]);
    } catch (e) {
      debugPrint("Error : $e");
    }
  }
}

//without gpt
