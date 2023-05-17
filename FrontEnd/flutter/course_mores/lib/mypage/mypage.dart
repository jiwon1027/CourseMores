import 'package:coursemores/auth/login_page.dart';
import 'package:coursemores/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:get/get.dart';
import '../controller/getx_controller.dart';
import '../course_search/search.dart';
import 'profile_edit.dart' as profie_edit;
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../auth/auth_dio.dart';
import '../course_search/course_detail.dart' as detail;
import 'package:cached_network_image/cached_network_image.dart';
import 'my_review.dart' as my_review;
import '../auth/withdrawal.dart' as withdrawal;
// import 'profile_edit.dart' as edit;
import 'package:dio/dio.dart' as dio;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

final myPageController = Get.put(MyPageInfo());

class _MyPageState extends State<MyPage> {
  List<Map<String, Object>> courseList = myPageController.myCourse;
  List<Map<String, Object>> reviewList = myPageController.myReview;
  var status = myPageController.status;

  @override
  void initState() {
    super.initState();
    status = 'course';
    fetchData(tokenController.accessToken);
    updateUserInfo();
  }

  Future<void> downloadImage() async {
    if (userInfoController.imageUrl.value != 'default') {
      dio.Response response = await dio.Dio().get(
          '${userInfoController.imageUrl}',
          options: dio.Options(responseType: dio.ResponseType.bytes));
      String tempDir = (await getTemporaryDirectory()).path;
      String filePath = join(tempDir, 'image.jpg');
      await File(filePath).writeAsBytes(response.data);
      XFile xFile = XFile(filePath);
      userInfoController.saveImage(xFile);
      print('서버에서 받은 이미지 다운로드! : ${userInfoController.profileImage}');
    } else {
      print('프로필이미지 등록되어있지 않음!');
      userInfoController.profileImage = null;
      print(userInfoController.profileImage);
    }
  }

  // Future<void> updateUserInfo() async {
  //   final dio = await authDio();
  //   final response = await dio.get('profile/');
  //   print('userinfo update ! : $response');
  //   print('editcheck?? ${userInfoController.editCheck.value}');
  //   print('review : $reviewList');
  //   userInfoController
  //       .saveCurrentNickname('${response.data['userInfo']['nickname']}');
  //   userInfoController.saveImageUrl(response.data['userInfo']['profileImage']);
  //   print(userInfoController.imageUrl);
  //   await downloadImage();
  // }

  Future<void> fetchData(aToken) async {
    final dio = await authDio();

    final response = await dio.get(
      'course/my',
    );
    print('fetch course : $response');
    List<dynamic> data = response.data['myCourseList'];
    // final list = (data as List<dynamic>).cast<Map<String, Object>>().toList();
    // courseList = list;
    // setState(() {
    //   courseList = data.map((item) => Map<String, Object>.from(item)).toList();
    // });
    myPageController.saveMyCourse(data.map((item) => Map<String, Object>.from(item)).toList());
    setState(() {
      courseList = myPageController.myCourse;
    });

    final response2 = await dio.get('comment/', options: Options(headers: {'Authorization': 'Bearer $aToken'}));
    List<dynamic> data2 = response2.data['myCommentList'];
    // print(data);
    myPageController.saveMyReview(data2.map((item) => Map<String, Object>.from(item)).toList());
    setState(() {
      reviewList = myPageController.myReview;
    });
  }

