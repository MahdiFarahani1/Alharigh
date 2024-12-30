import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/Core/database/db_helper_BookList.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit() : super(AudioState(haveSound: false));

  Future<void> checkHaveSound(int bookId) async {
    DBhelperBookList _dbHelper = DBhelperBookList();

    try {
      final List<Map<String, dynamic>> downloadedBooks =
          await _dbHelper.getDownloadedItems();

      final hasSound = downloadedBooks.any((book) =>
          book['id'] == bookId && book['sound']?.toString().isNotEmpty == true);

      emit(AudioState(haveSound: hasSound));
    } catch (e) {
      emit(AudioState(haveSound: false));
    }
  }
}
