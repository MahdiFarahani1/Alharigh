import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/database/db_helper.dart';
import 'package:flutter_application_1/Core/utils/loading.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/bookGroup/bookgroup_cubit.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/bookGroup/bookgroup_status.dart';
import 'package:flutter_application_1/Features/Books/presentation/widget/book_download_item.dart';
import 'package:flutter_application_1/Features/Books/presentation/widget/book_group_item.dart';
import 'package:flutter_application_1/Features/Books/repository/book_gid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupsBookPage extends StatefulWidget {
  const GroupsBookPage({super.key});

  @override
  State<GroupsBookPage> createState() => _GroupsBookPageState();
}

class _GroupsBookPageState extends State<GroupsBookPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookgroupCubit, BookgroupState>(
      builder: (context, state) {
        if (state.status is BookGroup) {
          return _buildGroupList();
        } else if (state.status is BookContent) {
          return _buildContentList();
        }
        return const Center(child: Text('Unknown State'));
      },
    );
  }

  Widget _buildGroupList() {
    return FutureBuilder<List<dynamic>>(
      future: DBhelperBook().getGroupBooks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CustomLoading.fadingCircle(context));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No groups found'));
        } else {
          final groups = snapshot.data!;
          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              BookValues.fotherId = group['fatherId'];
              return BookGroupItem(
                title: group['name'],
                valueBook: group['rownum'],
                onTap: () {
                  BookValues.fotherId = group['fatherId'];
                  BlocProvider.of<BookgroupCubit>(context).changeState();
                },
              );
            },
          );
        }
      },
    );
  }

  Widget _buildContentList() {
    return FutureBuilder<List<dynamic>>(
      future: DBhelperBook().getGroupBooksContetnt(BookValues.fotherId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CustomLoading.fadingCircle(context));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No content found'));
        } else {
          final content = snapshot.data!;
          return Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 10, bottom: 4),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .floatingActionButtonTheme
                          .backgroundColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      BlocProvider.of<BookgroupCubit>(context).changeState();
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: content.length,
                  itemBuilder: (context, index) {
                    final item = content[index];
                    return BookDownloadItem(
                      title: item['title'],
                      onTap: () {},
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
