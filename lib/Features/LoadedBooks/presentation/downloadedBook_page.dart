import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/database/db_helper_BookList.dart';
import 'package:flutter_application_1/Core/database/db_helper_Content.dart';
import 'package:flutter_application_1/Core/utils/directory_app.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/Core/utils/loading.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/content_page.dart';
import 'package:flutter_application_1/Features/DownloadPanel/presentation/download_url.dart';
import 'package:flutter_application_1/Features/LoadedBooks/repository/delete_file.dart';
import 'package:flutter_application_1/Features/LoadedBooks/repository/dialog%20_printer.dart';
import 'package:open_file/open_file.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class DownloadedBookListPage extends StatefulWidget {
  const DownloadedBookListPage({super.key});

  @override
  State<DownloadedBookListPage> createState() => _DownloadedBookListPageState();
}

class _DownloadedBookListPageState extends State<DownloadedBookListPage> {
  TextEditingController controllerStart = TextEditingController();
  TextEditingController controllerEnd = TextEditingController();

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

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContentPage(
                              scrollPosetion: 1,
                              id: book['id'],
                              bookName: book['title']),
                        ));
                  },
                  child: Container(
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
                                                textDirection:
                                                    TextDirection.rtl,
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
                                                textDirection:
                                                    TextDirection.rtl,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                    iconItem(context, icon: Icons.print,
                                        onTap: () async {
                                      DBhelperContent dBhelperContent =
                                          DBhelperContent();
                                      List pages =
                                          await dBhelperContent.getContentBooks(
                                        'b${book['id']}.sqlite',
                                      );
                                      List<String> textPages = pages
                                          .map((row) => row['_text'].toString())
                                          .toList();
                                      controllerStart.text = 1.toString();
                                      controllerEnd.text =
                                          pages.length.toString();

                                      showPrintDialog(context,
                                          start: controllerStart,
                                          end: controllerEnd,
                                          pages: textPages);
                                    }),
                                    iconItem(context, icon: Icons.qr_code,
                                        onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: CachedNetworkImage(
                                            width: EsaySize.width(context) / 2,
                                            height:
                                                EsaySize.height(context) / 3,
                                            imageUrl:
                                                'https://library.yaqoobi.net/upload_list/source/Library/QrCode/book${book['id']}.gif',
                                            placeholder: (context, url) =>
                                                CustomLoading.pulse(context),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      );
                                    }),
                                    iconItem(context,
                                        icon: Icons.picture_as_pdf,
                                        onTap: () async {
                                      var path = await localDirectoryPdf(
                                        'pdf',
                                      );
                                      checkFile(
                                        "${path.path}/${book['id']}.pdf",
                                        exist: () async {
                                          await OpenFile.open(
                                            "${path.path}/${book['id']}.pdf",
                                          );
                                        },
                                        notAvailable: () {
                                          Navigator.push(
                                              context,
                                              DialogRoute(
                                                context: context,
                                                builder: (context) =>
                                                    DownloadUrl(
                                                  id: book['id'],
                                                  url: book['pdf'],
                                                  downloadPath: 'pdf',
                                                ),
                                              ));
                                        },
                                      );
                                    },
                                        color: book['pdf'] == ''
                                            ? Colors.grey.shade400
                                            : Colors.white),
                                    iconItem(context,
                                        icon: Icons.volume_up,
                                        color:
                                            book['sound_url'].toString().isEmpty
                                                ? Colors.grey.shade400
                                                : Colors.white, onTap: () {
                                      print(book['sound_url']);
                                    }),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Tooltip(
                                          padding: const EdgeInsets.all(8.0),
                                          showDuration:
                                              const Duration(minutes: 2),
                                          textAlign: TextAlign.right,
                                          message: book['description'],
                                          triggerMode: TooltipTriggerMode.tap,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Theme.of(context)
                                                    .floatingActionButtonTheme
                                                    .backgroundColor),
                                            child: const Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Icon(
                                                Icons.info,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
