import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBhelperLastUpdate {
  static final DBhelperLastUpdate _instance = DBhelperLastUpdate._internal();
  static Database? _database;

  factory DBhelperLastUpdate() {
    return _instance;
  }

  DBhelperLastUpdate._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String dbPath = '';
    if (Platform.isAndroid || Platform.isIOS) {
      dbPath = await getDatabasesPath();
    } else {
      final directory = await getApplicationDocumentsDirectory();
      dbPath = directory.path;
    }
    final path = join(dbPath, "db3.0.sqlite");

    final exist = await databaseExists(path);

    if (!exist) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data =
          await rootBundle.load(join("assets/database/", "db3.0.sqlite"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    return _openDatabase(path);
  }

  Future<Database> _openDatabase(String path) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return openDatabase(path);
    } else {
      sqfliteFfiInit();
      return databaseFactoryFfi.openDatabase(path);
    }
  }

  Future<String> getLastUpdate() async {
    final db = await database;
    var data = await db.query('personalsetting');
    return data[0]['last_update'].toString();
  }

  updateLastUpdate(String lastUpdate) async {
    final db = await database;
    await db.update('personalsetting', {
      'last_update': lastUpdate,
    });
  }

  insertOrdeletePageFavorite(
      int idPage, int idBook, String bookName, String text) async {
    final db = await database;

    final result = await db.query(
      'bookmark',
      where: 'idpage = ? AND idbook = ?',
      whereArgs: [idPage, idBook],
    );

    if (result.isNotEmpty) {
      await db.delete(
        'bookmark',
        where: 'idpage = ? AND idbook = ?',
        whereArgs: [idPage, idBook],
      );
    } else {
      await db.insert('bookmark', {
        'idbook': idBook,
        'idpage': idPage,
        'text': text,
        'book_name': bookName,
      });
    }
  }

  insertOrdeleteBookFavorite(int idBook, String bookName) async {
    final db = await database;

    final result = await db.query(
      'favoritive',
      where: 'idbook = ?',
      whereArgs: [idBook],
    );

    if (result.isNotEmpty) {
      await db.delete(
        'favoritive',
        where: 'idbook = ?',
        whereArgs: [idBook],
      );
    } else {
      await db.insert('favoritive', {
        'idbook': idBook,
        'bookname': bookName,
      });
    }
  }

  insertComment(int idBook, int idPage, String bookName, String comment) async {
    final db = await database;

    await db.insert('comments', {
      'idbook': idBook,
      'bookname': bookName,
      'comment': comment,
      'idpage': idPage
    });
  }

  updateComment(int id, String text) async {
    final db = await database;
    await db.update(
      'comments',
      {
        'comment': text,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  deleteComment(int id) async {
    final db = await database;
    await db.delete(
      'comments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getComments() async {
    final db = await database;

    final result = await db.query(
      'comments',
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> getDataPageFavorite() async {
    final db = await database;

    final result = await db.query(
      'bookmark',
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> getDataBookFavorite() async {
    final db = await database;

    final result = await db.query(
      'favoritive',
    );
    return result;
  }
}
