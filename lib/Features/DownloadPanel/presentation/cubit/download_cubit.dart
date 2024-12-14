import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/database/db_helper_BookList.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/allbookList/book_all_list_data_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
part 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  DownloadCubit() : super(DownloadState());

  Future<void> startDownload(
    BuildContext context,
    String url,
    String pathDownload,
    int id,
  ) async {
    DBhelperBookList db = DBhelperBookList();
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      _showErrorDialog(context, "أنت غير متصل بالإنترنت.");
      return;
    }

    emit(DownloadState(isLoading: true, progress: 0.0));

    FileDownloader.downloadFile(
      url: url,
      onProgress: (fileName, progress) {
        emit(DownloadState(progress: state.progress + 0.1));
      },
      name: '$id.zip',
      subPath: pathDownload,
      onDownloadCompleted: (String path) async {
        try {
          await _extractZipFile(
              path, '/storage/emulated/0/Download/$pathDownload');

          emit(DownloadState(isLoading: false, progress: 1.0));
          Navigator.pop(context);
        } catch (e) {
          emit(DownloadState(isLoading: false));
          Navigator.pop(context);
          _showErrorDialog(context, "واجه التنزيل مشكلة: ${e.toString()}");
        }
        await db.updateDownload(id, 1);

        await BlocProvider.of<BookAllListDataCubit>(context).updateList();
      },
      onDownloadError: (String error) {
        emit(DownloadState(isLoading: false));
        Navigator.pop(context);
        _showErrorDialog(context, "واجه التنزيل مشكلة.");
      },
    );
  }

  Future<void> _extractZipFile(String zipFilePath, String targetPath) async {
    final zipFile = File(zipFilePath);

    // خواندن فایل زیپ
    final bytes = zipFile.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    // استخراج فایل‌ها
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
