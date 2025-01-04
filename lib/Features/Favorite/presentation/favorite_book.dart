import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/database/db_helper_LastUpdate.dart';
import 'package:flutter_application_1/Core/utils/loading.dart';
import 'package:flutter_application_1/Core/widgets/icon.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/content_page.dart';
import 'package:flutter_application_1/Features/Favorite/presentation/bloc/List_Custom/list_custom_items_cubit.dart';
import 'package:flutter_application_1/Features/Favorite/presentation/bloc/List_Custom/status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class FavoriteBook extends StatelessWidget {
  FavoriteBook({super.key});

  final DBhelperLastUpdate _dbHelper = DBhelperLastUpdate();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ListCustomItemsCubit()..fetchData(_dbHelper.getDataBookFavorite()),
      child: Directionality(
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
          body: BlocBuilder<ListCustomItemsCubit, ListCustomItemsState>(
            builder: (context, state) {
              if (state.status is ListError) {
                return const Center(
                  child: Text('المشکل'),
                );
              }
              if (state.status is ListLoading) {
                return Center(
                  child: CustomLoading.fadingCircle(context),
                );
              }
              if (state.status is ListComplete) {
                final data = (state.status as ListComplete).data;
                return data.isEmpty
                    ? const Center(child: Text('لم يتم اضافة اي شئ بعد'))
                    : ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];
                          return ZoomTapAnimation(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ContentPage(
                                        scrollPosetion: 1,
                                        id: item['idbook'],
                                        bookName: item['bookname']),
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
                                trailing: CustomIcon.iconItem(context,
                                    color: Colors.redAccent.shade200,
                                    icon: Icons.delete, onTap: () {
                                  _deleteItem(
                                    context,
                                    item['idbook'],
                                    item['bookname'],
                                  );
                                }),
                              ),
                            ),
                          );
                        },
                      );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Future<void> _deleteItem(
    BuildContext contextBloc,
    int idBook,
    String bookName,
  ) async {
    await _dbHelper.insertOrdeleteBookFavorite(idBook, bookName);
    final prefs = GetStorage();
    prefs.write('iconStatus$idBook', false);
    Navigator.pop(contextBloc);
    BlocProvider.of<ListCustomItemsCubit>(contextBloc)
        .fetchData(_dbHelper.getDataBookFavorite());
  }
}
