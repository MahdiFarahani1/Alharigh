import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/common/common_diolog.dart';
import 'package:flutter_application_1/Core/database/db_helper_BookList.dart';
import 'package:flutter_application_1/Core/database/db_helper_Content.dart';
import 'package:flutter_application_1/Core/extensions/method_ex.dart';
import 'package:flutter_application_1/Core/utils/directory_app.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/Core/utils/loading.dart';
import 'package:flutter_application_1/Core/widgets/icon.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/content_page.dart';
import 'package:flutter_application_1/Features/DownloadPanel/presentation/download_url.dart';
import 'package:flutter_application_1/Features/LoadedBooks/repository/dialog%20_printer.dart';
import 'package:open_file/open_file.dart';

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
                                  book.getFormattedTitle(),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  maxLines: 2,
                                  textDirection: TextDirection.rtl,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomIcon.iconItem(context,
                                        icon: Icons.delete, onTap: () async {
                                      CustomDialog.showDeleteDilog(
                                        context,
                                        onTap: () async {
                                          await DBhelperBookList()
                                              .updateDownload(book['id'], 0);
                                          deleteFile('b${book['id']}.zip');
                                          deleteFile('b${book['id']}.jpg');
                                          deleteFile('b${book['id']}.sqlite');
                                          setState(() {});
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    }),
                                    CustomIcon.iconItem(context,
                                        icon: Icons.print, onTap: () async {
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
                                    CustomIcon.iconItem(context,
                                        icon: Icons.qr_code, onTap: () {
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
                                    CustomIcon.iconItem(context,
                                        icon: Icons.picture_as_pdf,
                                        onTap: () async {
                                      var path = await localDirectory(
                                        'pdf',
                                      );
                                      checkFile(
                                        "${path.path}/${book['id']}.pdf",
                                        exist: () async {
                                          await OpenFile.open(
                                            "${path.path}/${book['id']}.pdf",
                                          );
                                        },
                                        notAvailable: () async {
                                          final booksDir =
                                              await localDirectory('pdf');

                                          final filePath =
                                              '${booksDir.path}/${book['id']}.pdf';
                                          Navigator.push(
                                              context,
                                              DialogRoute(
                                                context: context,
                                                builder: (context) =>
                                                    DownloadUrl(
                                                  id: book['id'],
                                                  url: book['pdf'],
                                                  downloadPath: 'pdf',
                                                  filePath: filePath,
                                                ),
                                              ));
                                        },
                                      );
                                    },
                                        color: book['pdf'] == ''
                                            ? Colors.grey.shade400
                                            : Colors.white),
                                    CustomIcon.iconItem(context,
                                        icon: Icons.volume_up,
                                        color: book['sound_url']
                                                .toString()
                                                .isEmpty
                                            ? Colors.grey.shade400
                                            : Colors.white, onTap: () async {
                                      final booksDir =
                                          await localDirectory('sound');

                                      final filePath =
                                          '${booksDir.path}/${book['id']}.mp3';
                                      Navigator.push(
                                          context,
                                          DialogRoute(
                                            context: context,
                                            builder: (context) => DownloadUrl(
                                              id: book['id'],
                                              url: book['sound_url'],
                                              downloadPath: 'sound',
                                              filePath: filePath,
                                            ),
                                          ));
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
}
