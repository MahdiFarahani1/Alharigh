import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/search_download_page/status.dart';

part 'search_downloaded_book_page_state.dart';

class SearchDownloadedBookPageCubit
    extends Cubit<SearchDownloadedBookPageState> {
  SearchDownloadedBookPageCubit()
      : super(SearchDownloadedBookPageState(status: SearchDownloadBookInit()));

  void search(List<Map<String, dynamic>> list, String query) {
    try {
      emit(SearchDownloadedBookPageState(status: SearchDownloadBookLoading()));

      final filteredList = list
          .where((book) =>
              book['title'] != null &&
              book['title']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();

      if (filteredList.isEmpty) {
        emit(SearchDownloadedBookPageState(
            status: SearchDownloadBookComplete(data: filteredList)));
      } else {
        emit(SearchDownloadedBookPageState(
            status: SearchDownloadBookComplete(data: filteredList)));
      }
    } catch (e) {
      // مدیریت خطا
      emit(SearchDownloadedBookPageState(status: SearchDownloadBookError()));
    }
  }
}
