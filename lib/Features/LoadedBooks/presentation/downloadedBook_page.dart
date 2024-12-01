import 'package:flutter/material.dart';

class DownloadedBookListPage extends StatelessWidget {
  const DownloadedBookListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final books = [
      {
        'title': 'فقه الخلف - طرق ثبوت الهلال 4',
        'image': 'assets/book_cover.png', // جایگزین کنید با مسیر تصویر
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
        'image': 'assets/book_cover.png', // جایگزین کنید با مسیر تصویر
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
        'image': 'assets/book_cover.png', // جایگزین کنید با مسیر تصویر
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
        'image': 'assets/life_story.png', // جایگزین کنید با مسیر تصویر
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
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book['title'].toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: (book['actions'] as List<IconData>)
                              .map<Widget>((icon) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(icon),
                                color: Colors.grey[600],
                                iconSize: 24,
                              ),
                            );
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
