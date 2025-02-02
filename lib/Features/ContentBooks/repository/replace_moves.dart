String replaceMoves(String content) {
  content = content
      .replaceAll('''(عليها السلام)''', '''<span class="AboThar"></span>''');
  content =
      content.replaceAll("(قدس سره)", '''<span class="AboThar"></span>''');
  content = content
      .replaceAll("(صلي الله عليه وآله)", '''<span class="AboThar"></span>''');
  content = content.replaceAll(
      "(صلي الله عليه و آله)", '''<span class="AboThar"></span>''');
  content = content.replaceAll(
      "(صلى الله عليه و آله)", '''<span class="AboThar"></span>''');
  content = content
      .replaceAll("(صلى الله عليه وآله)", '''<span class="AboThar"></span>''');
  content = content
      .replaceAll("(صلي الله عليه وسلم)", '''<span class="AboThar"></span>''');
  content = content.replaceAll(
      "(صلی الله علیه و آله و سلم)", '''<span class="AboThar"></span>''');
  content = content.replaceAll(
      "(صلى الله عليه وآله وسلم)", '''<span class="AboThar"></span>''');
  content = content.replaceAll("(ص)", '''<span class="AboThar"></span>''');

  content =
      content.replaceAll("(عليه السلام)", '''<span class="AboThar"></span>''');
  content =
      content.replaceAll("(رحمه الله)", '''<span class="AboThar"></span>''');
  content = content.replaceAll("(ع)", '''<span class="AboThar"></span>''');
  content = content.replaceAll(
      "(عجل الله تعالي و فرجه)", '''<span class="AboThar"></span>''');
  content =
      content.replaceAll("(قدس سره)", '''<span class="AboThar"></span>''');
  content = content.replaceAll(
      "(عجل الله فرجه الشريف)", '''<span class="AboThar"></span>''');
  content = content.replaceAll(
      "(عجل الله تعالى و فرجه)", '''<span class="AboThar"></span>''');
  content =
      content.replaceAll("(علیه السلام)", '''<span class="AboThar"></span>''');
  content = content
      .replaceAll("(رضي الله عنه)", '''<span class="AboThar"></span>''');
  content = content.replaceAll("﴿", '''<span class="AboThar"></span>''');
  content = content.replaceAll("﴾", '''<span class="AboThar"></span>''');
  content = content.replaceAll("{", '''<span class="AboThar"></span>''');
  content = content.replaceAll("}", '''<span class="AboThar"></span>''');
  return content;
}
