import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<Directory> localDirectory(String folderName) async {
  final downloadPath = await getApplicationDocumentsDirectory();
  final booksDir = Directory('${downloadPath.path}/$folderName');
  return booksDir;
}
