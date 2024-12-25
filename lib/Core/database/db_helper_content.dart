import 'dart:io';
import 'package:flutter_application_1/Core/utils/directory_app.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBhelperContent {
  static final DBhelperContent _instance = DBhelperContent._internal();
  static final Map<String, Database> _databases = {};

  factory DBhelperContent() {
    return _instance;
  }

  DBhelperContent._internal();

  Future<Database> database(String dbName, String folderName) async {
    if (_databases.containsKey(dbName)) return _databases[dbName]!;

    final db = await _initDb(dbName, folderName);
    _databases[dbName] = db;
    return db;
  }

  Future<Database> _initDb(String dbName, String folderName) async {
    final dir = await localDirectory(folderName);
    final path = join(dir.path, dbName);

    final exist = await File(path).exists();

    if (!exist) {
      throw Exception('Database file not found at path: $path');
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

  Future<List<Map<String, dynamic>>> getContentBooks(
    String dbName,
  ) async {
    final db = await database(dbName, '/books');
    return db.query(
      'bpages',
    );
  }

  Future<List<Map<String, dynamic>>> getGroupBooks(
    String dbName,
  ) async {
    final db = await database(dbName, '/books');
    return db.query(
      'bgroups',
    );
  }

  Future<List<Map<String, dynamic>>> getFavoritePages(
    String dbName,
  ) async {
    final db = await database(dbName, '/books');
    return db.query('bpages', where: 'fav = ?', whereArgs: [1]);
  }

  updateFav(String dbName, int pageId) async {
    final db = await database(dbName, '/books');

    var result = await db.query(
      'bpages',
      columns: ['fav'],
      where: 'id = ?',
      whereArgs: [pageId],
    );

    if (result.isNotEmpty) {
      int currentFav = result.first['fav'] as int;

      int newFav = currentFav == 0 ? 1 : 0;
      return db
          .update(
        'bpages',
        {'fav': newFav},
        where: 'id = ?',
        whereArgs: [pageId],
      )
          .then(
        (value) {
          return newFav;
        },
      );
    } else {
      throw Exception("Page not found.");
    }
  }

  Future<List<Map<String, dynamic>>> searchBooks(
    String dbName,
    String query,
    bool searchInTitle,
    bool searchInText,
  ) async {
    final db = await DBhelperContent().database(dbName, '/books');

    String queryStatement = '';

    if (searchInTitle && searchInText) {
      queryStatement = '''
      SELECT * FROM bpages WHERE _text LIKE '%$query%'
      UNION
      SELECT * FROM bgroups WHERE title LIKE '%$query%'
    ''';
    } else if (searchInTitle) {
      queryStatement = "SELECT * FROM bgroups WHERE title LIKE '%$query%'";
    } else if (searchInText) {
      queryStatement = "SELECT * FROM bpages WHERE _text LIKE '%$query%'";
    } else {
      return [];
    }

    return db.rawQuery(
      queryStatement,
    );
  }
}
