import 'package:flutter/material.dart';

class CustomDialog {
  static void showDeleteDilog(BuildContext context,
      {required VoidCallback onTap}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'تأكيد الحذف',
          textDirection: TextDirection.rtl,
        ),
        content: const Text(
          'هل أنت متأكد أنك تريد الحذف ؟',
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'إلغاء',
              textDirection: TextDirection.rtl,
            ),
          ),
          TextButton(
            onPressed: () {
              onTap();
            },
            child: const Text(
              'تأكيد',
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }
}
