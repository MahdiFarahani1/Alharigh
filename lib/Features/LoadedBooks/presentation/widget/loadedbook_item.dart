import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/Core/utils/loading.dart';

class LoadedbookItem extends StatelessWidget {
  final int numberBook;
  final String categoryName;
  final List<Map<String, dynamic>> books;

  const LoadedbookItem({
    super.key,
    required this.numberBook,
    required this.categoryName,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    // تقسیم کتاب‌ها به گروه‌های 3‌تایی برای هر قفسه
    List<List<Map<String, dynamic>>> shelves = [];
    for (var i = 0; i < books.length; i += 3) {
      shelves
          .add(books.sublist(i, i + 3 > books.length ? books.length : i + 3));
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40, top: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  alignment: Alignment.centerRight,
                  width: EsaySize.width(context) / 1.5,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .floatingActionButtonTheme
                        .backgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      categoryName,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: EsaySize.width(context),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: shelves.length,
                itemBuilder: (context, index) {
                  final shelfBooks = shelves[index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // تصویر قفسه
                            Image.asset(
                              'assets/images/tlib.png',
                              width: EsaySize.width(context),
                            ),
                            // کتاب‌ها روی قفسه
                            Positioned(
                              top: -105,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 50),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: shelfBooks.map((book) {
                                      return CachedNetworkImage(
                                        imageUrl: book['img'],
                                        width: 100,
                                        height: 120,
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) {
                                          return CustomLoading.pulse(context);
                                        },
                                      );
                                    }).toList()),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
