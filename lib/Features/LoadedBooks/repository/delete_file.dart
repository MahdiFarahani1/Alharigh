import 'dart:io';

Future<void> deleteFile(String filePath) async {
  final file = File(filePath);
  if (await file.exists()) {
    try {
      await file.delete();
      print("فایل با موفقیت حذف شد.");
    } catch (e) {
      print("خطایی در حذف فایل رخ داد: $e");
    }
  } else {
    print("فایلی با این مسیر یافت نشد.");
  }
}
