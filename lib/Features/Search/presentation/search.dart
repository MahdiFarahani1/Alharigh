import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/database/db_helper_BookList.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/Core/utils/loading.dart';
import 'package:flutter_application_1/Features/Search/presentation/bloc/cubit/search_books_cubit.dart';
import 'package:flutter_application_1/Features/Search/presentation/bloc/cubit/status_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  String searchQuery;

  SearchPage({super.key, required this.searchQuery});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  int selectedIndex = 0;
  bool titleBool = true, contentBool = true;
  int idbook = 0;
  final TextEditingController _textEditingController = TextEditingController();

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
                  child: StatefulBuilder(builder: (context, setStateTitle) {
                    return CheckboxListTile(
                      title: const Text("العنوان"),
                      value: titleBool,
                      onChanged: (newValue) {
                        setStateTitle(
                          () => titleBool = newValue!,
                        );
                      },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  }),
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
                    'b${idbook}.sqlite',
                    _textEditingController.text,
                    titleBool,
                    contentBool);
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
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
                  return SizedBox(
                    width: EsaySize.width(context),
                    height: EsaySize.height(context) / 3,
                    child: StatefulBuilder(builder: (context, setStateWheel) {
                      return ListWheelScrollView.useDelegate(
                        itemExtent: 50.0,
                        onSelectedItemChanged: (value) {
                          setStateWheel(
                            () {
                              selectedIndex = value;
                              if (value == 0) {
                                idbook = 0;
                              } else {
                                idbook = snapshot.data![value - 1]['id'];
                              }
                            },
                          );
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            if (index == 0) {
                              return Container(
                                child: Text(
                                  'الکل',
                                  style: TextStyle(
                                      color: selectedIndex == index
                                          ? Colors.black
                                          : Colors.black12),
                                ),
                              );
                            }

                            var e = snapshot.data![index - 1];
                            return Container(
                              child: Text(e['id'].toString(),
                                  style: TextStyle(
                                      color: selectedIndex == index
                                          ? Colors.black
                                          : Colors.black12)),
                            );
                          },
                          childCount: snapshot.data!.length + 1,
                        ),
                      );
                    }),
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
                            "نتائج البحث عن «${widget.searchQuery} 324243 نتيجة"),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Text('data');
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

  SearchResult({required this.title, required this.count});
}

class SearchResultWidget extends StatelessWidget {
  final SearchResult result;

  const SearchResultWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.description),
        title: Text(result.title),
        trailing: Text(result.count.toString()),
      ),
    );
  }
}
