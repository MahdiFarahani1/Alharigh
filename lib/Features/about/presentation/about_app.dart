import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/widgets/simple_appbar.dart';
import 'package:flutter_application_1/Features/about/presentation/widget/html_viewer.dart';
import 'package:flutter_application_1/Features/about/presentation/widget/socialMedia_navbar.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomSimpleAppbar.appbar(context, "حول التطبيق"),
        body: HtmlViewer(
          pathAbout: Assets.web.html.about2,
        ),
        bottomNavigationBar: const SoicalNavBar());
  }
}
