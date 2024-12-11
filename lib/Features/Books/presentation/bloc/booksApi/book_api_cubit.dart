import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/Config/checkInternet/checkInternet.dart';
import 'package:flutter_application_1/Core/database/db_helper_BookList.dart';
import 'package:flutter_application_1/Core/database/db_helper_LastUpdate.dart';
import 'package:flutter_application_1/Features/Books/data/data_source/data_provider.dart';
import 'package:flutter_application_1/Features/Books/data/model/book_list_model.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/booksApi/status.dart';

part 'book_api_state.dart';

class BookApiCubit extends Cubit<BookApiState> {
  BookApiCubit() : super(BookApiState(status: LoadingBook()));

  fetchData() async {
    DBhelperBookList dBhelperBookList = DBhelperBookList();
    emit(BookApiState(status: LoadingBook()));

    var _connection = await CheckConnection().checkInternetConnection();
    if (_connection) {
      try {
        final lastUpdate = await DBhelperLastUpdate().getLastUpdate();

        final response =
            await DataListBookProvider().data(lastUpdate.toString());

        final modelBooks = ModelBooks.fromJson(response);

        for (var element in modelBooks.books!) {
          await dBhelperBookList.insertOrUpdateBook(
            id: element.id!,
            title: element.title!,
            idShow: element.idShow!,
            bookCode: element.bookCode!,
            epub: element.epubLink ?? '',
            pdf: element.pdfLink ?? '',
            sound: element.soundUrl ?? '',
            img: element.photoUrl!,
            gid: element.categoryId!,
            scholar: element.scholarName!,
            description: element.description!,
            part: element.part!,
            lastUpdate: element.updatedAt!,
            internationalNumber: element.internationalNumber!,
            writer: element.writerName!,
          );
        }

        emit(BookApiState(status: LoadedDataBook()));
        DBhelperLastUpdate().updateLastUpdate(modelBooks.lastUpdate!);
      } catch (e) {
        emit(BookApiState(status: ErrorBook()));
      }
    } else {
      emit(BookApiState(status: LoadedDataBook()));
    }
  }
}
