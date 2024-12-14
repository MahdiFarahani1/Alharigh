import 'package:flutter/material.dart';
import 'package:flutter_application_1/Features/LoadedBooks/presentation/bloc/cubit/loaded_book_with_category_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/Core/utils/loading.dart';
import 'package:flutter_application_1/Features/LoadedBooks/presentation/widget/loadedbook_item.dart';

class LoadedBookPage extends StatelessWidget {
  const LoadedBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoadedBookCubit()..fetchDownloadedBooks(),
      child: Scaffold(
        body: BlocBuilder<LoadedBookCubit, LoadedBookState>(
          builder: (context, state) {
            if (state is LoadedBookLoading) {
              return Center(child: CustomLoading.fadingCircle(context));
            } else if (state is LoadedBookSuccess) {
              final groupedBooks = state.groupedBooks;

              return Directionality(
                textDirection: TextDirection.rtl,
                child: ListView.builder(
                  itemCount: groupedBooks.keys.length,
                  itemBuilder: (context, index) {
                    String categoryName = groupedBooks.keys.elementAt(index);
                    List<Map<String, dynamic>> books =
                        groupedBooks[categoryName]!;

                    return LoadedbookItem(
                      numberBook: books.length,
                      categoryName: categoryName,
                      books: books,
                    );
                  },
                ),
              );
            } else if (state is LoadedBookError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
