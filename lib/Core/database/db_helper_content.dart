import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBhelperContent {
  static final DBhelperContent _instance = DBhelperContent._internal();
  static final Map<String, Database> _databases = {};

  factory DBhelperContent() {
    return _instance;
  }

  DBhelperContent._internal();

  // متد برای باز کردن دیتابیس در مسیر مشخص
  Future<Database> database(String dbName, String folderName) async {
    if (_databases.containsKey(dbName)) return _databases[dbName]!;

    final db = await _initDb(dbName, folderName);
    _databases[dbName] = db;
    return db;
  }

  // متد اصلی برای آماده‌سازی دیتابیس
  Future<Database> _initDb(String dbName, String folderName) async {
    // Get the local directory
    final dir = await localDirectory(folderName);
    final path = join(dir.path, dbName);

    // Check if the database file exists in the device storage
    final exist = await File(path).exists();

    if (!exist) {
      // If the file doesn't exist, you can handle it by throwing an error or other logic
      throw Exception('Database file not found at path: $path');
    }

    return _openDatabase(path); // Open the database
  }

  // باز کردن دیتابیس
  Future<Database> _openDatabase(String path) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return openDatabase(path);
    } else {
      sqfliteFfiInit();
      return databaseFactoryFfi.openDatabase(path);
    }
  }

  // متد برای دریافت مسیر محلی
  Future<Directory> localDirectory(String folderName) async {
    final downloadPath = await getApplicationDocumentsDirectory();
    final booksDir = Directory('${downloadPath.path}/$folderName');
    return booksDir;
  }

  // کوئری برای دریافت همه کتاب‌ها از دیتابیس
  Future<List<Map<String, dynamic>>> getGroupBooks(
      String dbName, String folderName) async {
    final db = await database(dbName, folderName);
    return db.query(
      'bpages',
    );
  }

  // کوئری برای دریافت کتاب‌های یک گروه خاص
  Future<List<Map<String, dynamic>>> getGroupBookWithGid(
      String dbName, String folderName, int gid) async {
    final db = await database(dbName, folderName);
    return db.query('bookgroups', where: 'fatherId = ?', whereArgs: [gid]);
  }
}
