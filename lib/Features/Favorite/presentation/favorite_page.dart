import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/common/common_diolog.dart';
import 'package:flutter_application_1/Core/database/db_helper_Content.dart';
import 'package:flutter_application_1/Core/database/db_helper_LastUpdate.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/Core/utils/loading.dart';
import 'package:flutter_application_1/Core/widgets/icon.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/content_page.dart';
import 'package:flutter_application_1/Features/ContentBooks/repository/modal_comment.dart';
import 'package:flutter_application_1/Features/Favorite/presentation/bloc/List_Custom/list_custom_items_cubit.dart';
import 'package:flutter_application_1/Features/Favorite/presentation/bloc/List_Custom/status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListCustomItemsCubit()..fetchDoubleData(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'الاشارات المرجعية'),
                  Tab(text: 'التعليقات'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                BlocBuilder<ListCustomItemsCubit, ListCustomItemsState>(
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
                    if (state.status is DoubleListComplete) {
                      final pages = (state.status as DoubleListComplete).data1;
                      return pages.isEmpty
                          ? const Center(
                              child: Text('لم يتم اضافة اي شئ بعد'),
                            )
                          : ListView.builder(
                              itemCount: pages.length,
                              itemBuilder: (context1, index) {
                                final item = pages[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ContentPage(
                                              scrollPosetion:
                                                  item['idpage'].toDouble(),
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
                                      trailing: CustomIcon.iconItem(context,
                                          color: Colors.redAccent.shade200,
                                          icon: Icons.delete, onTap: () {
                                        CustomDialog.showDeleteDilog(
                                          context,
                                          onTap: () {
                                            DBhelperContent().updateFav(
                                                'b${item['idbook']}.sqlite',
                                                item['idpage']);
                                            DBhelperLastUpdate()
                                                .insertOrdeletePageFavorite(
                                                    item['idpage'],
                                                    item['idbook'],
                                                    item['book_name'],
                                                    '');

                                            Navigator.pop(context);
                                            BlocProvider.of<
                                                        ListCustomItemsCubit>(
                                                    context)
                                                .fetchDoubleData();
                                          },
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
                BlocBuilder<ListCustomItemsCubit, ListCustomItemsState>(
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
                    if (state.status is DoubleListComplete) {
                      final comments =
                          (state.status as DoubleListComplete).data2;

                      return comments.isEmpty
                          ? const Center(
                              child: Text('لم يتم اضافة اي شئ بعد'),
                            )
                          : ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                final item = comments[index];

                                return ZoomTapAnimation(
                                    child: Card(
                                  color: Theme.of(context)
                                      .floatingActionButtonTheme
                                      .backgroundColor!
                                      .withAlpha(87),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                CustomIcon.iconItem(context,
                                                    icon: Icons.edit,
                                                    onTap: () {
                                                  ModalComment.show(context,
                                                      idBook: 0,
                                                      bookname: '',
                                                      idPage: 0,
                                                      id: item['id'],
                                                      updateMode: true);
                                                }),
                                                CustomIcon.iconItem(context,
                                                    color: Colors
                                                        .redAccent.shade200,
                                                    icon: Icons.delete,
                                                    onTap: () {
                                                  CustomDialog.showDeleteDilog(
                                                    context,
                                                    onTap: () {
                                                      DBhelperLastUpdate
                                                          dbhlper =
                                                          DBhelperLastUpdate();

                                                      dbhlper.deleteComment(
                                                          item['id']);

                                                      Navigator.pop(context);
                                                      BlocProvider.of<
                                                                  ListCustomItemsCubit>(
                                                              context)
                                                          .fetchDoubleData();
                                                    },
                                                  );
                                                }),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                              },
                            );
                    }
                    return const SizedBox.shrink();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle textStyle() => const TextStyle(color: Colors.white);
}