  buttonBar() {
    return SizedBox(
      width: 220,
      height: 60,
      child: AnimatedButtonBar(
          radius: 8.0,
          padding: EdgeInsets.all(8),
          // backgroundColor: Colors.blueGrey.shade50,
          backgroundColor: Colors.blueGrey.shade50,
          foregroundColor: Colors.blue,
          invertedSelection: true,
          children: [
            ButtonBarEntry(
                child: Text(
                  '내 코스',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  myPageController.statusToCourse();
                  setState(() {
                    status = myPageController.status;
                  });
                  print(status);
                }),
            ButtonBarEntry(
                child: Text(
                  '내 리뷰',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                onTap: () {
                  myPageController.statusToReview();
                  setState(() {
                    status = myPageController.status;
                  });
                  print(status);
                }),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            '마이 페이지',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
      headerWidget: headerWidget(context),
      headerExpandedHeight: 0.3,
      body: [
        SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                profileBox(),
                // OutlinedButton(
                //     onPressed: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => const login.LoginPage()));
                //     },
                //     child: Text('로그인페이지')),
                buttonBar(),
                if (status == 'course') Flexible(child: MyCourse()),
                if (status == 'review')
                  Flexible(
                    child: SizedBox(
                      height: reviewList.isEmpty ? null : 600,
                      child: my_review.DetailTapCourseCommentsListSection(commentsList: reviewList),
                    ),
                  )
              ])),
        )
      ],
      fullyStretchable: false,
      backgroundColor: Colors.white,
      appBarColor: Color.fromARGB(255, 95, 207, 255),
    );
  }
}

class MyCourse extends StatelessWidget {
  MyCourse({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(8),
      itemCount: myPageController.myCourse.length,

      // index 말고 코스id로??
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () async {
            print('mypage 코스리스트 == ${myPageController.myCourse}');
            int courseId = (myPageController.myCourse[index]['courseId'] as int);

              await searchController.changeNowCourseId(courseId: courseId);

              await detailController.getCourseInfo('코스 소개');
              await detailController.getIsLikeCourse();
              await detailController.getIsInterestCourse();
              await detailController.getCourseDetailList();

              Get.to(() => detail.Detail());

            // Get.to(() => detail.CourseDetail(index: index));
          },
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
            padding: EdgeInsets.all(10),
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(255, 211, 211, 211), blurRadius: 10.0, spreadRadius: 1.0, offset: Offset(3, 3)),
            ], color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: SizedBox(
                        width: 300,
                        child: Row(children: [
                          ThumbnailImage(index: index),
                          SizedBox(width: 10),
                          Expanded(child: MyCourseList(index: index)),
                        ]))),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MyCourseList extends StatelessWidget {
  MyCourseList({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${myPageController.myCourse[index]['title']}",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ),
                  SizedBox(width: 10),
                  if (myPageController.myCourse[index]["visited"] == true)
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 107, 211, 66),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(Icons.check, size: 12, color: Colors.white),
                          ),
                          Text("방문", style: TextStyle(color: Colors.white, fontSize: 10)),
                          SizedBox(width: 7),
                        ],
                      ),
                    )
                ],
              ),
            ),
            if (myPageController.myCourse[index]["interest"] == true) Icon(Icons.bookmark, size: 24),
            if (myPageController.myCourse[index]["interest"] == false) Icon(Icons.bookmark_outline_rounded, size: 24),
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Icon(Icons.map, size: 12, color: Colors.black38),
            SizedBox(width: 3),
            Text(
              "${myPageController.myCourse[index]["sido"].toString()} ${myPageController.myCourse[index]["gugun"].toString()}",
              style: TextStyle(fontSize: 12, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
            SizedBox(width: 8),
            Icon(Icons.people, size: 12, color: Colors.black38),
            SizedBox(width: 3),
            Text(
              "${myPageController.myCourse[index]['people'].toString()}명",
              style: TextStyle(fontSize: 12, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
          ],
        ),
        SizedBox(height: 6),
        Text(
          "${myPageController.myCourse[index]['content']}",
          style: TextStyle(fontSize: 12),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: true,
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "${myPageController.myCourse[index]['locationName']}",
                style: TextStyle(fontSize: 10, color: Colors.black45),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: true,
              ),
            ),
            SizedBox(width: 10),
            Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite, size: 12),
                    SizedBox(width: 3),
                    Text(myPageController.myCourse[index]["likeCount"].toString()),
                  ],
                ),
                SizedBox(width: 8),
                Row(
                  children: [
                    Icon(Icons.comment, size: 14),
                    SizedBox(width: 3),
                    Text(myPageController.myCourse[index]["commentCount"].toString()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class ThumbnailImage extends StatelessWidget {
  const ThumbnailImage({super.key, required this.index});

  final index;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: myPageController.myCourse[index]['image'].toString(),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        height: 80,
        width: 80,
        fit: BoxFit.cover,
      ),
    );
  }
}

