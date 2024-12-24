import 'package:flutter/material.dart';
import 'package:flutter_application_1/Features/Favorite/presentation/favorite_book.dart';
import 'package:flutter_application_1/Features/Settings/presentation/settings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            DrawerHeader(
              decoration: BoxDecoration(
                color:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ),

            Expanded(
              child: ListView(
                children: [
                  DrawerItem(
                    fontSize: 22,
                    icon: FontAwesomeIcons.house,
                    title: "الصفحة الرئيسية",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  DrawerItem(
                    fontSize: 22,
                    icon: FontAwesomeIcons.newspaper,
                    title: "السيرة الذاتية",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  DrawerItem(
                    fontSize: 22,
                    icon: FontAwesomeIcons.mobileScreen,
                    title: "حول التطبيق",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  DrawerItem(
                    icon: Icons.star,
                    title: "المفضلة",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FavoriteBook(),
                          ));
                    },
                  ),
                  DrawerItem(
                    icon: Icons.settings,
                    title: "الإعدادات",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ));
                    },
                  ),
                  DrawerItem(
                    icon: Icons.share,
                    title: "مشاركة التطبيق",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),

            // Footer Section
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'مكتبة الرحیق المختوم / الإصدار 3.0',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final double fontSize;
  const DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.fontSize = 25,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        size: fontSize,
        icon,
        color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}
