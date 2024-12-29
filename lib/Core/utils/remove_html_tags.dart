String removeHtmlTags(String htmlString) {
  final RegExp tagRegExp =
      RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
  htmlString = htmlString.replaceAll('&nbsp;', ' ');
  htmlString = htmlString.replaceAll('<br />', '\n');

  return htmlString.replaceAll(tagRegExp, '');
}
