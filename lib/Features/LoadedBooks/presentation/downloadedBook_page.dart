import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/database/db_helper_BookList.dart';
import 'package:flutter_application_1/Core/utils/loading.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class DownloadedBookListPage extends StatelessWidget {
  const DownloadedBookListPage({super.key});

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
                          File(
                              '/storage/emulated/0/Download/Books/${book['id']}.jpg'),
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
                                  iconItem(context,
                                      icon: Icons.delete, onTap: () {}),
                                  iconItem(context,
                                      icon: Icons.print, onTap: () {}),
                                  iconItem(context,
                                      icon: Icons.qr_code, onTap: () {}),
                                  iconItem(context,
                                      icon: Icons.picture_as_pdf, onTap: () {}),
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
      {required IconData icon, required Function onTap}) {
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
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
