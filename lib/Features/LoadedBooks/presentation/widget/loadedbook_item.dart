import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';

class LoadedbookItem extends StatelessWidget {
  final int numberBook; // تعداد کل کتاب‌ها
  final String categoryName;

  const LoadedbookItem(
      {super.key, required this.numberBook, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // تقسیم کتاب‌ها به گروه‌های 3‌تایی برای هر قفسه
    List<List<int>> shelves = [];
    for (var i = 0; i < numberBook; i += 3) {
      shelves.add(List.generate(
          i + 3 > numberBook ? numberBook - i : 3, (index) => i + index));
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
                  width: EsaySize.width(context) / 2,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .floatingActionButtonTheme
                          .backgroundColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8))),
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
                            Assets.images.tlib
                                .image(width: EsaySize.width(context)),
                            Positioned(
                              top: -105,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: shelfBooks.map((bookIndex) {
                                    return Assets.images.item.image(
                                      width: 120,
                                      height: 120,
                                    );
                                  }).toList(),
                                ),
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
