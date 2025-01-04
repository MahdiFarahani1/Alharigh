abstract class CustomListStatus {}

class ListComplete extends CustomListStatus {
  List data;
  ListComplete({required this.data});
}

class DoubleListComplete extends CustomListStatus {
  List data1, data2;
  DoubleListComplete({required this.data1, required this.data2});
}

class ListError extends CustomListStatus {}

class ListLoading extends CustomListStatus {}
