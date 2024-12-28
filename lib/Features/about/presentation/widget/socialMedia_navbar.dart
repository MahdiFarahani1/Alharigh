import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/Features/about/repository/aboutus_repository.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SoicalNavBar extends StatelessWidget {
  const SoicalNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            ontap: () {
              AboutRepository.launchUrl(AboutRepository.urlYoutube);
            },
          ),
          iconSocial(
            context,
            icon: FontAwesomeIcons.instagram,
            ontap: () {
              AboutRepository.launchUrl(AboutRepository.urlInstagram);
            },
          ),
          iconSocial(
            context,
            icon: FontAwesomeIcons.telegram,
            ontap: () {
              AboutRepository.launchUrl(AboutRepository.urlTelegram);
            },
          ),
          iconSocial(
            context,
            icon: FontAwesomeIcons.facebook,
            ontap: () {
              AboutRepository.launchUrl(AboutRepository.urlFacebook);
            },
          ),
          iconSocial(
            context,
            icon: Icons.email,
            ontap: () {
              AboutRepository.launchUrl(AboutRepository.urlSite);
            },
          ),
          iconSocial(
            context,
            icon: FontAwesomeIcons.whatsapp,
            ontap: () {
              AboutRepository.launchUrl(AboutRepository.urlWhatsapp);
            },
          ),
          iconSocial(
            context,
            icon: FontAwesomeIcons.twitter,
            ontap: () {
              AboutRepository.launchUrl(AboutRepository.urlTwitter);
            },
          ),
        ],
      ),
    );
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
