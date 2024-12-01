import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';

class LoadedbookPage extends StatelessWidget {
  const LoadedbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Assets.images.tlib.image(),
            Positioned(
                top: -125,
                left: 0,
                child: Assets.images.item.image(width: 140, height: 140)),
            Positioned(
                top: -125,
                left: 0,
                right: 0,
                child: Assets.images.item.image(width: 140, height: 140)),
            Positioned(
                top: -125,
                right: 0,
                child: Assets.images.item.image(width: 140, height: 140)),
            Positioned(
                top: -190,
                right: 6,
                child: Container(
                    alignment: Alignment.centerRight,
                    width: EsaySize.width(context) / 1.5,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .floatingActionButtonTheme
                            .backgroundColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Text(
                        'کتگوری 1',
                        style: TextStyle(color: Colors.white),
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