final userInfoController = Get.put(UserInfo());

profileBox() {
  final profileImageUrl;
  var gender;
  // if (userInfoController.gender.value == 'M') {
  //   gender = '남성'.obs;
  // } else {
  //   gender = '여성'.obs;
  // }
  // if (userInfoController.imageUrl.value == 'default') {
  //   profileImageUrl =
  //       'https://media.istockphoto.com/id/1316947194/vector/messenger-profile-icon-on-white-isolated-background-vector-illustration.jpg?s=612x612&w=0&k=20&c=1iQ926GXQTJkopoZAdYXgU17NCDJIRUzx6bhzgLm9ps=';
  // } else {
  //   profileImageUrl = userInfoController.imageUrl.value;
  // }
  return Padding(
    padding: EdgeInsets.all(8),
    child: SizedBox(
        height: 390,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [ModalBottom()],
            ),
            Padding(
              padding: EdgeInsets.all(8),
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
                  child: Obx(
                    () => CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          (userInfoController.imageUrl.value == 'default')
                              ? 'https://coursemores.s3.amazonaws.com/default_profile.png'
                              : userInfoController.imageUrl.value

                          // profileImageUrl
                          ),
                    ),
                  )),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 15.0),
                    child: Obx(() => Text(
                          userInfoController.nickname.value,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0),
                    child: Obx(() => Text(
                          '${userInfoController.age.value.toString()} 대',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    child: Obx(() => Text(
                          userInfoController.gender.value == 'M' ? '남성' : '여성',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                  )
                ],
              ),
            ),
          ],
        )),
  );
}

boxDeco() {
  return BoxDecoration(
    color: Colors.white,
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

final authController = Get.put(AuthController());
final loginController = Get.put(LoginStatus());
final pageController = Get.put(PageNum());

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
                      height: 180,
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
                                      print(userInfoController.profileImage);
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => const profie_edit.ProfileEdit()));
                                    },
                                    child: Center(
                                        child: Text(
                                      '내 정보 수정',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ))),
                              ),
                              Expanded(
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      authController.logout();
                                      print(loginController.isLoggedIn.value);
                                      print(pageController.pageNum.value);
                                      // 로그아웃 메서드 쓰기..
                                      // logout();
                                      print('logout');
                                      // Get.to(main.MyApp());
                                    },
                                    child: Container(
                                      decoration:
                                          BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 1))),
                                      child: Center(
                                          child: Text(
                                        '로그아웃',
                                        style: TextStyle(fontSize: 16, color: Colors.red),
                                        textAlign: TextAlign.center,
                                      )),
                                    )),
                              ),
                              Expanded(
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      authController.logout();
                                      // 로그아웃 메서드 쓰기..
                                      print('회원탈퇴!');
                                      Get.to(main.MyApp());
                                    },
                                    child: Container(
                                      decoration:
                                          BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 1))),
                                      child: Center(
                                          child: Text(
                                        '회원탈퇴',
                                        style: TextStyle(fontSize: 16, color: Colors.red),
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

// void logout() async {
//   final dio = await authDio();
//   await dio.get('profile/logout');
// }

Widget headerWidget(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [
          Color.fromARGB(255, 0, 90, 129),
          Color.fromARGB(232, 255, 218, 218),
        ],
        stops: const [0.0, 0.9],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text("마이 페이지", style: TextStyle(fontSize: 25, color: Colors.white)),
        SizedBox(height: 30),
        Text("내 프로필을 수정하거나", style: TextStyle(fontSize: 14, color: Colors.white)),
        SizedBox(height: 10),
        Text("내가 등록한 코스와 코멘트를 볼 수 있어요", style: TextStyle(fontSize: 14, color: Colors.white)),
      ],
    ),
  );
}
