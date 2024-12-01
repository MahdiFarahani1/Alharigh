import 'package:flutter/material.dart';
import 'package:flutter_application_1/Features/Home/presentation/bloc/cubit/nav_bar_cubit.dart';
import 'package:flutter_application_1/Features/Home/presentation/widgets/appBar.dart';
import 'package:flutter_application_1/Features/Home/presentation/widgets/drawer.dart';
import 'package:flutter_application_1/Features/Home/presentation/widgets/navBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: AppBar(
        elevation: 12,
        title: const AppbarHome(),
        leadingWidth: 0,
        actions: const [
          SizedBox(
            width: 0,
            height: 0,
          )
        ],
      ),
      body: BlocBuilder<NavBarCubit, int>(
        builder: (context, state) {
          final cubit = context.read<NavBarCubit>();
          return cubit.getCurrentSliver(state);
        },
      ),
      bottomNavigationBar: const NavBarHome(),
    );
  }
}
