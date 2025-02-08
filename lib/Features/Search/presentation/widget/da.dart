//  ListWheelScrollView.useDelegate(
//                         itemExtent: 50.0,
//                         onSelectedItemChanged: (value) {
//                           setStateWheel(
//                             () {
//                               selectedIndex = value;
//                               if (value == 0) {
//                                 idbook = 0;
//                                 bookname = '';
//                               } else {
//                                 idbook = snapshot.data![value - 1]['id'];
//                                 bookname = snapshot.data![value - 1]['title'];
//                               }
//                             },
//                           );
//                         },
//                         childDelegate: ListWheelChildBuilderDelegate(
//                           builder: (context, index) {
//                             if (index == 0) {
//                               return Text(
//                                 'الكل',
//                                 style: TextStyle(
//                                     color: selectedIndex == index
//                                         ? Colors.black
//                                         : Colors.black12),
//                               );
//                             }

//                             var e = snapshot.data![index - 1];
//                             bool havePart = e['joz'] != 0;

//                             return Text(
//                                 havePart
//                                     ? '${e['title']} الجزء ${e['joz']}'
//                                     : '${e['title']}',
//                                 style: TextStyle(
//                                     color: selectedIndex == index
//                                         ? Colors.black
//                                         : Colors.black12));
//                           },
//                           childCount: snapshot.data!.length + 1,
//                         ),
//                       );
