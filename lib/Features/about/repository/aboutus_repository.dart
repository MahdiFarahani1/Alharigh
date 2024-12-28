import 'package:url_launcher/url_launcher_string.dart';

class AboutRepository {
  static const String urlYoutube = "https://www.youtube.com/c/alyqoobi";
  static const String urlTwitter = "https://twitter.com/NewsAlyaqoobi";
  static const String urlTelegram = "https://yaqoobioffice.t.me";
  static const String urlFacebook = "https://www.facebook.com/news.alyaqoobi";
  static const String urlInstagram = "https://www.instagram.com/yaqoobi_com/";
  static const String urlSite = "https://yaqoobi@yaqoobi.com/";
  static const String urlWhatsapp =
      "https://api.whatsapp.com/send/?phone=9647519833704&text&type=phone_number&app_absent=0";

  static Future<void> launchUrl(String url) async {
    await launchUrlString(url);
  }
}
