import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/common/common_diolog.dart';
import 'package:flutter_application_1/Core/database/db_helper_Content.dart';
import 'package:flutter_application_1/Core/database/db_helper_LastUpdate.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/content_page.dart';
import 'package:flutter_application_1/Features/ContentBooks/repository/modal_comment.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final DBhelperLastUpdate _dbHelper = DBhelperLastUpdate();
  List<Map<String, dynamic>> _itemsFavorite = [];
  List<Map<String, dynamic>> _itemsComments = [];
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final itemsFavorite = await _dbHelper.getDataPageFavorite();
    final itemsComments = await _dbHelper.getComments();
    setState(() {
      _itemsFavorite = itemsFavorite;
      _itemsComments = itemsComments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: 'آیتم‌های ذخیره‌شده'),
                Tab(text: 'بک لیت'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _itemsFavorite.isEmpty
                  ? const Center(
                      child: Text('هیچ آیتمی ذخیره نشده است!'),
                    )
                  : ListView.builder(
                      itemCount: _itemsFavorite.length,
                      itemBuilder: (context, index) {
                        final item = _itemsFavorite[index];
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
                                style: textStyle(),
                              ),
                              subtitle: Text(
                                'شماره صفحه: ${item['idpage']}',
                                style: textStyle(),
                              ),
                              trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () async {
                                    CustomDialog.showDeleteDilog(
                                      context,
                                      onTap: () async {
                                        await DBhelperContent().updateFav(
                                            'b${item['idbook']}.sqlite',
                                            item['idpage']);
                                        _deleteItem(
                                            item['idpage'],
                                            item['idbook'],
                                            item['book_name'],
                                            '');
                                        Navigator.pop(context);
                                      },
                                    );
                                  }),
                            ),
                          ),
                        );
                      },
                    ),
              _itemsComments.isEmpty
                  ? const Center(
                      child: Text('هیچ آیتمی ذخیره نشده است!'),
                    )
                  : ListView.builder(
                      itemCount: _itemsComments.length,
                      itemBuilder: (context, index) {
                        final item = _itemsComments[index];

                        return ZoomTapAnimation(
                            child: Card(
                          color: Theme.of(context)
                              .floatingActionButtonTheme
                              .backgroundColor!
                              .withAlpha(87),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['bookname'],
                                  style: textStyle(),
                                ),
                                EsaySize.gap(4),
                                Text(
                                  'شماره صفحه: ${item['idbook']}',
                                  style: textStyle(),
                                ),
                                EsaySize.gap(4),
                                Text(
                                  'نظر شما: ${item['comment']}',
                                  style: textStyle(),
                                ),
                                EsaySize.gap(4),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: SizedBox(
                                    width: EsaySize.width(context),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              ModalComment.show(context,
                                                  idBook: 0,
                                                  bookname: '',
                                                  idPage: 0,
                                                  id: item['id'],
                                                  updateMode: true);
                                            },
                                            icon: const Icon(Icons.edit)),
                                        IconButton(
                                            onPressed: () {
                                              CustomDialog.showDeleteDilog(
                                                context,
                                                onTap: () {
                                                  DBhelperLastUpdate dbhlper =
                                                      DBhelperLastUpdate();

                                                  dbhlper.deleteComment(
                                                      item['id']);
                                                },
                                              );
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ))
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ));
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }

  TextStyle textStyle() => const TextStyle(color: Colors.white);

  Future<void> _deleteItem(
      int idPage, int idBook, String bookName, String text) async {
    await _dbHelper.insertOrdeletePageFavorite(idPage, idBook, bookName, text);

    _loadItems();
  }
}
