import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/Core/database/db_helper_BookList.dart';

class BookAllListDataCubit extends Cubit<List<Map<String, dynamic>>> {
  BookAllListDataCubit() : super([]);

  Future<void> updateList() async {
    final updatedBooks = await DBhelperBookList().getAllBooks();
    emit(updatedBooks);
  }
}
