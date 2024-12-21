import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/Core/utils/loading.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/content_page.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class LoadedbookItem extends StatelessWidget {
  final String categoryName;
  final List<Map<String, dynamic>> books;

  const LoadedbookItem({
    super.key,
    required this.categoryName,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                alignment: Alignment.centerRight,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor!,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    categoryName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: EsaySize.width(context),
            height: EsaySize.height(context) / 3.7,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: books.map((book) {
                bool havePart = book['joz'] != 0;

                return ZoomTapAnimation(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContentPage(
                            id: book['id'],
                            bookName: havePart
                                ? book['title'] +
                                    " " 'الجزء' " " +
                                    book['joz'].toString()
                                : book['title'],
                          ),
                        ));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: book['img'],
                            width: 110,
                            height: 130,
                            fit: BoxFit.fill,
                            placeholder: (context, url) =>
                                CustomLoading.pulse(context),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            havePart
                                ? book['title'] +
                                    " " 'الجزء' " " +
                                    book['joz'].toString()
                                : book['title'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
