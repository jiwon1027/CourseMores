import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'notification.dart' as noti;
import 'search.dart' as search;

void main() {
  runApp(MaterialApp(theme: style.theme, home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var pageNum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        appBar: AppBar(
          title:
              const Text('CourseMores', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const noti.Notification()),
                );
              },
            )
          ],
        ),
        body: [
          const Text("홈페이지"),
          const Text("코스페이지"),
          const search.Search(),
          const Text("관심페이지"),
          const Text("마이페이지")
        ][pageNum],
        bottomNavigationBar: FlashyTabBar(
          selectedIndex: pageNum,
          showElevation: true,
          onItemSelected: (index) => setState(() {
            pageNum = index;
          }),
          items: [
            FlashyTabBarItem(
              icon: Icon(Icons.home),
              title: Text('홈'),
            ),
            FlashyTabBarItem(
              icon: Icon(Icons.route),
              title: Text('코스'),
            ),
            FlashyTabBarItem(
              icon: Icon(Icons.search),
              title: Text('검색'),
            ),
            FlashyTabBarItem(
              icon: Icon(Icons.bookmark),
              title: Text('관심'),
            ),
            FlashyTabBarItem(
              icon: Icon(Icons.person),
              title: Text('마이페이지'),
            ),
          ],
        ));
  }
}
