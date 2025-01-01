import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/enums/tooltip_direction_enum.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/database/db_helper_Content.dart';
import 'package:flutter_application_1/Core/database/db_helper_LastUpdate.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/Core/utils/loading.dart';
import 'package:flutter_application_1/Core/utils/remove_html_tags.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/bloc/audio/audio_cubit.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/bloc/saveBook/save_book_cubit.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/bloc/slider/slider_cubit.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/content_group.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/setting_panel.dart';
import 'package:flutter_application_1/Features/ContentBooks/repository/modal_comment.dart';
import 'package:flutter_application_1/Features/Settings/presentation/bloc/setting_cubit.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              snapshot.data!.asMap().forEach((i, item) {
                String content = item['_text'];
                int fav = item['fav'];

                allTextBuffer.write("""
                    <div class='$bookPage' data-page='$i' style='color: black !important; background-color: ${BlocProvider.of<SettingsCubit>(context).state.backgroundPageColor[0]} !important; font-size: 14px !important;' id='page_$i'>
                      ${fav == 0 ? "<div class='book-mark' id='book-mark_$i'></div>" : "<div class='book-mark add_fav' id='book-mark_$i'></div>"}
                      <div class='comment-button' ></div><span class='page-number'>${i + 1}</span>
                      <br>
                      <div class='$bookText' id='page___$i'>
                        $content
                      </div>
                    </div>
                  """);
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
                        p div {
                          display: block !important;
                        }
                      </style>
                    </head>
                    <body onload="replaceContent()" dir="rtl">
                <div class='$bookContainer'>
                      
                      $allText
                  </div>
                    </body>
                    </html>
                    """;

              return SizedBox(
                width: EsaySize.width(context),
                height: EsaySize.height(context),
                child: ListView(
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
                        onLoadStop: (controller, url) {
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
                          clearCache: true,
                          clearSessionCache: true,
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
                
                
                
                
                      function CommentEvent() {
                          var bookmark_elems = $('.comment-button');
                          bookmark_elems.each(function(index){
                            $(this).click(function() { 
                var item = $(this);
                if (!item.hasClass("has-comment")) {
                  item.addClass("has-comment");
                }
                if (window.flutter_inappwebview) {
                  window.flutter_inappwebview.callHandler('CommentEvent', index);
                }
                            });
                          });
                  }
                  CommentEvent();
                  
                  
                  
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
                          width: verticalScroll ? 15 : EsaySize.width(context),
                          height:
                              verticalScroll ? EsaySize.height(context) : 15,
                          child: FlutterSlider(
                            axis: BlocProvider.of<SettingsCubit>(context)
                                .state
                                .axix,
                            rtl: verticalScroll ? false : true,
                            handlerWidth: 20,
                            handler:
                                FlutterSliderHandler(child: const SizedBox()),
                            handlerHeight: 20,
                            values: [state.currentPage],
                            max: snapshot.data!.length.toDouble(),
                            min: 1,

                            tooltip: FlutterSliderTooltip(
                              disabled: false,
                              direction: FlutterSliderTooltipDirection.left,
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
                            onDragCompleted:
                                (handlerIndex, lowerValue, upperValue) async {
                              if (verticalScroll) {
                                // Vertical

                                await webViewController.evaluateJavascript(
                                  source: '''
                              window.scrollTo(0, 0);
                              var y = getOffset( document.querySelector('[data-page="${lowerValue.floor() - 1}"]') ).top;
                              window.scrollTo(0, y);
                          
                              ''',
                                );
                              } else {
                                // Horizontal
                                await webViewController.evaluateJavascript(
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
