// import 'login_page.dart' as login;
import 'package:flutter/material.dart';
import 'sign_up.dart' as signup;
import 'package:animated_button_bar/animated_button_bar.dart';
import 'search.dart' as search;
import 'course_search/course_list.dart' as course;
import 'package:get/get.dart';
import 'main.dart';
import 'package:coursemores/getx_controller.dart';
import 'profile_edit.dart' as profie_edit;

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  var courseList = course.courseList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                profileBox(),
                // OutlinedButton(
                //     onPressed: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => const login.LoginPage()));
                //     },
                //     child: Text('로그인페이지')),
                ButtonBar(),
                Text(
                  '내가 작성한 코스 : 11 개',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Flexible(
                  child: search.SearchResult(
                    courseList: courseList,
                  ),
                )
                // Container(
                //   margin: const EdgeInsets.only(
                //       left: 10, right: 10, top: 10, bottom: 5),
                //   padding: const EdgeInsets.all(10),
                //   decoration: const BoxDecoration(
                //       boxShadow: [
                //         BoxShadow(
                //             // color: Colors.white24,
                //             color: Color.fromARGB(255, 211, 211, 211),
                //             blurRadius: 10.0,
                //             spreadRadius: 1.0,
                //             offset: Offset(3, 3)),
                //       ],
                //       color: Color.fromARGB(255, 255, 255, 255),
                //       borderRadius: BorderRadius.all(Radius.circular(10))),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Expanded(
                //           child: SizedBox(
                //               width: 350,
                //               child: Row(
                //                 children: const [
                //                   search.ThumbnailImage(),
                //                   SizedBox(
                //                     width: 10,
                //                   ),
                //                   Expanded(
                //                     child: search.CourseSearchList(
                //                       // courseList: courseList,
                //                       index: 1,
                //                     ),
                //                   ),
                //                 ],
                //               )))
                //     ],
                //   ),
                // ),
              ])),
    ));
  }
}

final userInfoController = Get.put(UserInfo());
profileBox() {
  return Container(
      height: 200.0,
      decoration: boxDeco(),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    Color(0xff4dabf7),
                    Color(0xffda77f2),
                    Color(0xfff783ac),
                  ],
                ),
                borderRadius: BorderRadius.circular(120),
              ),
              child: const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("assets/img2.png"),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 15.0),
                  child: Text(
                    userInfoController.nickname.value,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0),
                  child: Text(
                    userInfoController.age.value.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  child: Text(
                    userInfoController.gender.value,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              ModalBottom(),
            ],
          )
        ],
      ));
}

boxDeco() {
  return BoxDecoration(
    color: const Color.fromARGB(255, 231, 151, 151),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 3,
        offset: const Offset(0, 2), // changes position of shadow
      ),
    ],
  );
}

class ButtonBar extends StatefulWidget {
  const ButtonBar({super.key});

  @override
  State<ButtonBar> createState() => _ButtonBarState();
}

class _ButtonBarState extends State<ButtonBar> {
  String choice = 'course';
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 60,
      child: AnimatedButtonBar(
          radius: 20.0,
          padding: EdgeInsets.all(8),
          backgroundColor: Colors.blueGrey.shade100,
          foregroundColor: Colors.blue,
          innerVerticalPadding: 0,
          children: [
            ButtonBarEntry(
                child: Text('내 코스'),
                onTap: () {
                  setState(() {
                    choice = 'course';
                  });
                }),
            ButtonBarEntry(
                child: Text('내 리뷰'),
                onTap: () {
                  setState(() {
                    choice = 'review';
                  });
                }),
          ]),
    );
  }
}

class ModalBottom extends StatelessWidget {
  const ModalBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
          onPressed: () {
            showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                      height: 150,
                      color: Colors.transparent,
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const profie_edit
                                                      .ProfileEdit()));
                                    },
                                    child: const Center(
                                        child: Text(
                                      '내 정보 수정',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                      textAlign: TextAlign.center,
                                    ))),
                              ),
                              Expanded(
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      loginController.changeLoginStatus();
                                      // 로그아웃 메서드 쓰기..
                                      print('logout');
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1))),
                                      child: const Center(
                                          // color: Colors.yellow,
                                          child: Text(
                                        '로그아웃',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.red),
                                        textAlign: TextAlign.center,
                                      )),
                                    )),
                              ),
                              Expanded(
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      loginController.changeLoginStatus();
                                      // 로그아웃 메서드 쓰기..
                                      print('회원탈퇴!');
                                      //탈퇴 메서드 쓰기
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1))),
                                      child: const Center(
                                          // color: Colors.yellow,
                                          child: Text(
                                        '회원탈퇴',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.red),
                                        textAlign: TextAlign.center,
                                      )),
                                    )),
                              ),
                            ]),
                      ));
                });
          },
          icon: const Icon(Icons.settings)),
    );
  }
}
