import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBhelperBook {
  Future initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "booklist.sqlite");

    final exist = await databaseExists(path);

    if (exist) {
    } else {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data =
          await rootBundle.load(join("assets/database", "booklist.sqlite"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    return openDatabase(path);
  }

  Future<List<Map<String, dynamic>>> getGroupBooks() async {
    Database db = await initDb();
    return db.query('bookgroups');
  }

  Future<List<Map<String, dynamic>>> getGroupBooksContetnt(int fotherId) async {
    Database db = await initDb();

    return db.query(
      'books',
      where: 'gid = ?',
      whereArgs: [fotherId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllBooks() async {
    Database db = await initDb();
    return db.query(
      'books',
    );
  }

  Future<List<Map<String, dynamic>>> getRealArticle(int id) async {
    Database db = await initDb();
    return db.query(
      'articles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getSearch(String query) async {
    Database db = await initDb();
    return db.rawQuery("SELECT * FROM articles WHERE _text LIKE '%$query%'");
  }

  Future<List<Map<String, dynamic>>> getAllsave() async {
    Database db = await initDb();
    return db.query(
      'bookmark',
    );
  }

  insertArticle(
      {required String title, required int id, required int groupId}) async {
    Database db = await initDb();
    db.insert("bookmark", {
      "id": id,
      "groupId": groupId,
      "title": title,
    });
  }

  deleteArticle({
    required int id,
  }) async {
    Database db = await initDb();
    db.delete("bookmark", where: "id = ?", whereArgs: [id]);
  }
}
