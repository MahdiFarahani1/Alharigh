import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBhelperBookList {
  static final DBhelperBookList _instance = DBhelperBookList._internal();
  static Database? _database;

  factory DBhelperBookList() {
    return _instance;
  }

  DBhelperBookList._internal();

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
    final path = join(dbPath, "booklist.sqlite");

    final exist = await databaseExists(path);

    if (!exist) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data =
          await rootBundle.load(join("assets/database/", "booklist.sqlite"));
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
      return openDatabase(path);
    }
  }

  Future<List<Map<String, dynamic>>> getGroupBooks() async {
    final db = await database;
    return db.query(
      'bookgroups',
      orderBy: 'id_show ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getGroupBookWithGid(int gid) async {
    final db = await database;
    return db.query(
      'bookgroups',
      where: 'fatherId = ?',
      whereArgs: [gid],
      orderBy: 'id_show ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getGroupBooksContetnt(int fotherId) async {
    final db = await database;
    return db.query(
      'books',
      where: 'gid = ?',
      whereArgs: [fotherId],
      orderBy: 'id_show ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getAllBooks() async {
    final db = await database;
    return db.query('books',
        orderBy: 'id_show ASC', where: 'downloaded = ?', whereArgs: [0]);
  }

  Future<void> insertOrUpdateCategory({
    required String title,
    required int idShow,
    required int fatherId,
    required int bookCount,
  }) async {
    final db = await database;

    final result = await db.query(
      "bookgroups",
      where: "fatherId = ?",
      whereArgs: [fatherId],
      orderBy: 'id_show ASC',
    );

    if (result.isNotEmpty) {
      await db.update(
        "bookgroups",
        {
          "id_show": idShow,
          "name": title,
          "rownum": bookCount,
        },
        where: "fatherId = ?",
        whereArgs: [fatherId],
      );
    } else {
      await db.insert(
        "bookgroups",
        {
          "fatherId": fatherId,
          "id_show": idShow,
          "name": title,
          "rownum": bookCount,
        },
      );
    }
  }

  Future<void> updateDownload(int id, int isDownload) async {
    final db = await database;

    await db.rawUpdate(
      'UPDATE books SET downloaded = ? WHERE id = ?',
      [isDownload, id],
    );
  }

  Future<bool> updateDownloadEditBook(int id, int isDownload) async {
    final db = await database;

    int count = await db.rawUpdate(
      'UPDATE books SET downloaded = ? WHERE id = ? AND downloaded = 1',
      [isDownload, id],
    );

    return count > 0;
  }

  Future<List<Map<String, dynamic>>> getDownloadedItems() async {
    final db = await database;

    return await db.rawQuery(
      'SELECT * FROM books WHERE downloaded = ?',
      [1],
    );
  }

  Future<void> insertOrUpdateBook({
    required String title,
    required int idShow,
    required int id,
    required int gid,
    required int part,
    required String pdf,
    required String epub,
    required String writer,
    required String sound,
    required String img,
    required String scholar,
    required int bookCode,
    required String description,
    required int internationalNumber,
    required String lastUpdate,
  }) async {
    final db = await database;

    final result = await db.query(
      "books",
      where: "id = ?",
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      await db.update(
        "books",
        {
          'gid': gid,
          'title': title,
          'joz': part,
          'pdf': pdf,
          'img': img,
          "id_show": idShow,
          'international_number': internationalNumber,
          "scholar": scholar,
          "book_code": bookCode,
          "writer": writer,
          "epub": epub,
          "description": description,
          'version': 2,
          'info_version': 0,
          'fav': 0,
          'last_update': lastUpdate,
          'sound_dl': 0,
          'sound_url': sound,
          'pdf_dl': 0,
        },
        where: "id = ?",
        whereArgs: [id],
      );
    } else {
      await db.insert(
        "books",
        {
          'id': id,
          'gid': gid,
          'title': title,
          'joz': part,
          'pdf': pdf,
          'img': img,
          "id_show": idShow,
          "writer": writer,
          "epub": epub,
          'international_number': internationalNumber,
          "scholar": scholar,
          "book_code": bookCode,
          "description": description,
          'version': 2,
          'info_version': 0,
          'downloaded': 0,
          'fav': 0,
          'last_update': lastUpdate,
          'sound_dl': 0,
          'sound_url': sound,
          'pdf_dl': 0,
        },
      );
    }
  }

  Future<void> deleteArticle({
    required int id,
  }) async {
    final db = await database;
    await db.delete("bookmark", where: "id = ?", whereArgs: [id]);
  }
}
