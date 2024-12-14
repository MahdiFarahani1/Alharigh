part of 'loaded_book_with_category_cubit.dart';

abstract class LoadedBookState {}

class LoadedBookLoading extends LoadedBookState {}

class LoadedBookSuccess extends LoadedBookState {
  final Map<String, List<Map<String, dynamic>>> groupedBooks;

  LoadedBookSuccess(this.groupedBooks);
}

class LoadedBookError extends LoadedBookState {
  final String message;

  LoadedBookError(this.message);
}
