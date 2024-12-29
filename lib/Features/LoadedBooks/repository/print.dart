import 'package:flutter_application_1/Core/utils/remove_html_tags.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';

void printText(List textToPrint) async {
  final ByteData fontData = await rootBundle.load(Assets.fonts.khalidArtBold);
  final pw.Font ttf = pw.Font.ttf(fontData.buffer.asByteData());
  await Printing.layoutPdf(
    onLayout: (format) async {
      final pdf = pw.Document();

      for (var element in textToPrint) {
        var text = removeHtmlTags(element);

        pdf.addPage(
          pw.Page(
            pageFormat: format,
            build: (pw.Context context) {
              return pw.Center(
                  child: pw.Padding(
                padding:
                    const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                child: pw.Text(
                  textAlign: pw.TextAlign.justify,
                  textDirection: pw.TextDirection.rtl,
                  text,
                  style: pw.TextStyle(
                    fontSize: 20,
                    font: ttf,
                  ),
                ),
              ));
            },
          ),
        );
      }

      return pdf.save();
    },
  );
}
