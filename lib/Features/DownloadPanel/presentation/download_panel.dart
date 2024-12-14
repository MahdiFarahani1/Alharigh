import 'package:flutter/material.dart';
import 'package:flutter_application_1/Features/DownloadPanel/presentation/cubit/download_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DownloadPanel extends StatefulWidget {
  final String url;
  final int id;
  final String downloadPath;
  const DownloadPanel(
      {super.key,
      required this.url,
      required this.id,
      required this.downloadPath});

  @override
  State<DownloadPanel> createState() => _DownloadPanelState();
}

class _DownloadPanelState extends State<DownloadPanel> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => DownloadCubit()
          ..startDownload(context, widget.url, widget.downloadPath, widget.id),
        child: AlertDialog(
          content: BlocBuilder<DownloadCubit, DownloadState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("جارٍ التنزيل..."),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(value: state.progress),
                  const SizedBox(height: 16),
                  Text("${(state.progress * 100).toStringAsFixed(0)}%"),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
