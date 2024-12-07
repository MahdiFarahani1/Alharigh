import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/extensions/widget_ex.dart';
import 'package:flutter_application_1/Features/Search/presentation/search.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class AppbarHome extends StatelessWidget {
  const AppbarHome({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _textEditingController =
        TextEditingController();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width / 1.4,
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context)
                    .floatingActionButtonTheme
                    .backgroundColor!),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: TextField(
              onSubmitted: (value) {
                onSearch(context, query: _textEditingController.text);
              },
              controller: _textEditingController,
              cursorColor:
                  Theme.of(context).floatingActionButtonTheme.backgroundColor,
              decoration: InputDecoration(
                  disabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.all(8),
                  suffixIcon: ZoomTapAnimation(
                    onTap: () {
                      onSearch(context, query: _textEditingController.text);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .floatingActionButtonTheme
                              .backgroundColor!),
                      child: SvgPicture.asset(
                        Assets.images.search,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                  hintText: "جستجو...",
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.grey)),
            ),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        ZoomTapAnimation(
          onTap: () {
            Scaffold.of(context).openEndDrawer();
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color:
                  Theme.of(context).floatingActionButtonTheme.backgroundColor!,
            ),
            child: SvgPicture.asset(
              Assets.images.menu,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ).padAll(14),
          ),
        )
      ],
    );
  }

  void onSearch(BuildContext context, {required String query}) {
    if (query.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(
              searchQuery: query,
            ),
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        showCloseIcon: true,
        content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text('فیلد جستجو نمی تواند خالی باشد!')),
        backgroundColor: Colors.red,
      ));
    }
  }
}
