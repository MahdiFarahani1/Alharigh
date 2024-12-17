import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/database/db_helper_BookList.dart';
import 'package:flutter_application_1/Core/utils/directory_app.dart';
import 'package:flutter_application_1/Core/utils/loading.dart';
import 'package:flutter_application_1/Features/LoadedBooks/repository/delete_file.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class DownloadedBookListPage extends StatefulWidget {
  const DownloadedBookListPage({super.key});

  @override
  State<DownloadedBookListPage> createState() => _DownloadedBookListPageState();
}

class _DownloadedBookListPageState extends State<DownloadedBookListPage> {
  late Directory pathImg;
  @override
  void initState() {
    convertPath();
    super.initState();
  }

  convertPath() async {
    pathImg = await localDirectory('/books');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: DBhelperBookList().getDownloadedItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CustomLoading.fadingCircle(context);
          }
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.data!.isNotEmpty &&
              snapshot.connectionState == ConnectionState.done) {
            print(snapshot.data!.length);

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final book = snapshot.data![index];
                bool havePart = book['joz'] != 0;

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border(
                          bottom: BorderSide(
                              width: 0.5,
                              color: Theme.of(context)
                                  .floatingActionButtonTheme
                                  .backgroundColor!),
                          right: BorderSide(
                              width: 0.5,
                              color: Theme.of(context)
                                  .floatingActionButtonTheme
                                  .backgroundColor!))),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Image.file(
                          File("${pathImg.path}/${book['id']}.jpg"),
                          width: 60,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                havePart
                                    ? book['title'] +
                                        " " 'الجزء' " " +
                                        book['joz'].toString()
                                    : book['title'],
                                style: Theme.of(context).textTheme.bodyLarge,
                                maxLines: 2,
                                textDirection: TextDirection.rtl,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  iconItem(context, icon: Icons.delete,
                                      onTap: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text(
                                          'تأكيد الحذف',
                                          textDirection: TextDirection.rtl,
                                        ),
                                        content: const Text(
                                          'هل أنت متأكد أنك تريد حذف الكتاب؟',
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
                                            onPressed: () async {
                                              await DBhelperBookList()
                                                  .updateDownload(
                                                      book['id'], 0);
                                              deleteFile(
                                                  '/storage/emulated/0/Download/Books/${book['id']}.zip');
                                              deleteFile(
                                                  '/storage/emulated/0/Download/Books/${book['id']}.jpg');
                                              deleteFile(
                                                  '/storage/emulated/0/Download/Books/b${book['id']}.sqlite');
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'تأكيد',
                                              textDirection: TextDirection.rtl,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  iconItem(context,
                                      icon: Icons.print, onTap: () {}),
                                  iconItem(context,
                                      icon: Icons.qr_code, onTap: () {}),
                                  iconItem(context,
                                      icon: Icons.picture_as_pdf,
                                      onTap: () {},
                                      color: book['pdf'] == ''
                                          ? Colors.grey
                                          : Colors.white),
                                  iconItem(context,
                                      icon: Icons.volume_up, onTap: () {}),
                                  iconItem(context,
                                      icon: Icons.info, onTap: () {}),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget iconItem(BuildContext context,
      {required IconData icon,
      required Function onTap,
      Color color = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ZoomTapAnimation(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color:
                  Theme.of(context).floatingActionButtonTheme.backgroundColor),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
