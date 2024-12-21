import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/database/db_helper_content.dart';
import 'package:flutter_application_1/Core/utils/loading.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/bloc/search/search_group_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ContentGroupPage extends StatefulWidget {
  final int id;
  final String bookName;

  const ContentGroupPage({super.key, required this.id, required this.bookName});

  @override
  State<ContentGroupPage> createState() => _ContentGroupPageState();
}

class _ContentGroupPageState extends State<ContentGroupPage> {
  late Future<List<Map<String, dynamic>>> _content;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _content = DBhelperContent().getGroupBooks(
      'b${widget.id}.sqlite',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
        title: Text(
          widget.bookName,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                child: Transform.scale(
                  scale: 0.8,
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'جستجو...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      suffixIcon: ZoomTapAnimation(
                        onTap: () {
                          BlocProvider.of<SearchGroupCubit>(context)
                              .searchWords(_textEditingController.text);
                        },
                        child: Card(
                            color: Theme.of(context)
                                .floatingActionButtonTheme
                                .backgroundColor,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            )),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSubmitted: (value) {
                      BlocProvider.of<SearchGroupCubit>(context)
                          .searchWords(value);
                    },
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _content,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CustomLoading.fadingCircle(context));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('خطا: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('موردی یافت نشد.'));
                    }
                    final data = snapshot.data!;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          child:
                              BlocBuilder<SearchGroupCubit, SearchGroupState>(
                            builder: (context, state) {
                              return ListTile(
                                title: TextHighlight(
                                  text: item['title'],
                                  words: {
                                    state.highlightText: HighlightedWord(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context)
                                                .floatingActionButtonTheme
                                                .backgroundColor))
                                  },
                                ),
                                trailing: Text(item['page'].toString()),
                                onTap: () {},
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
