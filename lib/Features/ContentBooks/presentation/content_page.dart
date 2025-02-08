import 'dart:convert';

import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/enums/tooltip_direction_enum.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:color_hex/color_hex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_application_1/Core/database/db_helper_Content.dart';
import 'package:flutter_application_1/Core/database/db_helper_LastUpdate.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/Core/utils/loading.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/audio_panel.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/bloc/audio/audio_cubit.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/bloc/heght_search/search_heght_cubit.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/bloc/saveBook/save_book_cubit.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/bloc/slider/slider_cubit.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/content_group.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/setting_panel.dart';
import 'package:flutter_application_1/Features/ContentBooks/repository/modal_comment.dart';
import 'package:flutter_application_1/Features/Settings/presentation/bloc/setting_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ContentPage extends StatefulWidget {
  final int id;
  final String bookName;
  final double scrollPosetion;
  final String soundUrl;
  const ContentPage({
    super.key,
    required this.id,
    required this.bookName,
    required this.scrollPosetion,
    this.soundUrl = '',
  });

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  String urlSound = '';
  String fontCss = '';
  late InAppWebViewController inAppWebViewController;
  @override
  void initState() {
    _loadFont();
    super.initState();
  }

  String getFontUriAsBase64(ByteData data, String mime) {
    final buffer = data.buffer;
    return "data:$mime;charset=utf-8;base64,${base64Encode(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes))}";
  }

  Future<void> _loadFont() async {
    // testjs = await rootBundle.loadString('assets/web/css/mhebooks.css');
    String fontfamily = 'assets/fonts/Al-Jazeera-Arabic-Regular.woff2';

    switch (BlocProvider.of<SettingsCubit>(context).state.selectedFont) {
      case 'نسخ':
        fontfamily = 'assets/fonts/Al-Jazeera-Arabic-Regular.woff2';
        break;
      case 'نازنین':
        fontfamily = 'assets/fonts/Noor-Regular.woff2';

        break;
      case 'بهیج':
        fontfamily = 'assets/fonts/BloombergArabicBetav4-Regular.woff2';

        break;
      default:
    }
    final fontData = await rootBundle.load(fontfamily);
    final fontUri = getFontUriAsBase64(fontData, 'font/opentype');
    final fontData1 = await rootBundle.load('assets/fonts/abo.ttf');
    final fontUri1 = getFontUriAsBase64(fontData1, 'font/opentype');
    setState(() {
      fontCss = '''
      @font-face {
        font-family: "${BlocProvider.of<SettingsCubit>(context).state.selectedFont}";
        src: url("$fontUri") format('woff2');
      }
    @font-face {
        font-family: "AboThar";
        src: url("$fontUri1") format('truetype');
      }
      .AboThar{
        font-family: "AboThar" !important;
        color : blue !important;
        font-size: 20px;
      }
      body, p, div, span {
        font-family: "${BlocProvider.of<SettingsCubit>(context).state.selectedFont}" !important;
        direction: rtl;
      }
    ''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SliderCubit()..onChangeState(widget.scrollPosetion),
        ),
        BlocProvider(
          create: (_) => IconCubit()..loadIconStatus(widget.id),
        ),
        BlocProvider(
          create: (_) => AudioCubit()..checkHaveSound(widget.id),
        ),
      ],
      child: Scaffold(
        appBar: appBar(context),
        body: Column(
          children: [
            BlocBuilder<SearchHeghtCubit, SearchHeghtState>(
              builder: (context, state) {
                return AnimatedContainer(
                  duration: Duration(seconds: 1),
                  width: EsaySize.width(context),
                  height: state.searchHeght,
                  color: Colors.red,
                  child: TextField(),
                );
              },
            ),
            FutureBuilder(
              future: DBhelperContent().getContentBooks(
                'b${widget.id}.sqlite',
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CustomLoading.fadingCircle(context),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }

                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  var cubit = BlocProvider.of<SettingsCubit>(context);
                  bool verticalScroll =
                      BlocProvider.of<SettingsCubit>(context).state.axix ==
                          Axis.vertical;
                  String bookPage = verticalScroll
                      ? 'BookPage-vertical book-page-vertical'
                      : 'BookPage-horizontal book-page-horizontal';
                  String bookText = verticalScroll
                      ? 'book_text_vertical'
                      : 'book_text_horizontal';
                  String bookContainer = verticalScroll
                      ? 'book-container-vertical'
                      : 'book-container-horizontal';

                  StringBuffer allTextBuffer = StringBuffer();

                  int pageCount = 0;
                  snapshot.data!.asMap().forEach((i, item) {
                    if (pageCount >= snapshot.data!.length) return;

                    int fav = item['fav'];

                    allTextBuffer.write("""
                      <div class='$bookPage' data-page='$i' style='color: black !important; background-color: ${Color(cubit.state.selectedPageColor).convertToHex.hex} !important;' id='page_$i'>
                        ${fav == 0 ? "<div class='book-mark' id='book-mark_$i'></div>" : "<div class='book-mark add_fav' id='book-mark_$i'></div>"}
                        <div class='comment-button' ></div><span class='page-number'>${i + 1}</span>
                        <br>
                        <div class='$bookText text_style' id='page___$i' style="font-size:${cubit.state.fontSize}px !important; line-height:${cubit.state.lineSpacing}px !important;">
                            <div style='text-align:center;'><img class='pageLoading' src='asset://images/loader.gif'></div>
                        </div>
                      </div>
                    """);

                    pageCount++;
                  });

                  String allText = allTextBuffer.toString();

                  String htmlContent = """
                            <!DOCTYPE html>
                            <html lang="en">
                            <head>
                              <meta charset="UTF-8">
                              <meta name="viewport" content="width=device-width, initial-scale=1.0">
                              <link rel="stylesheet" href="asset://web/css/bootstrap.rtl.min.css">
                              <link rel="stylesheet" href="asset://web/css/mhebooks.css">
                               <style>
                               $fontCss
                              </style>
                            </head>
                            <body onload="replaceContent()" dir="rtl">
                        <div class='$bookContainer'>
                              $allText
                          </div>
            
                           <script src="asset://web/js/jquery-3.5.1.min.js"></script>
                           <script src="asset://web/js/bootstrap.bundle.min.js"></script>
                           <script src="asset://web/js/main.js"></script>
                            </body>
            
                            </html>
                            """;

                  return SizedBox(
                    width: EsaySize.width(context),
                    height: EsaySize.height(context),
                    child: ListView(
                      addAutomaticKeepAlives: true,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection:
                          verticalScroll ? Axis.horizontal : Axis.vertical,
                      children: [
                        SizedBox(
                          width: verticalScroll
                              ? EsaySize.width(context) - 25
                              : EsaySize.width(context),
                          // height: EsaySize.width(context),
                          height: verticalScroll
                              ? EsaySize.height(context)
                              : EsaySize.height(context) - 110,
                          child: InAppWebView(
                            onWebViewCreated: (controller) async {
                              inAppWebViewController = controller;

                              controller.addJavaScriptHandler(
                                handlerName: 'bookmarkToggled',
                                callback: (args) async {
                                  int bookmarkId = args[0] + 1;
                                  await DBhelperContent().updateFav(
                                      'b${widget.id}.sqlite', bookmarkId);

                                  await DBhelperLastUpdate()
                                      .insertOrdeletePageFavorite(bookmarkId,
                                          widget.id, widget.bookName, '');
                                },
                              );
                              controller.addJavaScriptHandler(
                                handlerName: 'CommentEvent',
                                callback: (args) async {
                                  int pageNumber = args[0] + 1;

                                  ModalComment.show(context,
                                      updateMode: false,
                                      id: pageNumber,
                                      idPage: pageNumber,
                                      idBook: widget.id,
                                      bookname: widget.bookName);
                                },
                              );
                            },
                            shouldInterceptRequest:
                                (controller, request) async {
                              String url = request.url.toString();
                              print("Intercepted URL: $url");

                              if (url.startsWith("asset://")) {
                                String assetFileName =
                                    url.replaceFirst("asset://", "");

                                try {
                                  ByteData assetData = await rootBundle
                                      .load("assets/$assetFileName");
                                  Uint8List bytes =
                                      assetData.buffer.asUint8List();
                                  String contentType = "text/plain";

                                  if (assetFileName.endsWith(".css")) {
                                    contentType = "text/css";
                                  } else if (assetFileName.endsWith(".gif")) {
                                    contentType = "image/gif";
                                  }

                                  return WebResourceResponse(
                                    data: bytes,
                                    statusCode: 200,
                                    reasonPhrase: "OK",
                                    contentType: contentType,
                                    headers: {
                                      "Access-Control-Allow-Origin": "*"
                                    },
                                  );
                                } catch (e) {
                                  print("Error loading asset: $e");
                                }
                              }

                              return null;
                            },
                            onLoadStop: (controller, url) async {
                              if (snapshot.data == null) return;

                              final jsonData = jsonEncode(snapshot.data!
                                  .map((item) => item['_text'])
                                  .toList());
                              // String content = item['_text'];
                              // content = content.replaceAll('''(عليها السلام)''',
                              //     '''<span class="AboThar"></span>''');
                              // content = content.replaceAll("(قدس سره)",
                              //     '''<span class="AboThar"></span>''');
                              // content = content.replaceAll("(صلي الله عليه وآله)",
                              //     '''<span class="AboThar"></span>''');
                              // content = content.replaceAll("(صلي الله عليه و آله)",
                              //     '''<span class="AboThar"></span>''');
                              // content = content.replaceAll("(صلى الله عليه و آله)",
                              //     '''<span class="AboThar"></span>''');
                              // content = content.replaceAll("(صلى الله عليه وآله)",
                              //     '''<span class="AboThar"></span>''');
                              // content = content.replaceAll("(صلي الله عليه وسلم)",
                              //     '''<span class="AboThar"></span>''');
                              // content = content.replaceAll(
                              //     "(صلی الله علیه و آله و سلم)",
                              //     '''<span class="AboThar"></span>''');
                              // content = content.replaceAll(
                              //     "(صلى الله عليه وآله وسلم)",
                              //     '''<span class="AboThar"></span>''');
                              // content = content.replaceAll(
                              //     "(ص)", '''<span class="AboThar"></span>''');

                              // content = content.replaceAll("(عليه السلام)",
                              //     '''<span class="AboThar"></span>''');
                              // content = content.replaceAll("(رحمه الله)",
                              //     '''<span class="AboThar"></span>''');
                              // content = content.replaceAll(
                              //     "(ع)", '''<span class="AboThar"></span>''');
                              // content = content.replaceAll(
                              //     "(عجل الله تعالي و فرجه)",
                              //     '''<span class="AboThar"></span>''');
                              // content = content.replaceAll("(قدس سره)",
                              //     '''<span class="AboThar"></span>''');
                              // content = content.replaceAll("(عجل الله فرجه الشريف)",
                              //     '''<span class="AboThar"></span>''');
                              // content = content.replaceAll(
                              //     "(عجل الله تعالى و فرجه)",
                              //     '''<span class="AboThar"></span>''');
                              // content = content.replaceAll("(علیه السلام)",
                              //     '''<span class="AboThar"></span>''');
                              // content = content.replaceAll("(رضي الله عنه)",
                              //     '''<span class="AboThar"></span>''');
                              // content = content.replaceAll(
                              //     "﴿", '''<span class="AboThar"></span>''');
                              // content = content.replaceAll(
                              //     "﴾", '''<span class="AboThar"></span>''');
                              // content = content.replaceAll(
                              //     "{", '''<span class="AboThar"></span>''');
                              // content = content.replaceAll(
                              //     "}", '''<span class="AboThar"></span>''');
                              await controller.evaluateJavascript(source: '''
                                (function() {
                                    var data = $jsonData;
                                    for (var i = 0; i < data.length; i++) {
                                        var element = document.getElementById("page___" + i);
                                        if (element) {
                                            element.innerHTML = data[i];
                                            console.log("Inserted content for page___" + i);
                                        } else {
                                            console.log("Element with id page___" + i + " not found.");
                                        }
                                    }
                                })();
                            ''');

                              if (verticalScroll) {
                                // Vertical SPY
                                controller.evaluateJavascript(source: r"""
                                        $(window).on('scroll', function() {
                                    var currentTop = $(window).scrollTop();
                                    var elems = $('.BookPage-vertical');
                                    elems.each(function(index) {
                                        var elemTop = $(this).offset().top;
                                        var elemBottom = elemTop + $(this).height();
                                        if (currentTop >= elemTop && currentTop <= elemBottom) {
                                            var page = $(this).attr('data-page');
                                            window.flutter_inappwebview.callHandler('scrollSpy', page);
                                        }
                                    });
                                        });
                                      """);
                              } else {
                                // Horizontal SPY
                                controller.evaluateJavascript(source: r"""
                                        $(document).ready(function() {
                                          $('.book-container-horizontal').on('scroll', function() {
                                              var currentLeft = $(this).scrollLeft();
                                              var elems = $('.BookPage-horizontal');
                                              elems.each(function(index) {
                                                  var elemLeft = $(this).offset().left;
                                                  var elemRight = elemLeft + $(this).outerWidth();
                                                  if (currentLeft >= elemLeft && currentLeft <= elemRight) {
                                                      var page = $(this).attr('data-page');
                                                      window.flutter_inappwebview.callHandler('scrollSpy', page);
                                                  }
                                              });
                                          });
                                        });
                                        """);
                              }

                              controller.addJavaScriptHandler(
                                handlerName: 'scrollSpy',
                                callback: (arguments) {
                                  if (arguments.isNotEmpty &&
                                      double.tryParse(arguments[0]) != null) {
                                    double page = double.parse(arguments[0]);

                                    if (BlocProvider.of<SliderCubit>(context)
                                                .state
                                                .currentPage !=
                                            page &&
                                        page > 0) {
                                      BlocProvider.of<SliderCubit>(context)
                                          .onChangeState(page);
                                      debugPrint("$arguments <<<<=======SPY");
                                    }
                                  } else {
                                    debugPrint("Invalid arguments: $arguments");
                                  }
                                },
                              );
                            },
                            initialSettings: InAppWebViewSettings(
                              useShouldInterceptRequest: true,
                              javaScriptEnabled: true,
                              domStorageEnabled: true,
                              allowFileAccessFromFileURLs: true,
                              allowUniversalAccessFromFileURLs: true,
                              useShouldOverrideUrlLoading: true,
                              javaScriptCanOpenWindowsAutomatically: true,
                              supportZoom: false,
                              horizontalScrollBarEnabled: false,
                              verticalScrollBarEnabled: false,
                              pageZoom: 1,
                              maximumZoomScale: 1,
                              minimumZoomScale: 1,
                              useOnLoadResource: true,
                            ),
                            onLoadStart: (controller, url) async {
                              await controller.evaluateJavascript(source: '''
                              if (${widget.scrollPosetion} != 0) {
                                var y = getOffset(document.getElementById('book-mark_${widget.scrollPosetion == 0 ? widget.scrollPosetion : widget.scrollPosetion.floor() - 1}')).top;
                                window.scrollTo(0, y);
                              };
                              ''');
                            },
                            initialData: InAppWebViewInitialData(
                              data: htmlContent,
                              mimeType: "text/html",
                              encoding: "utf-8",
                            ),
                          ),
                        ),
                        BlocBuilder<SliderCubit, SliderState>(
                          builder: (context, state) {
                            return SizedBox(
                              width:
                                  verticalScroll ? 15 : EsaySize.width(context),
                              height: verticalScroll
                                  ? EsaySize.height(context)
                                  : 15,
                              child: FlutterSlider(
                                axis: BlocProvider.of<SettingsCubit>(context)
                                    .state
                                    .axix,
                                rtl: verticalScroll ? false : true,
                                handlerWidth: 20,
                                handler: FlutterSliderHandler(
                                    child: const SizedBox()),
                                handlerHeight: 20,
                                values: [state.currentPage],
                                max: snapshot.data!.length.toDouble(),
                                min: 1,

                                tooltip: FlutterSliderTooltip(
                                  disabled: false,
                                  direction:
                                      BlocProvider.of<SettingsCubit>(context)
                                                  .state
                                                  .axix ==
                                              Axis.vertical
                                          ? FlutterSliderTooltipDirection.left
                                          : FlutterSliderTooltipDirection.top,
                                  disableAnimation: false,
                                  custom: (value) => Padding(
                                    padding: const EdgeInsets.only(right: 0),
                                    child: Card(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8))),
                                      color: Theme.of(context)
                                          .floatingActionButtonTheme
                                          .backgroundColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          value.toStringAsFixed(0),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // boxStyle: FlutterSliderTooltipBox(),
                                ),
                                trackBar: FlutterSliderTrackBar(
                                    activeTrackBar: BoxDecoration(
                                        color: Theme.of(context)
                                            .floatingActionButtonTheme
                                            .backgroundColor)),
                                // onDragging: (handlerIndex, lowerValue, upperValue) {
                                //   setState(() {
                                //     _lowerValue = lowerValue;
                                //   });

                                // },
                                onDragCompleted: (handlerIndex, lowerValue,
                                    upperValue) async {
                                  final controller = inAppWebViewController;

                                  if (verticalScroll) {
                                    // Vertical

                                    await controller.evaluateJavascript(
                                      source: '''
                                      window.scrollTo(0, 0);
                                      var y = getOffset( document.querySelector('[data-page="${lowerValue.floor() - 1}"]') ).top;
                                      window.scrollTo(0, y);
                                  
                                      ''',
                                    );
                                  } else {
                                    // Horizontal
                                    await controller.evaluateJavascript(
                                      source: '''
                                              var x = getOffset(document.querySelector('[data-page="${lowerValue.floor() - 1}"]')).left;
                                              horizontal_container.scrollLeft = x;
                                            ''',
                                    );
                                  }

                                  BlocProvider.of<SliderCubit>(context)
                                      .onChangeState(lowerValue);
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
                return const Center(
                  child: Text("No data found"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar(
    BuildContext context,
  ) {
    return AppBar(
      backgroundColor:
          Theme.of(context).floatingActionButtonTheme.backgroundColor,
      title: Text(
        textDirection: TextDirection.rtl,
        widget.bookName,
        style: const TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      leadingWidth: 100,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          children: [
            ZoomTapAnimation(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            EsaySize.gap(4),
            BlocBuilder<IconCubit, bool>(
              builder: (context, isFilled) {
                return ZoomTapAnimation(
                    onTap: () async {
                      context.read<IconCubit>().toggleIcon(widget.id);
                      await DBhelperLastUpdate().insertOrdeleteBookFavorite(
                          widget.id, widget.bookName);
                    },
                    child: Icon(
                      isFilled ? Icons.star : Icons.star_border,
                      color: Colors.white,
                    ));
              },
            ),
            EsaySize.gap(4),
            ZoomTapAnimation(
                onTap: () {
                  BlocProvider.of<SearchHeghtCubit>(context).changeState();
                },
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                )),
            EsaySize.gap(4),
            BlocBuilder<AudioCubit, AudioState>(
              builder: (context, state) {
                if (state.haveSound) {
                  return ZoomTapAnimation(
                      onTap: () async {
                        AudioPanel.show(context,
                            bookname: widget.bookName, url: widget.soundUrl);
                      },
                      child: const Icon(
                        Icons.volume_up,
                        color: Colors.white,
                      ));
                }
                return const SizedBox.shrink();
              },
            )
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              ZoomTapAnimation(
                  onTap: () {
                    final controller = inAppWebViewController;
                    Navigator.push(
                        context,
                        DialogRoute(
                          context: context,
                          builder: (context) => SettingsDialog(
                            controller: controller,
                          ),
                        ));
                  },
                  child: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  )),
              EsaySize.gap(4),
              ZoomTapAnimation(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContentGroupPage(
                            id: widget.id,
                            bookName: widget.bookName,
                          ),
                        ));
                  },
                  child: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  )),
            ],
          ),
        )
      ],
    );
  }
}
