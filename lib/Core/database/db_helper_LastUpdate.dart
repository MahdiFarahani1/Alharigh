import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "db3.0.sqlite");

    final exist = await databaseExists(path);

    if (!exist) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data =
          await rootBundle.load(join("assets/database", "db3.0.sqlite"));
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
}
