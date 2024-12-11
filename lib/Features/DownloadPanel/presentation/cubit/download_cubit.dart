import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

part 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  DownloadCubit() : super(DownloadState());
  Future<void> startDownload(
      BuildContext context, String url, String fileName) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      _showErrorDialog(context, "أنت غير متصل بالإنترنت.");

      return;
    }
    emit(DownloadState(isLoading: true, progress: 0.0));

    FileDownloader.downloadFile(
      url: url,
      name: fileName,
      onProgress: (fileName, progress) {
        debugPrint('Download Progress: $progress%');

        emit(DownloadState(progress: state.progress + 0.1));
      },
      onDownloadCompleted: (String path) {
        emit(DownloadState(isLoading: false, progress: 1.0));

        Navigator.pop(context);
      },
      onDownloadError: (String error) {
        emit(DownloadState(isLoading: false));

        Navigator.pop(context);
        _showErrorDialog(context, "واجه التنزيل مشكلة.");
      },
    );
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
