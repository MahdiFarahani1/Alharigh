import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/database/db_helper_BookList.dart';
import 'package:flutter_application_1/Core/extensions/method_ex.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/Core/utils/loading.dart';
import 'package:flutter_application_1/Core/utils/remove_html_tags.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/content_page.dart';
import 'package:flutter_application_1/Features/Search/presentation/bloc/cubit/search_books_cubit.dart';
import 'package:flutter_application_1/Features/Search/presentation/bloc/cubit/status_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

// ignore: must_be_immutable
class SearchPage extends StatefulWidget {
  String searchQuery;

  SearchPage({super.key, required this.searchQuery});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  int selectedIndex = 0;
  bool titleBool = true, contentBool = true, kolBool = true;
  int idbook = 0;
  String bookname = '';
  late List<bool> listbool;
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    BlocProvider.of<SearchBooksCubit>(context).searchData(
        'b$idbook.sqlite', widget.searchQuery, titleBool, contentBool, idbook);
    DBhelperBookList().getDownloadedItems().then(
      (value) {
        listbool = List.generate(
          value.length,
          (index) => false,
        );
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("البحث"),
          centerTitle: true,
        ),
        body: body(context),
      ),
    );
  }

  Padding body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("بحث بسيط"),
                SizedBox(),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text("العنوان"),
                    value: titleBool,
                    onChanged: (newValue) {
                      setState(() {
                        titleBool = newValue!;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Expanded(
                  child: StatefulBuilder(builder: (context, setStateContent) {
                    return CheckboxListTile(
                      title: const Text("النص"),
                      value: contentBool,
                      onChanged: (newValue) {
                        setStateContent(() => contentBool = newValue!);
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                ),
              ],
            ),
            TextField(
              controller: _textEditingController,
              onSubmitted: (value) {
                BlocProvider.of<SearchBooksCubit>(context).searchData(
                    'b$idbook.sqlite',
                    _textEditingController.text,
                    titleBool,
                    contentBool,
                    idbook);
              },
              decoration: InputDecoration(
                prefixIcon: ZoomTapAnimation(
                    onTap: () {
                      BlocProvider.of<SearchBooksCubit>(context).searchData(
                          'b$idbook.sqlite',
                          _textEditingController.text,
                          titleBool,
                          contentBool,
                          idbook);
                    },
                    child: const Card(
                        color: Colors.black12, child: Icon(Icons.search))),
              ),
              onChanged: (value) {
                setState(() {
                  widget.searchQuery = value;
                });
              },
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: DBhelperBookList().getDownloadedItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CustomLoading.pulse(context);
                } else if (snapshot.hasError) {
                  return const Text("خطا در بارگذاری داده‌ها");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("هیچ کتابی یافت نشد");
                } else {
                  return Container(
                    margin: const EdgeInsets.all(8),
                    width: EsaySize.width(context),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: StatefulBuilder(
                      builder: (context, setStateWheel) {
                        return ListTile(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: AlertDialog(
                                    title: const Text('انتخاب کتگوری'),
                                    content: SizedBox(
                                      width: double.maxFinite,
                                      height: 300,
                                      child: StatefulBuilder(
                                        builder: (context, setStateDialog) {
                                          return ListView.builder(
                                            itemCount:
                                                snapshot.data!.length + 1,
                                            itemBuilder: (context, index) {
                                              if (index == 0) {
                                                return CheckboxListTile(
                                                  value: kolBool,
                                                  title: const Text('الكل',
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      kolBool = value!;
                                                      idbook = 0;
                                                      bookname = '';
                                                      if (kolBool) {
                                                        listbool =
                                                            List.generate(
                                                                snapshot.data!
                                                                    .length,
                                                                (_) => false);
                                                      }
                                                    });
                                                    setStateDialog(() {});
                                                  },
                                                );
                                              }

                                              var e = snapshot.data![index - 1];
                                              bool havePart = e['joz'] != 0;

                                              return CheckboxListTile(
                                                value: listbool[index - 1],
                                                title: Text(
                                                  havePart
                                                      ? '${e['title']} الجزء ${e['joz']}'
                                                      : '${e['title']}',
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    listbool = List.generate(
                                                        snapshot.data!.length,
                                                        (i) {
                                                      if (i == index - 1) {
                                                        return true;
                                                      } else {
                                                        return false;
                                                      }
                                                    });

                                                    kolBool = false;
                                                    idbook = snapshot
                                                        .data![index - 1]['id'];
                                                    bookname = snapshot
                                                            .data![index - 1]
                                                        ['title'];
                                                  });
                                                  setStateDialog(() {});
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          title: const Text('کتگوری سرچ'),
                          trailing: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            BlocBuilder<SearchBooksCubit, SearchBooksState>(
              builder: (context, state) {
                if (state.status is SearchSuccess) {
                  final data = (state.status as SearchSuccess).data;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                            "نتائج البحث عن <${widget.searchQuery}> ${data.length} نتيجة"),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          String withoutTagText =
                              removeHtmlTags(data[index]['_text'] ?? '');
                          bool havePart = data[index]['joz'] != 0 &&
                              data[index].containsKey('joz');
                          String? title = havePart
                              ? '${data[index]['title']} الجزء ${data[index]['joz']}'
                              : '${data[index]['title'] ?? withoutTagText.cutString(30)}';
                          return SearchResultWidget(
                              result: SearchResult(
                                  onTap: () {
                                    if (idbook == 0) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ContentPage(
                                                soundUrl: data[index]
                                                        ['sound_url'] ??
                                                    '',
                                                id: data[index]['id'],
                                                bookName: data[index]['title'],
                                                scrollPosetion: 1),
                                          ));
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ContentPage(
                                                soundUrl: data[index]
                                                        ['sound_url'] ??
                                                    '',
                                                id: idbook,
                                                bookName: bookname,
                                                scrollPosetion: double.parse(
                                                    data[index]['page'])),
                                          ));
                                    }
                                  },
                                  count: idbook == 0
                                      ? data[index]['id']
                                      : int.parse(data[index]['page']),
                                  title: title));
                        },
                      ),
                    ],
                  );
                }
                if (state.status is SearchInit) {
                  return const SizedBox();
                }
                if (state.status is SearchError) {
                  return const Text('error');
                }

                if (state.status is SearchLoading) {
                  return Center(
                    child: CustomLoading.fadingCircle(context),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResult {
  final String title;
  final int count;
  final VoidCallback onTap;
  SearchResult({required this.title, required this.count, required this.onTap});
}

class SearchResultWidget extends StatelessWidget {
  final SearchResult result;

  const SearchResultWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          result.onTap();
        },
        leading: const Icon(Icons.description),
        title: Text(result.title),
        trailing: Text(result.count.toString()),
      ),
    );
  }
}
