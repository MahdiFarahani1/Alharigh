import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/database/db_helper_Content.dart';
import 'package:flutter_application_1/Core/database/db_helper_LastUpdate.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/content_page.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final DBhelperLastUpdate _dbHelper = DBhelperLastUpdate();
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await _dbHelper.getDataPageFavorite();
    setState(() {
      _items = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: _items.isEmpty
            ? const Center(
                child: Text('هیچ آیتمی ذخیره نشده است!'),
              )
            : ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ZoomTapAnimation(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContentPage(
                                scrollPosetion: item['idpage'].toDouble(),
                                id: item['idbook'],
                                bookName: item['book_name']),
                          ));
                    },
                    child: Card(
                      color: Theme.of(context)
                          .floatingActionButtonTheme
                          .backgroundColor!
                          .withAlpha(87),
                      child: ListTile(
                        title: Text(
                          item['book_name'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'شماره صفحه: ${item['idpage']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () async {
                              await DBhelperContent().updateFav(
                                  'b${item['idbook']}.sqlite', item['idpage']);
                              _deleteItem(item['idpage'], item['idbook'],
                                  item['book_name'], '');
                            }),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> _deleteItem(
      int idPage, int idBook, String bookName, String text) async {
    await _dbHelper.insertOrdeletePageFavorite(idPage, idBook, bookName, text);

    _loadItems();
  }
}
