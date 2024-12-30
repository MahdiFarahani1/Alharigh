import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/enums/tooltip_direction_enum.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/database/db_helper_Content.dart';
import 'package:flutter_application_1/Core/database/db_helper_LastUpdate.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/Core/utils/loading.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/bloc/audio/audio_cubit.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/bloc/saveBook/save_book_cubit.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/bloc/slider/slider_cubit.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/content_group.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/setting_panel.dart';
import 'package:flutter_application_1/Features/Settings/presentation/bloc/setting_cubit.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ContentPage extends StatefulWidget {
  final int id;
  final String bookName;
  final double scrollPosetion;
  const ContentPage({
    super.key,
    required this.id,
    required this.bookName,
    required this.scrollPosetion,
  });

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  late InAppWebViewController webViewController;
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
        body: FutureBuilder(
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
              StringBuffer allTextBuffer = StringBuffer();

              snapshot.data!.asMap().forEach((i, item) {
                String content = item['_text'];
                int fav = item['fav'];
                allTextBuffer.write(
                  """
    <div class='BookPage' data-page='$i' style='color: black !important; background-color: ${BlocProvider.of<SettingsCubit>(context).state.backgroundPageColor[0]} !important; font-size: 14px !important;' id='page_$i'>
      ${fav == 0 ? "<div class='book-mark' id='book-mark_$i'></div>" : "<div class='book-mark add_fav' id='book-mark_$i'></div>"}      
      <span class='page-number'>${i + 1}</span>
      <br>
      <div class='book_text' style='font-family: samim; direction: rtl; padding: 0 5px; text-align: justify; font-size: 14px !important;' id='page___$i'>
        $content
      </div>
    </div>
  """,
                );
              });

              String allText = allTextBuffer.toString();

              String htmlContent = """
                    <!DOCTYPE html>
                    <html lang="en">
                    <head>
                      <meta charset="UTF-8">
                      <meta name="viewport" content="width=device-width, initial-scale=1.0">
                      <style>
                        body {
                          font-family: Arial, sans-serif;
                          line-height: 1.6;
                          padding: 6px;
                        }
                        h1, h2, h3 {
                          color: #333;
                        }
                        hr {
                          margin: 20px 0;
                        }
                      </style>
                    </head>
                    <body onload="replaceContent()" dir="rtl">
                
                      
                      $allText
                  
                    </body>
                    </html>
                    """;
              if (BlocProvider.of<SettingsCubit>(context).state.axix ==
                  Axis.vertical) {
                return Row(
                  children: [
                    SizedBox(
                      width: EsaySize.width(context) - 30,
                      child: InAppWebView(
                        onWebViewCreated: (controller) {
                          webViewController = controller;

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
                        },
                        onLoadStop: (controller, url) {
                          controller.evaluateJavascript(source: r"""
              $(window).on('scroll', function() {
          var currentTop = $(window).scrollTop();
          var elems = $('.BookPage'); 
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
                        ),
                        onLoadStart: (controller, url) async {
                          await controller.injectCSSFileFromAsset(
                              assetFilePath: Assets.web.css.bootstrapRtlMin);
                          await controller.injectCSSFileFromAsset(
                              assetFilePath: Assets.web.css.mhebooks);

                          await controller.injectJavascriptFileFromAsset(
                              assetFilePath: Assets.web.js.jquery351Min);
                          await controller.injectJavascriptFileFromAsset(
                              assetFilePath: Assets.web.js.bootstrapBundleMin);
                          await controller.injectJavascriptFileFromAsset(
                              assetFilePath: Assets.web.js.main);
                          await controller.evaluateJavascript(source: '''
  if (${widget.scrollPosetion} != 0) {
    var y = getOffset(document.getElementById('book-mark_${widget.scrollPosetion == 0 ? widget.scrollPosetion : widget.scrollPosetion.floor() - 1}')).top;
    window.scrollTo(0, y);
  }
''');

                          await controller.evaluateJavascript(source: r'''
            $(function () {
              console.log("Tooltip initialized");
              $('[data-toggle="tooltip"]').tooltip({
                placement: 'bottom',
                html: true
              });
            });
                
                
                
                function BookmarkStatus() {
          var bookmark_elems = $('.book-mark');
          bookmark_elems.each(function(index){
            $(this).click(function() { 
              var item = $(this);  
              if (item.hasClass("add_fav")) {
                item.removeClass("add_fav");
              } else {
                item.addClass("add_fav");
              }
              // Send the updated bookmark status back to Flutter
              if (window.flutter_inappwebview) {
                window.flutter_inappwebview.callHandler('bookmarkToggled', index);
              }
            });
          });
                }
                BookmarkStatus();
                
                
                
          ''');
                        },
                        initialData: InAppWebViewInitialData(data: htmlContent),
                      ),
                    ),
                    BlocBuilder<SliderCubit, SliderState>(
                      builder: (context, state) {
                        return Expanded(
                          child: FlutterSlider(
                            axis: Axis.vertical,
                            handlerWidth: 30,
                            handlerHeight: 30,
                            values: [state.currentPage],
                            max: snapshot.data!.length.toDouble(),
                            min: 1,

                            tooltip: FlutterSliderTooltip(
                              disabled: false,
                              direction: FlutterSliderTooltipDirection.left,
                              disableAnimation: false,
                              custom: (value) => Padding(
                                padding: const EdgeInsets.only(right: 4),
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
                            onDragCompleted:
                                (handlerIndex, lowerValue, upperValue) async {
                              debugPrint(
                                  '${lowerValue.floor()}<<<<=======lowerValue');
                              await webViewController.evaluateJavascript(
                                source: '''
                          window.scrollTo(0, 0);
                          var y = getOffset( document.getElementById('book-mark_${lowerValue.floor() - 1}') ).top;
                          window.scrollTo(0, y);
                          
                          
                          ''',
                              );
                              BlocProvider.of<SliderCubit>(context)
                                  .onChangeState(lowerValue);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                );
              } else {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListView.builder(
                    itemExtent: EsaySize.width(context) - 50,
                    itemCount: snapshot.data!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(8)),
                        width: EsaySize.width(context),
                        height: EsaySize.height(context),
                        margin: const EdgeInsets.all(8),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .floatingActionButtonTheme
                                            .backgroundColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: const Center(
                                      child: Text(
                                        '230',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    Assets.web.css.bookmark1.path,
                                    width: 30,
                                    height: 30,
                                  ),
                                ],
                              ),
                              EsaySize.gap(10),
                              const Divider(
                                color: Colors.grey,
                              ),
                              EsaySize.gap(10),
                              Expanded(
                                child: Html(
                                  data: snapshot.data![index]['_text'],
                                  style: {
                                    "h1.tit1": Style(
                                      color: Colors.green,
                                      margin: Margins.only(top: 20, bottom: 0),
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'inherit',
                                    ),
                                    "h2.tit2": Style(
                                      color: Colors.green,
                                      margin: Margins.only(top: 20, bottom: 0),
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'inherit',
                                    ),
                                    "h2.tit3": Style(
                                      color: Colors.black,
                                      margin: Margins.only(top: 20, bottom: 0),
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'inherit',
                                    ),
                                    "h3.tit3": Style(
                                      color: Colors.black,
                                      margin: Margins.only(top: 20, bottom: 10),
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'inherit',
                                    ),
                                    "h4.tit4": Style(
                                      color: Colors.black,
                                      margin: Margins.only(top: 20, bottom: 0),
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'inherit',
                                    ),
                                    "h5.tit5": Style(
                                      color: Colors.black,
                                      margin: Margins.only(top: 20, bottom: 10),
                                      textAlign: TextAlign.right,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'inherit',
                                    ),
                                    "p.pagen": Style(
                                      textAlign: TextAlign.center,
                                      color: Colors.red,
                                    ),
                                    ".fnote": Style(
                                      color: const Color(0xFF337777),
                                      margin: Margins.only(bottom: 10),
                                      padding: HtmlPaddings.zero,
                                      lineHeight: LineHeight.percent(150),
                                    ),
                                    "hr.fnote": Style(
                                      border: Border.all(
                                          color: const Color(0xFFE3E3E3),
                                          width: 1),
                                      width: Width(40),
                                    ),
                                    ".fnote_line": Style(
                                      color: const Color(0xFF337777),
                                      padding: HtmlPaddings.zero,
                                      textOverflow: TextOverflow.ellipsis,
                                      margin: Margins.only(top: 10, bottom: 0),
                                    ),
                                    ".fnote2": Style(
                                      color: const Color(0xFF337777),
                                      margin: Margins.zero,
                                      padding: HtmlPaddings.zero,
                                    ),
                                    ".sher": Style(
                                      textAlign: TextAlign.center,
                                      color: Colors.black,
                                      margin: Margins.symmetric(vertical: 10),
                                    ),
                                    "p": Style(
                                      margin: Margins.zero,
                                      padding: HtmlPaddings.zero,
                                    ),
                                    "p + p": Style(
                                      margin: Margins.zero,
                                    ),
                                    ".fn": Style(
                                      color: const Color(0xFF337777),
                                      textDecoration: TextDecoration.none,
                                      verticalAlign: VerticalAlign.top,
                                    ),
                                    ".fm": Style(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Simplified Arabic, serif',
                                      textDecoration: TextDecoration.none,
                                    ),
                                    ".quran": Style(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                    ".hadith": Style(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    ".eng": Style(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    ".txtleft": Style(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                    ".paragraph": Style(
                                      color: Colors.black,
                                      margin: Margins.zero,
                                    ),
                                    ".hashieh": Style(
                                      textOverflow: TextOverflow.ellipsis,
                                      width: Width.auto(),
                                      color: Colors.black,
                                    ),
                                    ".centertxt": Style(
                                      textAlign: TextAlign.center,
                                      color: const Color.fromARGB(
                                          255, 204, 102, 0),
                                    ),
                                    ".centertxt2": Style(
                                      textAlign: TextAlign.center,
                                      color: Colors.black,
                                    ),
                                    ".empty": Style(
                                      color: const Color.fromARGB(
                                          255, 204, 102, 0),
                                      textAlign: TextAlign.center,
                                      padding: HtmlPaddings.only(top: 260),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ".short-texts": Style(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      direction: TextDirection.rtl,
                                    ),
                                    ".short-texts-line": Style(
                                      margin: Margins.only(top: -10),
                                      padding: HtmlPaddings.zero,
                                      display: Display.inlineBlock,
                                    ),
                                    ".marging_text": Style(
                                      color: const Color(0xFF764C01),
                                    ),
                                    ".highlight": Style(
                                      backgroundColor: Colors.yellow,
                                    ),
                                    ".BookPage": Style(
                                      margin: Margins.all(10),
                                      padding: HtmlPaddings.symmetric(
                                          vertical: 15, horizontal: 10),
                                      backgroundColor: Colors.white,
                                      border: Border.all(
                                        color: const Color(0xFFAAAAAA)
                                            .withOpacity(0.33),
                                        width: 1,
                                      ),
                                      textAlign: TextAlign.justify,
                                      direction: TextDirection.rtl,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  },
                                ),
                              ),
                            ],
                          ),
                        )),
                      );
                    },
                  ),
                );
              }
            }
            return const Center(
              child: Text("No data found"),
            );
          },
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor:
          Theme.of(context).floatingActionButtonTheme.backgroundColor,
      title: Text(
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
            BlocBuilder<AudioCubit, AudioState>(
              builder: (context, state) {
                if (state.haveSound) {
                  return ZoomTapAnimation(
                      onTap: () async {},
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
                    Navigator.push(
                        context,
                        DialogRoute(
                          context: context,
                          builder: (context) => const SettingsDialog(),
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
