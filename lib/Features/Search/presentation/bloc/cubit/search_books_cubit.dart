import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/Core/database/db_helper_BookList.dart';
import 'package:flutter_application_1/Core/database/db_helper_content.dart';
import 'package:flutter_application_1/Features/Search/presentation/bloc/cubit/status_search.dart';

part 'search_books_state.dart';

class SearchBooksCubit extends Cubit<SearchBooksState> {
  SearchBooksCubit() : super(SearchBooksState(status: SearchInit()));

  searchData(String dbName, String query, bool searchInTitle, bool searchInText,
      int idbook) async {
    emit(SearchBooksState(status: SearchLoading()));
    DBhelperContent dBhelperContent = DBhelperContent();
    DBhelperBookList dBhelperBookList = DBhelperBookList();
    List<Map<String, dynamic>> books =
        await dBhelperBookList.getDownloadedItems();
    try {
      if (idbook == 0) {
        List<Map<String, dynamic>> allBookData = [];

        for (var book in books) {
          final data = await dBhelperContent.searchBooks(
              'b${book['id']}.sqlite', query, searchInTitle, searchInText);
          if (data.isNotEmpty) {
            allBookData.add(book);
          }
        }
        emit(SearchBooksState(status: SearchSuccess(data: allBookData)));
      } else {
        final data = await dBhelperContent.searchBooks(
            dbName, query, searchInTitle, searchInText);
        emit(SearchBooksState(status: SearchSuccess(data: data)));
      }
    } catch (e) {
      if (kDebugMode) {
        print("________________$e _________________");
      }
      emit(SearchBooksState(status: SearchError()));
    }
  }
}
