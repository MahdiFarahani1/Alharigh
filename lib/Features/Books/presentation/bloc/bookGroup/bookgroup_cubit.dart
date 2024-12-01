import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/bookGroup/bookgroup_status.dart';

part 'bookgroup_state.dart';

class BookgroupCubit extends Cubit<BookgroupState> {
  BookgroupCubit() : super(BookgroupState(status: BookGroup()));

  changeState() {
    if (state.status is BookGroup) {
      emit(BookgroupState(status: BookContent()));
    } else {
      emit(BookgroupState(status: BookGroup()));
    }
  }
}
