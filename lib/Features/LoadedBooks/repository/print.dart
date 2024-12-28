import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';

void printText(String textToPrint) async {
  var text = removeHtmlTags(textToPrint);
  final ByteData fontData = await rootBundle.load(Assets.fonts.khalidArtBold);
  final pw.Font ttf = pw.Font.ttf(fontData.buffer.asByteData());
  await Printing.layoutPdf(
    onLayout: (format) async {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: format,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text(
                textDirection: pw.TextDirection.rtl,
                text,
                style: pw.TextStyle(
                  fontSize: 20,
                  font: ttf,
                ),
              ),
            );
          },
        ),
      );

      return pdf.save();
    },
  );
}

String removeHtmlTags(String htmlString) {
  final RegExp tagRegExp =
      RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
  htmlString = htmlString.replaceAll('&nbsp;', ' ');
  htmlString = htmlString.replaceAll('<br />', '\n');

  return htmlString.replaceAll(tagRegExp, '');
}
