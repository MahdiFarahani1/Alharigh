/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsDatabaseGen {
  const $AssetsDatabaseGen();

  /// File path: assets/database/booklist.sqlite
  String get booklist => 'assets/database/booklist.sqlite';

  /// File path: assets/database/db3.0.sqlite
  String get db30 => 'assets/database/db3.0.sqlite';

  /// List of all assets
  List<String> get values => [booklist, db30];
}

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/AGCBold.ttf
  String get aGCBold => 'assets/fonts/AGCBold.ttf';

  /// File path: assets/fonts/AGCRegular.ttf
  String get aGCRegular => 'assets/fonts/AGCRegular.ttf';

  /// File path: assets/fonts/Al-Jazeera-Arabic-Bold.ttf
  String get alJazeeraArabicBold => 'assets/fonts/Al-Jazeera-Arabic-Bold.ttf';

  /// File path: assets/fonts/Al-Jazeera-Arabic-Regular.ttf
  String get alJazeeraArabicRegular =>
      'assets/fonts/Al-Jazeera-Arabic-Regular.ttf';

  /// File path: assets/fonts/BloombergArabicBetav4-Bold.ttf
  String get bloombergArabicBetav4Bold =>
      'assets/fonts/BloombergArabicBetav4-Bold.ttf';

  /// File path: assets/fonts/BloombergArabicBetav4-Regular.ttf
  String get bloombergArabicBetav4Regular =>
      'assets/fonts/BloombergArabicBetav4-Regular.ttf';

  /// File path: assets/fonts/khalid-art-bold.ttf
  String get khalidArtBold => 'assets/fonts/khalid-art-bold.ttf';

  /// List of all assets
  List<String> get values => [
        aGCBold,
        aGCRegular,
        alJazeeraArabicBold,
        alJazeeraArabicRegular,
        bloombergArabicBetav4Bold,
        bloombergArabicBetav4Regular,
        khalidArtBold
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/book-download.svg
  String get bookDownload => 'assets/images/book-download.svg';

  /// File path: assets/images/book.svg
  String get book => 'assets/images/book.svg';

  /// File path: assets/images/bookmarkhome.svg
  String get bookmarkhome => 'assets/images/bookmarkhome.svg';

  /// File path: assets/images/download.svg
  String get download => 'assets/images/download.svg';

  /// File path: assets/images/item.png
  AssetGenImage get item => const AssetGenImage('assets/images/item.png');

  /// File path: assets/images/list-check.svg
  String get listCheck => 'assets/images/list-check.svg';

  /// File path: assets/images/menu.svg
  String get menu => 'assets/images/menu.svg';

  /// File path: assets/images/search.svg
  String get search => 'assets/images/search.svg';

  /// File path: assets/images/splash.png
  AssetGenImage get splash => const AssetGenImage('assets/images/splash.png');

  /// File path: assets/images/tlib.png
  AssetGenImage get tlib => const AssetGenImage('assets/images/tlib.png');

  /// List of all assets
  List<dynamic> get values => [
        bookDownload,
        book,
        bookmarkhome,
        download,
        item,
        listCheck,
        menu,
        search,
        splash,
        tlib
      ];
}

class $AssetsWebGen {
  const $AssetsWebGen();

  $AssetsWebCssGen get css => const $AssetsWebCssGen();
  $AssetsWebHtmlGen get html => const $AssetsWebHtmlGen();
  $AssetsWebJsGen get js => const $AssetsWebJsGen();
}

class $AssetsWebCssGen {
  const $AssetsWebCssGen();

  /// File path: assets/web/css/bookmark1.png
  AssetGenImage get bookmark1 =>
      const AssetGenImage('assets/web/css/bookmark1.png');

  /// File path: assets/web/css/bookmark2.png
  AssetGenImage get bookmark2 =>
      const AssetGenImage('assets/web/css/bookmark2.png');

  /// File path: assets/web/css/bootstrap.rtl.min.css
  String get bootstrapRtlMin => 'assets/web/css/bootstrap.rtl.min.css';

  /// File path: assets/web/css/mhebooks.css
  String get mhebooks => 'assets/web/css/mhebooks.css';

  /// List of all assets
  List<dynamic> get values => [bookmark1, bookmark2, bootstrapRtlMin, mhebooks];
}

class $AssetsWebHtmlGen {
  const $AssetsWebHtmlGen();

  /// File path: assets/web/html/about1.htm
  String get about1 => 'assets/web/html/about1.htm';

  /// File path: assets/web/html/about2.htm
  String get about2 => 'assets/web/html/about2.htm';

  /// List of all assets
  List<String> get values => [about1, about2];
}

class $AssetsWebJsGen {
  const $AssetsWebJsGen();

  /// File path: assets/web/js/bootstrap.bundle.min.js
  String get bootstrapBundleMin => 'assets/web/js/bootstrap.bundle.min.js';

  /// File path: assets/web/js/jquery-3.5.1.min.js
  String get jquery351Min => 'assets/web/js/jquery-3.5.1.min.js';

  /// File path: assets/web/js/main.js
  String get main => 'assets/web/js/main.js';

  /// List of all assets
  List<String> get values => [bootstrapBundleMin, jquery351Min, main];
}

class Assets {
  Assets._();

  static const $AssetsDatabaseGen database = $AssetsDatabaseGen();
  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsWebGen web = $AssetsWebGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
