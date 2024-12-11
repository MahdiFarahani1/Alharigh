// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Core/database/db_helper_BookList.dart';
// import 'package:flutter_application_1/Core/utils/esay_size.dart';
// import 'package:flutter_application_1/gen/assets.gen.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// void main(List<String> args) {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const TestPage(),
//     );
//   }
// }

// class TestPage extends StatefulWidget {
//   const TestPage({super.key});

//   @override
//   State<TestPage> createState() => _TestPageState();
// }

// class _TestPageState extends State<TestPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.redAccent,
//         title: const Text("HTML Viewer"),
//       ),
//       body: FutureBuilder(
//         future: DBhelperBookList().getGroupBooks(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (snapshot.hasError) {
//             return const Center(
//               child: Text('Error loading data'),
//             );
//           }
//           if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//             StringBuffer allTextBuffer = StringBuffer();

//             snapshot.data!.asMap().forEach((i, item) {
//               String content = item['_text'];
//               allTextBuffer.write("""
//   <div id='book_content'>
//     <div class='BookPage' data-page='$i' style='color: black !important;' id='page_$i'>
//       <div class='book-mark' id='book-mark_$i'></div>
//       <span class='page-number'>${i + 1}</span>
//       <br>
//       <div class='book_text' style='font-family: samim; direction: rtl; padding: 0 5px; text-align: justify; font-size: 14px !important;' id='page___$i'>
//         $content
//       </div>
//     </div>
//   </div>

//   """);
//             });

//             String allText = allTextBuffer.toString();

//             String htmlContent = """
//             <!DOCTYPE html>
//             <html lang="en">
//             <head>
//               <meta charset="UTF-8">
//               <meta name="viewport" content="width=device-width, initial-scale=1.0">
//               <style>
//                 body {
//                   font-family: Arial, sans-serif;
//                   line-height: 1.6;
//                   padding: 10px;
//                 }
//                 h1, h2, h3 {
//                   color: #333;
//                 }
//                 hr {
//                   margin: 20px 0;
//                 }
//               </style>
//             </head>
//             <body>
//               $allText
//             </body>
//             </html>
//             """;

//             return Row(
//               children: [
//                 SizedBox(
//                   width: EsaySize.width(context) - 30,
//                   child: InAppWebView(
//                     initialSettings: InAppWebViewSettings(
//                       javaScriptEnabled: true,
//                       domStorageEnabled: true,
//                     ),
//                     onLoadStart: (controller, url) async {
//                       await controller.injectCSSFileFromAsset(
//                           assetFilePath: Assets.web.css.bootstrapRtlMin);
//                       await controller.injectCSSFileFromAsset(
//                           assetFilePath: Assets.web.css.mhebooks);

//                       await controller.injectJavascriptFileFromAsset(
//                           assetFilePath: Assets.web.js.jquery351Min);
//                       await controller.injectJavascriptFileFromAsset(
//                           assetFilePath: Assets.web.js.bootstrapBundleMin);
//                       await controller.injectJavascriptFileFromAsset(
//                           assetFilePath: Assets.web.js.main);

//                       await controller.evaluateJavascript(source: r'''
//     $(function () {
//       console.log("Tooltip initialized");
//       $('[data-toggle="tooltip"]').tooltip({
//         placement: 'bottom',
//         html: true
//       });
//     });
//   ''');
//                     },
//                     initialData: InAppWebViewInitialData(data: htmlContent),
//                   ),
//                 ),
//                 Expanded(
//                   child: Transform.rotate(
//                     angle: 3.14,
//                     child: Slider(
//                       value: 0.0,
//                       onChanged: (value) {},
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }
//           return const Center(
//             child: Text("No data found"),
//           );
//         },
//       ),
//     );
//   }
// }
