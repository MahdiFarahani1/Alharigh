import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/constant/api_const.dart';
import 'package:flutter_application_1/Core/extensions/method_ex.dart';
import 'package:flutter_application_1/Core/utils/loading.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/allbookList/book_all_list_data_cubit.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/booksApi/book_api_cubit.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/search_download_page/search_downloaded_book_page_cubit.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/search_download_page/status.dart';
import 'package:flutter_application_1/Features/Books/presentation/widget/book_download_item.dart';
import 'package:flutter_application_1/Features/DownloadPanel/presentation/download_book.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class AllBooksPage extends StatefulWidget {
  const AllBooksPage({super.key});

  @override
  State<AllBooksPage> createState() => _AllBooksPageState();
}

class _AllBooksPageState extends State<AllBooksPage> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    BlocProvider.of<BookApiCubit>(context).fetchData();
    BlocProvider.of<BookAllListDataCubit>(context).updateList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SearchDownloadedBookPageCubit(),
        ),
      ],
      child: _buildContentList(),
    );
  }

  Widget _buildContentList() {
    return BlocBuilder<BookAllListDataCubit, List<Map<String, dynamic>>>(
        builder: (context, state) {
      return Column(
        children: [
          Row(
            children: [
              downloadAllBtn(state, context),
              textFeildSearch(context, state),
            ],
          ),
          BlocBuilder<SearchDownloadedBookPageCubit,
              SearchDownloadedBookPageState>(
            builder: (context, stateSearch) {
              if (stateSearch.status is SearchDownloadBookLoading) {
                return Center(
                  child: CustomLoading.fadingCircle(context),
                );
              }
              if (stateSearch.status is SearchDownloadBookError) {
                return const Center(
                  child: Text('error'),
                );
              }
              if (stateSearch.status is SearchDownloadBookInit) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.length,
                    itemBuilder: (context, index) {
                      final item = state[index];

                      return BookDownloadItem(
                        isDownloaded: false,
                        title: item.getFormattedTitle(),
                        onTap: () async {
                          Navigator.push(
                              context,
                              DialogRoute(
                                context: context,
                                builder: (context) => DownloadBook(
                                  downloadPath: '${item['id']}.zip',
                                  url: ApiConstant.downloadUrl +
                                      item['id'].toString(),
                                  id: item['id'],
                                ),
                              ));
                        },
                      );
                    },
                  ),
                );
              }
              if (stateSearch.status is SearchDownloadBookComplete) {
                List searchData =
                    (stateSearch.status as SearchDownloadBookComplete).data;
                return Expanded(
                  child: ListView.builder(
                    itemCount: searchData.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> item = searchData[index];

                      return BookDownloadItem(
                        isDownloaded: false,
                        title: item.getFormattedTitle(),
                        onTap: () async {
                          Navigator.push(
                              context,
                              DialogRoute(
                                context: context,
                                builder: (context) => DownloadBook(
                                  downloadPath: '${item['id']}.zip',
                                  url: ApiConstant.downloadUrl +
                                      item['id'].toString(),
                                  id: item['id'],
                                ),
                              ));
                        },
                      );
                    },
                  ),
                );
              }
              return const SizedBox();
            },
          )
        ],
      );
    });
  }

  Widget textFeildSearch(
      BuildContext context, List<Map<String, dynamic>> state) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 40,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: TextField(
              controller: _textEditingController,
              onSubmitted: (value) {
                BlocProvider.of<SearchDownloadedBookPageCubit>(context)
                    .search(state, _textEditingController.text);
              },
              decoration: InputDecoration(
                prefixIcon: ZoomTapAnimation(
                  onTap: () {
                    BlocProvider.of<SearchDownloadedBookPageCubit>(context)
                        .search(state, _textEditingController.text);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .floatingActionButtonTheme
                            .backgroundColor,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8))),
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                ),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget downloadAllBtn(
      List<Map<String, dynamic>> state, BuildContext context) {
    return ZoomTapAnimation(
      onTap: () {
        downloadBooksSequentially(state, context);
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 160,
        height: 40,
        decoration: BoxDecoration(
            color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 2, bottom: 2),
              child: SvgPicture.asset(
                Assets.images.download,
                color: Colors.white,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Text(
                'تحميل الكل',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> downloadBooksSequentially(
      List<Map<String, dynamic>> state, BuildContext context) async {
    for (var book in state) {
      await Navigator.push(
        context,
        DialogRoute(
          context: context,
          builder: (context) => DownloadBook(
            downloadPath: '${book['id']}.zip',
            url: ApiConstant.downloadUrl + book['id'].toString(),
            id: book['id'],
          ),
        ),
      );

      print("Download for book ${book['id']} finished.");
    }

    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
