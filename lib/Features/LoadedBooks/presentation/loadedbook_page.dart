import 'package:flutter/material.dart';
import 'package:flutter_application_1/Features/LoadedBooks/presentation/widget/loadedbook_item.dart';

class LoadedbookPage extends StatelessWidget {
  final List categoryName = [
    'کتگوری اول',
    'کتگوری دوم',
    'کتگوری سوم',
    'کتگوری چهارم',
    'کتگوری پنجم'
  ];

  final List numberBooks = [2, 4, 1, 6, 8];

  LoadedbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          itemCount: numberBooks.length,
          itemBuilder: (context, index) {
            return LoadedbookItem(
                numberBook: numberBooks[index],
                categoryName: categoryName[index]);
          },
        ),
      ),
    );
  }
}
