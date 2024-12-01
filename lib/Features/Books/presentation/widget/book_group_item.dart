import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/extensions/widget_ex.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class BookGroupItem extends StatelessWidget {
  final String title;
  final int valueBook;
  final Function() onTap;
  const BookGroupItem(
      {super.key,
      required this.title,
      required this.valueBook,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: () {
        onTap();
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.center,
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                  color: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                valueBook.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ).padAll(4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
              child: FittedBox(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
