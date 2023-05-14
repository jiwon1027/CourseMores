import 'package:coursemores/controller/getx_controller.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'style.dart' as style;
import 'notification/notification.dart' as noti;
import 'course_search/search.dart' as search;
import 'home_screen/home_screen.dart' as home;
import 'mypage/mypage.dart' as mypage;
import 'course_make/make_start.dart' as make;
import 'auth/login_page.dart' as login;
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final loginController = Get.put(LoginStatus());
final pageController = Get.put(PageNum());
final tokenStorage = Get.put(TokenStorage());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/config/.env');
  KakaoSdk.init(nativeAppKey: '59816c34bd5a0094d4f29bf08b55a34c');
  runApp(GetMaterialApp(theme: style.theme, home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var pageNum = pageController.pageNum.value;

      if (loginController.isLoggedIn.value == true) {
        // 백에 accesstoken 재발급받는 api 요청..
        // 컨트롤러에 response 저장

        return Scaffold(
            backgroundColor: Color.fromARGB(255, 240, 240, 240),
            appBar: CustomAppBar(),
            body: [
              home.HomeScreen(),
              make.MakeStart(),
              search.Search(),
              Text("관심페이지"),
              mypage.MyPage(),
            ][pageNum],
            bottomNavigationBar: pageNum == 0
                ? null
                : FlashyTabBar(
                    selectedIndex: pageNum,
                    showElevation: true,
                    onItemSelected: (index) =>
                        pageController.changePageNum(index),
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
      } else {
        return login.LoginPage();
      }
    });
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('CourseMores', style: TextStyle(color: Colors.black)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.black),
          onPressed: () {
            Get.to(noti.Notification());
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
