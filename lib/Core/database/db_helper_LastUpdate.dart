import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBhelperBookList {
  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "db3.0.sqlite");

    if (await databaseExists(path)) {
      return _openDatabase(path);
    } else {
      final Directory appDocumentsDir =
          await getApplicationDocumentsDirectory();
      final filePath = join(appDocumentsDir.path, "db3.0.sqlite");

      await Directory(dirname(filePath)).create(recursive: true);

      final ByteData data =
          await rootBundle.load('assets/database/db3.0.sqlite');
      final List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(filePath).writeAsBytes(bytes, flush: true);

      return _openDatabase(filePath);
    }
  }

  Future<Database> _openDatabase(String path) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return openDatabase(path);
    } else {
      sqfliteFfiInit();
      return databaseFactoryFfi.openDatabase(path);
    }
  }

  Future<List<Map<String, dynamic>>> getLastUpdate() async {
    Database db = await initDb();
    return db.query('personalsetting');
  }
}
