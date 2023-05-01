import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'style.dart' as style;
import 'notification.dart' as noti;
import 'search.dart' as search;
import 'home_screen.dart' as home;
import 'mypage.dart' as mypage;
import 'course_make/makeStart.dart' as make;

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
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        appBar: const CustomAppBar(),
        body: [
          const home.HomeScreen(),
          const make.MakeStart(),
          const search.Search(),
          const Text("관심페이지"),
          const mypage.MyPage(),
        ][pageNum],
        bottomNavigationBar: FlashyTabBar(
          selectedIndex: pageNum,
          showElevation: true,
          onItemSelected: (index) => setState(() {
            pageNum = index;
          }),
          items: [
            FlashyTabBarItem(
              icon: const Icon(Icons.home),
              title: const Text('홈'),
            ),
            FlashyTabBarItem(
              icon: const Icon(Icons.route),
              title: const Text('코스'),
            ),
            FlashyTabBarItem(
              icon: const Icon(Icons.search),
              title: const Text('검색'),
            ),
            FlashyTabBarItem(
              icon: const Icon(Icons.bookmark),
              title: const Text('관심'),
            ),
            FlashyTabBarItem(
              icon: const Icon(Icons.person),
              title: const Text('마이페이지'),
            ),
          ],
        ));
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('CourseMores', style: TextStyle(color: Colors.black)),
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
