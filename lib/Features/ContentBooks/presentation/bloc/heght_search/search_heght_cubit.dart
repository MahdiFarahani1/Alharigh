import 'package:bloc/bloc.dart';

part 'search_heght_state.dart';

class SearchHeghtCubit extends Cubit<SearchHeghtState> {
  SearchHeghtCubit() : super(SearchHeghtState(searchHeght: 0));

  changeState() {
    if (state.searchHeght == 0) {
      emit(SearchHeghtState(searchHeght: 50));
    } else {
      emit(SearchHeghtState(searchHeght: 0));
    }
  }
}
