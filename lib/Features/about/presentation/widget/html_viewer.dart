import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/services.dart' show rootBundle;

class HtmlViewer extends StatefulWidget {
  final String pathAbout;
  const HtmlViewer({super.key, required this.pathAbout});

  @override
  // ignore: library_private_types_in_public_api
  _HtmlViewerState createState() => _HtmlViewerState();
}

class _HtmlViewerState extends State<HtmlViewer> {
  late InAppWebViewController webViewController;
  String? htmlContent;

  @override
  void initState() {
    super.initState();
    _loadHtmlFromAssets();
  }

  Future<void> _loadHtmlFromAssets() async {
    try {
      String content = await rootBundle.loadString(widget.pathAbout);
      setState(() {
        htmlContent = content;
      });
    } catch (e) {
      print("Error loading HTML file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return htmlContent == null
        ? const Center(child: CircularProgressIndicator())
        : InAppWebView(
            initialData: InAppWebViewInitialData(
              data: htmlContent!,
              mimeType: 'text/html',
              encoding: 'utf-8',
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              domStorageEnabled: true,
              allowFileAccessFromFileURLs: true,
              allowUniversalAccessFromFileURLs: true,
              useShouldOverrideUrlLoading: true,
              javaScriptCanOpenWindowsAutomatically: true,
              supportZoom: false,
              horizontalScrollBarEnabled: false,
              verticalScrollBarEnabled: false,
            ),
          );
  }
}
