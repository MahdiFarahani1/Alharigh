import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/Core/database/db_helper_content.dart';
import 'package:flutter_application_1/Features/Search/presentation/bloc/cubit/status_search.dart';

part 'search_books_state.dart';

class SearchBooksCubit extends Cubit<SearchBooksState> {
  SearchBooksCubit() : super(SearchBooksState(status: SearchInit()));

  searchData(
    String dbName,
    String query,
    bool searchInTitle,
    bool searchInText,
  ) async {
    emit(SearchBooksState(status: SearchLoading()));
    try {
      DBhelperContent dBhelperContent = DBhelperContent();

      final data = await dBhelperContent.searchBooks(
          dbName, query, searchInTitle, searchInText);
      emit(SearchBooksState(status: SearchSuccess(data: data)));
    } catch (e) {
      print("________________$e _________________");
      emit(SearchBooksState(status: SearchError()));
    }
  }
}
