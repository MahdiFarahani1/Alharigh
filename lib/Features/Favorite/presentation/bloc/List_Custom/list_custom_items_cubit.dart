import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/Features/Favorite/presentation/bloc/List_Custom/status.dart';

part 'list_custom_items_state.dart';

class ListCustomItemsCubit extends Cubit<ListCustomItemsState> {
  ListCustomItemsCubit() : super(ListCustomItemsState(status: ListLoading()));

  fetchData(Future<List<Map<String, dynamic>>> futureData) async {
    emit(ListCustomItemsState(status: ListLoading()));
    try {
      final data = await futureData;
      emit(ListCustomItemsState(status: ListComplete(data: data)));
    } catch (e) {
      emit(ListCustomItemsState(status: ListError()));
    }
  }

  fetchDoubleData(Future<List<Map<String, dynamic>>> futureDataComment,
      Future<List<Map<String, dynamic>>> futureDataFavorite) async {
    emit(ListCustomItemsState(status: ListLoading()));
    try {
      final comments = await futureDataComment;
      final favorite = await futureDataFavorite;

      emit(ListCustomItemsState(
          status: DoubleListComplete(data1: favorite, data2: comments)));
    } catch (e) {
      emit(ListCustomItemsState(status: ListError()));
    }
  }
}
