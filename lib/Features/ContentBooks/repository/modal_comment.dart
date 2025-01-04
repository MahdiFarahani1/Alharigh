import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/common/common_snackBar.dart';
import 'package:flutter_application_1/Core/database/db_helper_LastUpdate.dart';

class ModalComment {
  static void show(BuildContext context,
      {required int idBook,
      required String bookname,
      required int idPage,
      required bool updateMode,
      required int id}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        TextEditingController _controller = TextEditingController();
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "أدخل تعليقك",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'التعليق',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isEmpty) {
                      CustomSnackBar.show(context,
                          message: "لا يمكن أن يكون حقل التعليق فارغًا");
                    } else {
                      DBhelperLastUpdate dbhelper = DBhelperLastUpdate();
                      if (updateMode) {
                        dbhelper.updateComment(id, _controller.text);
                      } else {
                        dbhelper.insertComment(
                            idBook, idPage, bookname, _controller.text);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('يرسل'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
