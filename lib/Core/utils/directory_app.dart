import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

Future<Directory> localDirectory(String folderName) async {
  final downloadPath = await getApplicationDocumentsDirectory();
  final booksDir = Directory('${downloadPath.path}/$folderName');

  if (!await booksDir.exists()) {
    await booksDir.create(recursive: true);
  }
  return booksDir;
}

void checkFile(String filePath,
    {required VoidCallback exist, required VoidCallback notAvailable}) async {
  final file = File(filePath);

  if (await file.exists()) {
    exist();
    print(file.path);
    print('فایل وجود دارد!');
  } else {
    notAvailable();
    print(file.path);

    print('فایل وجود ندارد.');
  }
}

Future<void> deleteFile(String fileName) async {
  final directory = await localDirectory('books');
  final file = File('${directory.path}/$fileName');
  if (await file.exists()) {
    try {
      await file.delete();
      print("فایل با موفقیت حذف شد.");
    } catch (e) {
      print("خطایی در حذف فایل رخ داد: $e");
    }
  } else {
    print("فایلی با این مسیر یافت نشد.");
  }
}
