import 'package:bloc/bloc.dart';

part 'search_group_state.dart';

class SearchGroupCubit extends Cubit<SearchGroupState> {
  SearchGroupCubit() : super(SearchGroupState(highlightText: ''));

  void searchWords(String value) {
    emit(SearchGroupState(highlightText: value));
  }
}
