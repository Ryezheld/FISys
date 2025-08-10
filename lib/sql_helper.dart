import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS tb_user(
        id_user TEXT PRIMARY KEY NOT NULL,
        user_login TEXT,
        nama TEXT,
        user TEXT,
        id_xpdc TEXT,
        tipe_user TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )"""
    );
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'fysis_local.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(String idUser, String userLogin, String? nama, String? user, String idXpdc, String tipeUser) async {
    final db = await SQLHelper.db();

    final data = {'id_user': idUser, 'user_login': userLogin, 'nama': nama, 'user': user, 'id_xpdc': idXpdc, 'tipe_user': tipeUser};
    final id = await db.insert('tb_user', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('tb_user', orderBy: "id_user");
  }

  static Future<void> deleteItem(String idUser) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("tb_user", where: "id_user = ?", whereArgs: [idUser]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<List<Map<String, dynamic>>> getUrls() async {
    final db = await SQLHelper.db();
    return db.query('API');
  }

  static Future<int> updateUrl(int id, String url) async {
      final db = await SQLHelper.db();

      final data = {
        'id': id,
        'url': url
      };

      final result =
      await db.update('API', data, where: "id = ?", whereArgs: [id]);
      return result;
  }
}