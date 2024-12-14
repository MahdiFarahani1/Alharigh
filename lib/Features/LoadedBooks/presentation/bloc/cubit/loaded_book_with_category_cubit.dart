import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/Core/database/db_helper_BookList.dart';
import 'package:meta/meta.dart';

part 'loaded_book_with_category_state.dart';

class LoadedBookCubit extends Cubit<LoadedBookState> {
  LoadedBookCubit() : super(LoadedBookLoading());

  Future<void> fetchDownloadedBooks() async {
    try {
      emit(LoadedBookLoading());
      final dbHelper = DBhelperBookList();
      final downloadedBooks = await dbHelper.getDownloadedItems();

      Map<String, List<Map<String, dynamic>>> grouped = {};
      for (var book in downloadedBooks) {
        // دریافت نام دسته با استفاده از gid
        final categoryNameResult =
            await dbHelper.getGroupBookWithGid(book['gid']);
        String categoryName = categoryNameResult.isNotEmpty
            ? categoryNameResult.first['name']
            : 'نامشخص';

        // گروه‌بندی کتاب‌ها بر اساس نام دسته
        if (!grouped.containsKey(categoryName)) {
          grouped[categoryName] = [];
        }
        grouped[categoryName]!.add(book);
      }

      emit(LoadedBookSuccess(grouped));
    } catch (e) {
      emit(LoadedBookError('خطایی در دریافت داده‌ها رخ داده است.'));
    }
  }
}
