import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/Core/widgets/simple_appbar.dart';
import 'package:flutter_application_1/Features/about/presentation/widget/html_viewer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class AboutSheykh extends StatelessWidget {
  const AboutSheykh({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomSimpleAppbar.appbar(context, "السيرة الذاتية"),
        body: HtmlViewer(),
        bottomNavigationBar: Container(
          width: EsaySize.width(context),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))),
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              iconSocial(
                context,
                icon: FontAwesomeIcons.squareYoutube,
                ontap: () {},
              ),
              iconSocial(
                context,
                icon: FontAwesomeIcons.instagram,
                ontap: () {},
              ),
              iconSocial(
                context,
                icon: FontAwesomeIcons.telegram,
                ontap: () {},
              ),
              iconSocial(
                context,
                icon: FontAwesomeIcons.facebook,
                ontap: () {},
              ),
              iconSocial(
                context,
                icon: Icons.email,
                ontap: () {},
              ),
              iconSocial(
                context,
                icon: FontAwesomeIcons.whatsapp,
                ontap: () {},
              ),
              iconSocial(
                context,
                icon: FontAwesomeIcons.twitter,
                ontap: () {},
              ),
            ],
          ),
        ));
  }

  iconSocial(BuildContext context,
      {required IconData icon, required VoidCallback ontap}) {
    return ZoomTapAnimation(
      onTap: () {
        ontap();
      },
      child: Card(
        color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
