import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Features/Books/presentation/all_books.dart';
import 'package:flutter_application_1/Features/Books/presentation/bookGroup.dart';

class NavBarCubit extends Cubit<int> {
  NavBarCubit() : super(0);

  List widgets = [
    Container(height: 200, color: Colors.purple),
    Container(height: 200, color: Colors.blue),
    Container(height: 200, color: Colors.pink),
    const AllBooksPage(),
    const GroupsBookPage(),
  ];
  Widget getCurrentSliver(int index) {
    return widgets[index];
  }

  onChangeNavBar(int index) {
    emit(index);
  }
}
