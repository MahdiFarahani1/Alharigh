import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

Future<Directory> localDirectory(String folderName) async {
  final downloadPath = await getApplicationDocumentsDirectory();
  final booksDir = Directory('${downloadPath.path}/$folderName');
  return booksDir;
}

Future<Directory> localDirectoryPdf(String folderName) async {
  final downloadPath = await getApplicationDocumentsDirectory();
  final folderDir = Directory('${downloadPath.path}/$folderName');

  if (!await folderDir.exists()) {
    print('Creating directory: ${folderDir.path}');
    await folderDir.create(recursive: true);
  }

  return folderDir;
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
