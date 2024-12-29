abstract class BookGroupStatus {}

class LoadedDataBookGroup extends BookGroupStatus {}

class ErrorBookGroup extends BookGroupStatus {
  final String error;
  ErrorBookGroup({required this.error});
}

class LoadingBookGroup extends BookGroupStatus {}
