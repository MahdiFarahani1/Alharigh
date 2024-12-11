import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/database/db_helper_BookList.dart';
import 'package:flutter_application_1/Core/utils/loading.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/booksApi/book_api_cubit.dart';
import 'package:flutter_application_1/Features/Books/presentation/widget/book_download_item.dart';
import 'package:flutter_application_1/Features/DownloadPanel/presentation/download_panel.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class AllBooksPage extends StatefulWidget {
  const AllBooksPage({super.key});

  @override
  State<AllBooksPage> createState() => _AllBooksPageState();
}

class _AllBooksPageState extends State<AllBooksPage> {
  @override
  void initState() {
    BlocProvider.of<BookApiCubit>(context).fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContentList();
  }

  Widget _buildContentList() {
    return FutureBuilder<List<dynamic>>(
      future: DBhelperBookList().getAllBooks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CustomLoading.fadingCircle(context));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No content found'));
        } else {
          final content = snapshot.data!;
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                width: 160,
                height: 40,
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .floatingActionButtonTheme
                        .backgroundColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 12, top: 2, bottom: 2),
                      child: SvgPicture.asset(
                        Assets.images.download,
                        color: Colors.white,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Text(
                        'دانلود همه',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: content.length,
                  itemBuilder: (context, index) {
                    final item = content[index];

                    bool havePart = item['joz'] != 0;

                    return BookDownloadItem(
                      title: havePart
                          ? item['title'] +
                              " " 'الجزء' " " +
                              item['joz'].toString()
                          : item['title'],
                      onTap: () {
                        Navigator.push(
                            context,
                            DialogRoute(
                              context: context,
                              builder: (context) => DownloadPanel(
                                fileName: 'cc',
                                url:
                                    'https://yaqoobi.com/arabic/files.php?force&file=new-books/pdf/2022/dyat-alkatl.pdf',
                                id: item['id'],
                              ),
                            ));
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
