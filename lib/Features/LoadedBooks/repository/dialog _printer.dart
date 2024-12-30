import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/common/common_snackBar.dart';
import 'package:flutter_application_1/Features/LoadedBooks/repository/print.dart';

void showPrintDialog(
  BuildContext context, {
  required TextEditingController start,
  required TextEditingController end,
  required List<String> pages,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: end,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('الی', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: start,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final int? startPage = int.tryParse(start.text);
                    final int? endPage = int.tryParse(end.text);

                    if (startPage == null ||
                        endPage == null ||
                        startPage < 1 ||
                        endPage > pages.length ||
                        startPage > endPage) {
                      CustomSnackBar.show(context,
                          message: 'مقادیر واردشده نامعتبر هستند!');
                      return;
                    }

                    final List<String> selectedPages =
                        pages.sublist(startPage - 1, endPage);

                    printText(selectedPages);
                    Navigator.pop(context);
                  },
                  child: const Text('چاپ کن'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
