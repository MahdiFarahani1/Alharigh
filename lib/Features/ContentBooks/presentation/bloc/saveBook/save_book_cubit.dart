import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

class IconCubit extends Cubit<bool> {
  IconCubit() : super(false);

  void toggleIcon(int id) async {
    final prefs = GetStorage();
    bool currentStatus = state;
    await prefs.write('iconStatus$id', !currentStatus);
    emit(!currentStatus);
  }

  Future<void> loadIconStatus(int id) async {
    final prefs = GetStorage();
    emit(prefs.read('iconStatus$id') ?? false);
  }
}
