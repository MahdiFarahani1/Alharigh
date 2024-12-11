import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/Config/checkInternet/checkInternet.dart';
import 'package:flutter_application_1/Core/database/db_helper_BookList.dart';
import 'package:flutter_application_1/Core/database/db_helper_LastUpdate.dart';
import 'package:flutter_application_1/Features/Books/data/data_source/data_provider.dart';
import 'package:flutter_application_1/Features/Books/data/model/book_list_model.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/categoryApi/status.dart';

part 'book_group_api_state.dart';

class BookGroupApiCubit extends Cubit<BookGroupApiState> {
  BookGroupApiCubit() : super(BookGroupApiState(status: LoadingBookGroup()));

  fetchData() async {
    DBhelperBookList dBhelperBookList = DBhelperBookList();
    emit(BookGroupApiState(status: LoadingBookGroup()));

    var _connection = await CheckConnection().checkInternetConnection();
    if (_connection) {
      try {
        final lastUpdate = await DBhelperLastUpdate().getLastUpdate();

        final response =
            await DataListBookProvider().data(lastUpdate.toString());

        final modelBooks = ModelBooks.fromJson(response);

        for (var element in modelBooks.categories!) {
          await dBhelperBookList.insertOrUpdateCategory(
            fatherId: element.id!,
            title: element.title!,
            idShow: element.idShow!,
            bookCount: element.booksCount!,
          );
        }
        DBhelperLastUpdate().updateLastUpdate(modelBooks.lastUpdate!);
        print(await DBhelperLastUpdate().getLastUpdate());

        emit(BookGroupApiState(status: LoadedDataBookGroup()));
      } catch (e) {
        emit(BookGroupApiState(status: ErrorBookGroup()));
      }
    } else {
      emit(BookGroupApiState(status: LoadedDataBookGroup()));
    }
  }
}
