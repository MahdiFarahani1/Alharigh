abstract class StatusSearch {}

class SearchInit extends StatusSearch {}

class SearchLoading extends StatusSearch {}

class SearchError extends StatusSearch {}

class SearchSuccess extends StatusSearch {
  List<Map<String, dynamic>> data;
  SearchSuccess({required this.data});
}
