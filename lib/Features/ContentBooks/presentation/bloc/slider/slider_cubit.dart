import 'package:bloc/bloc.dart';

part 'slider_state.dart';

class SliderCubit extends Cubit<SliderState> {
  SliderCubit() : super(SliderState(currentPage: 1));
  onChangeState(double value) {
    emit(SliderState(currentPage: value));
  }
}
