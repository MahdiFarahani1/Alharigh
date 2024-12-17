import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_application_1/Core/utils/directory_app.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/database/db_helper_BookList.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/allbookList/book_all_list_data_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  DownloadCubit() : super(DownloadState());

  Future<void> startDownload(
    BuildContext context,
    String url,
    String fileName,
    int id,
  ) async {
    DBhelperBookList db = DBhelperBookList();
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      _showErrorDialog(context, "أنت غير متصل بالإنترنت.");
      return;
    }

    emit(DownloadState(isLoading: true, progress: 0.0));

    final booksDir = await localDirectory('/books');

    // Ensure the "Books" directory exists
    if (!await booksDir.exists()) {
      await booksDir.create(recursive: true);
    }

    final filePath = '${booksDir.path}/$fileName';

    try {
      final response = await http.get(Uri.parse(url));
      print(booksDir);
      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Optional: Uncomment to extract ZIP file
        await _extractZipFile(filePath, booksDir.path);

        emit(DownloadState(isLoading: false, progress: 1.0));
        Navigator.pop(context);

        await db.updateDownload(id, 1);
        await BlocProvider.of<BookAllListDataCubit>(context).updateList();
      } else {
        throw Exception(
            'Failed to download file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      emit(DownloadState(isLoading: false));
      Navigator.pop(context);
      _showErrorDialog(context, "واجه التنزيل مشكلة: ${e.toString()}");
      print(e);
    }
  }

  Future<void> _extractZipFile(String zipFilePath, String targetPath) async {
    final zipFile = File(zipFilePath);

    // Read the ZIP file
    final bytes = zipFile.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    // Extract files
    for (final file in archive) {
      final filePath = '$targetPath/${file.name}';
      if (file.isFile) {
        final outputFile = File(filePath);
        await outputFile.create(recursive: true);
        await outputFile.writeAsBytes(file.content as List<int>);
      } else {
        Directory(filePath).createSync(recursive: true);
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('خطأ'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("نعم"),
            ),
          ],
        ),
      ),
    );
  }
}
