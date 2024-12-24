import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/database/db_helper_LastUpdate.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/content_page.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class FavoriteBook extends StatefulWidget {
  const FavoriteBook({super.key});

  @override
  State<FavoriteBook> createState() => _FavoriteBookState();
}

class _FavoriteBookState extends State<FavoriteBook> {
  final DBhelperLastUpdate _dbHelper = DBhelperLastUpdate();
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await _dbHelper.getDataBookFavorite();
    setState(() {
      _items = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor:
              Theme.of(context).floatingActionButtonTheme.backgroundColor,
          centerTitle: true,
          title: const Text(
            'المفضلة',
            style: TextStyle(color: Colors.white),
          ),
        ),
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
                                scrollPosetion: 0,
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
                          item['bookname'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        // subtitle: Text(
                        //   'شماره صفحه: ${item['idpage']}',
                        //   style: const TextStyle(color: Colors.white),
                        // ),
                        trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () async {
                              // await DBhelperContent().updateFav(
                              //     'b${item['idbook']}.sqlite', item['idpage']);
                              _deleteItem(
                                item['idbook'],
                                item['bookname'],
                              );
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
    int idBook,
    String bookName,
  ) async {
    await _dbHelper.insertOrdeleteBookFavorite(idBook, bookName);
    final prefs = GetStorage();
    prefs.write('iconStatus$idBook', false);

    _loadItems();
  }
}
