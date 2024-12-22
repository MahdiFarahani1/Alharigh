import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/enums/tooltip_direction_enum.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/database/db_helper_Content.dart';
import 'package:flutter_application_1/Core/database/db_helper_LastUpdate.dart';
import 'package:flutter_application_1/Core/utils/esay_size.dart';
import 'package:flutter_application_1/Core/utils/loading.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/bloc/slider/slider_cubit.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/content_group.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ContentPage extends StatefulWidget {
  final int id;
  final String bookName;
  final double scrollPosetion;

  const ContentPage(
      {super.key,
      required this.id,
      required this.bookName,
      required this.scrollPosetion});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  late InAppWebViewController webViewController;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SliderCubit()..onChangeState(widget.scrollPosetion),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
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
                  child: const Icon(Icons.menu)),
            )
          ],
        ),
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
                allTextBuffer.write("""  <div id='book_content'>
            <div class='BookPage' data-page='$i' style='color: black !important;' id='page_$i'>
              ${fav == 0 ? "<div class='book-mark' id='book-mark_$i'></div>" : "<div class='book-mark add_fav' id='book-mark_$i'></div>"}      <span class='page-number'>${i + 1}</span>
              <br>
              <div class='book_text' style='font-family: samim; direction: rtl; padding: 0 5px; text-align: justify; font-size: 14px !important;' id='page___$i'>
                $content
              </div>
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
                      </style>
                    </head>
                    <body onload="replaceContent()" dir="rtl">
                
                      $allText
                    </body>
                    </html>
                    """;

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
                            await DBhelperContent()
                                .updateFav('b${widget.id}.sqlite', bookmarkId);

                            await DBhelperLastUpdate()
                                .insertOrdeletePageFavorite(
                                    bookmarkId, widget.id, widget.bookName, '');
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
            }
            return const Center(
              child: Text("No data found"),
            );
          },
        ),
      ),
    );
  }
}
