import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "booklist.sqlite");

    final exist = await databaseExists(path);

    if (!exist) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data =
          await rootBundle.load(join("assets/database", "booklist.sqlite"));
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

  Future<List<Map<String, dynamic>>> getGroupBooks() async {
    final db = await database;
    return db.query(
      'bookgroups',
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
    return db.query('books', orderBy: 'id_show ASC');
  }

  Future<List<Map<String, dynamic>>> getRealArticle(int id) async {
    final db = await database;
    return db.query(
      'articles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getSearch(String query) async {
    final db = await database;
    return db.rawQuery("SELECT * FROM articles WHERE _text LIKE '%$query%'");
  }

  Future<List<Map<String, dynamic>>> getAllsave() async {
    final db = await database;
    return db.query('bookmark');
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
          'downloaded': 0,
          'fav': 0,
          'last_update': lastUpdate,
          'sound_dl': 0,
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
