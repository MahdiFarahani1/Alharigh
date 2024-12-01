import 'package:flutter/material.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';

class DownloadedBookListPage extends StatelessWidget {
  const DownloadedBookListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final books = [
      {
        'title': 'فقه الخلف - طرق ثبوت الهلال 4',
        'image': Assets.images.item.path,
        'actions': [
          Icons.delete,
          Icons.print,
          Icons.qr_code,
          Icons.picture_as_pdf,
          Icons.volume_up,
        ],
      },
      {
        'title': 'فقه الخلف - الأمر بالمعروف القسم 1 8',
        'image': Assets.images.item.path,
        'actions': [
          Icons.delete,
          Icons.print,
          Icons.qr_code,
          Icons.picture_as_pdf,
          Icons.volume_up,
        ],
      },
      {
        'title': 'فقه الخلف - فقه التلقيح الصناعي 12',
        'image': Assets.images.item.path,
        'actions': [
          Icons.delete,
          Icons.print,
          Icons.qr_code,
          Icons.picture_as_pdf,
          Icons.volume_up,
        ],
      },
      {
        'title': 'لنتسوج من قصص الحياة',
        'image': Assets.images.item.path,
        'actions': [
          Icons.delete,
          Icons.print,
          Icons.qr_code,
          Icons.picture_as_pdf,
          Icons.volume_up,
        ],
      },
    ];

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border(
                    bottom: BorderSide(
                        color: Theme.of(context)
                            .floatingActionButtonTheme
                            .backgroundColor!),
                    right: BorderSide(
                        color: Theme.of(context)
                            .floatingActionButtonTheme
                            .backgroundColor!))),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Image.asset(
                    book['image'].toString(),
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
                          book['title'].toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                          maxLines: 2,
                          textDirection: TextDirection.rtl,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: (book['actions'] as List<IconData>)
                              .map<Widget>((icon) {
                            return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Theme.of(context)
                                          .floatingActionButtonTheme
                                          .backgroundColor),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      icon,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ));
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
