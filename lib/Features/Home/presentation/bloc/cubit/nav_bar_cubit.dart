import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Features/Books/presentation/all_books.dart';
import 'package:flutter_application_1/Features/Books/presentation/bookGroup.dart';
import 'package:flutter_application_1/Features/Favorite/presentation/favorite.dart';
import 'package:flutter_application_1/Features/LoadedBooks/presentation/downloadedBook_page.dart';
import 'package:flutter_application_1/Features/LoadedBooks/presentation/loadedbook_page.dart';

class NavBarCubit extends Cubit<int> {
  NavBarCubit() : super(2);

  List widgets = [
    const FavoritePage(),
    const DownloadedBookListPage(),
    const LoadedBookPage(),
    const AllBooksPage(),
    const GroupsBookPage(),
  ];

  Widget getCurrentPage(int index) {
    return widgets[index];
  }

  onChangeNavBar(int index) {
    emit(index);
  }
}
