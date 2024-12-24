import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:bottom_bar_matu/bottom_bar_label_slide/bottom_bar_label_slide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Features/Home/presentation/bloc/cubit/nav_bar_cubit.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBarHome extends StatelessWidget {
  const NavBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomBarLabelSlide(
      selectedIndex: 4,
      color: Theme.of(context).floatingActionButtonTheme.backgroundColor!,
      items: [
        BottomBarItem(
            iconBuilder: (color) => SvgPicture.asset(
                  Assets.images.bookmarkhome,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
            label: 'اشارات'),
        BottomBarItem(
            iconBuilder: (color) => SvgPicture.asset(
                  Assets.images.listCheck,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
            label: 'کتاب'),
        BottomBarItem(
            iconBuilder: (color) => SvgPicture.asset(
                  Assets.images.book,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
            label: 'کتب'),
        BottomBarItem(
            iconBuilder: (color) => SvgPicture.asset(
                  Assets.images.download,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
            label: 'تحمیل'),
        BottomBarItem(
            iconBuilder: (color) => SvgPicture.asset(
                  Assets.images.menu,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
            label: 'تصانیف'),
      ],
      onSelect: (index) {
        context.read<NavBarCubit>().onChangeNavBar(index);
      },
    );
  }
}
