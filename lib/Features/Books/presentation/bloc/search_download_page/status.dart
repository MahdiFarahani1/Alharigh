abstract class SearchStatusDonwloadBook {}

class SearchDownloadBookLoading extends SearchStatusDonwloadBook {}

class SearchDownloadBookInit extends SearchStatusDonwloadBook {}

class SearchDownloadBookError extends SearchStatusDonwloadBook {}

class SearchDownloadBookComplete extends SearchStatusDonwloadBook {
  List data;
  SearchDownloadBookComplete({required this.data});
}
