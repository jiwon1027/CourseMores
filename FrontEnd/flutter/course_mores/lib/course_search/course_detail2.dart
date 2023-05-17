import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../notification/notification.dart' as noti;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import './search.dart';
import 'course_detail_tap_intro.dart';
import 'course_detail_tap_detail.dart';
import 'course_detail_tap_comment.dart';
import 'package:coursemores/course_make/make2.dart';
import 'package:coursemores/course_modify/modify2.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class Detail2 extends StatelessWidget {
  Detail2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    detailController.getCourseInfo('코스 소개');
    try {
      return Scaffold(
        appBar: DetailAppBar(),
        body: ListView(
          children: [
            // 코스 정보
            DetailCourseInfo(),

            // 좋아요, 즐겨찾기, 공유하기, 가져오기
            DetailLikeBookmarkShareScrap(),

            // 코스 탭 (코스 소개, 코스 상세, 코멘트)
            DetailTaps(),
          ],
        ),
      );
    } catch (e) {
      print(e);
      return Scaffold(
        appBar: DetailAppBar(),
        body: ListView(children: [Container()]),
      );
    }
  }
}

class DetailTapSwitcher extends StatelessWidget {
  DetailTapSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 50),
      child: Center(
        child: Column(
          children: [
            AdvancedSegment(
              controller: detailController.selectedSegment,
              segments: detailController.segments,
              backgroundColor: Color.fromARGB(255, 228, 220, 255),
              activeStyle: TextStyle(
                color: Color.fromARGB(255, 93, 0, 255),
                fontWeight: FontWeight.w700,
                fontFamily: 'KyoboHandwriting2020pdy',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailTaps extends StatelessWidget {
  DetailTaps({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              color: Color.fromARGB(255, 211, 211, 211),
              blurRadius: 10.0,
              spreadRadius: 1.0,
              offset: Offset(3, 3))
        ],
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Column(
                children: [
                  AdvancedSegment(
                    inactiveStyle: TextStyle(fontFamily: 'SCDream5'),
                    controller: detailController.selectedSegment,
                    segments: detailController.segments,
                    backgroundColor: Color.fromARGB(255, 228, 220, 255),
                    activeStyle: TextStyle(
                        color: Color.fromARGB(255, 93, 0, 255),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SCDream5'),
                  ),
                  ValueListenableBuilder(
                    valueListenable: detailController.selectedSegment,
                    builder:
                        (BuildContext context, dynamic value, Widget? child) {
                      switch (value) {
                        case '코스 소개':
                          return CourseIntroduction();
                        case '코스 상세':
                          return CourseDetail();
                        case '코멘트':
                          return CourseComments();
                        // return DetailTapCourseComments(courseIndex: index);
                        default:
                          return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailCourseInfo extends StatelessWidget {
  DetailCourseInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(255, 211, 211, 211),
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                    offset: Offset(3, 3)),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: SizedBox(
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DetailUserVisited(),
                          SizedBox(height: 10),
                          // 제목 라인
                          Text(
                            "${detailController.nowCourseInfo['title']}",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1.3),
                            softWrap: true,
                          ),
                          SizedBox(height: 10),
                          // 지역, 인원 수, 소요시간 라인
                          DetailAddressPeopleTime(),
                          SizedBox(height: 10),
                          // 본문 텍스트 라인
                          Text("${detailController.nowCourseInfo['content']}",
                              style: TextStyle(height: 1.7)),
                          SizedBox(height: 10),
                          // 테마 라인
                          DetailTheme(),
                          SizedBox(height: 10),
                          // 해시태그 라인
                          DetailTag(),
                          SizedBox(height: 10),
                          // 작성일자, 조회수 라인
                          DetailDateViews(),
                          if (detailController.nowCourseInfo['write'])
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(height: 15),
                                Expanded(child: Container()),
                                TextButton(
                                    onPressed: () async {
                                      // TODO: 이곳에 코스 수정하기 API 연결
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CourseModify(
                                                  courseId: detailController
                                                      .nowIndex
                                                      .toString(),
                                                )),
                                      );
                                    },
                                    child: Text("수정")),
                                TextButton(
                                  onPressed: () async {
                                    print(detailController.nowIndex);
                                    bool confirmed = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("코스 삭제"),
                                          content: Text("정말로 삭제하시겠습니까?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(
                                                    true); // 확인 버튼을 누를 때 true 반환
                                              },
                                              child: Text("확인"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(
                                                    false); // 취소 버튼을 누를 때 false 반환
                                              },
                                              child: Text("취소"),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirmed == true) {
                                      // TODO: 삭제하기 API 연결
                                      detailController.deleteCourse();
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Text("삭제"),
                                ),
                              ],
                            ),
                        ],
                      ))),
            ],
          ),
        ));
  }
}

class DetailLikeBookmarkShareScrap extends StatelessWidget {
  DetailLikeBookmarkShareScrap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 3)),
        ],
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DetailLike(),
          DetailInterest(),
          DetailShare(),
          DetailScrap(),
        ],
      ),
    );
  }
}

class DetailInterest extends StatelessWidget {
  DetailInterest({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: InkWell(
            onTap: () {
              if (!detailController.isInterestCourse.value) {
                detailController.addIsInterestCourse();
              } else {
                detailController.deleteIsInterestCourse();
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (detailController.isInterestCourse.value)
                  Icon(Icons.bookmark),
                if (!detailController.isInterestCourse.value)
                  Icon(Icons.bookmark_outline),
                SizedBox(height: 5),
                Text(detailController.nowCourseInfo['interestCount'].toString(),
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ));
  }
}

class DetailLike extends StatelessWidget {
  DetailLike({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() => InkWell(
          onTap: () {
            if (!detailController.isLikeCourse.value) {
              detailController.addIsLikeCourse();
            } else {
              detailController.deleteIsLikeCourse();
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (detailController.isLikeCourse.value) Icon(Icons.favorite),
              if (!detailController.isLikeCourse.value)
                Icon(Icons.favorite_outline),
              SizedBox(height: 5),
              Text(detailController.nowCourseInfo['likeCount'].toString(),
                  style: TextStyle(fontSize: 16)),
            ],
          ))),
    );
  }
}

class DetailDateViews extends StatelessWidget {
  DetailDateViews({super.key});
  final createTime = detailController.nowCourseInfo['createTime'] ?? "";
  late final year;
  late final month;
  late final date;

  @override
  Widget build(BuildContext context) {
    try {
      year = createTime.substring(0, 4);
      month = createTime.substring(5, 7);
      date = createTime.substring(8, 10);
    } catch (e) {
      year = "";
      month = "";
      date = "";
      print(e);
    }
    return Row(
      children: [
        // 작성일자
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                Icon(Icons.calendar_month, size: 12),
                SizedBox(width: 3),
                Text("$year. $month. $date", style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
        SizedBox(width: 10),
        // 조회수
        Row(
          children: [
            Icon(Icons.remove_red_eye, size: 16),
            SizedBox(width: 3),
            Text(detailController.nowCourseInfo['viewCount'].toString(),
                style: TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }
}

class DetailAddressPeopleTime extends StatelessWidget {
  DetailAddressPeopleTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 지역 아이콘 & 텍스트
        Icon(Icons.location_pin, size: 14, color: Colors.black38),
        SizedBox(width: 3),
        // "지역",
        Text(
          "${detailController.nowCourseInfo['sido']} ${detailController.nowCourseInfo['gugun']}",
          style: TextStyle(fontSize: 12, color: Colors.black38),
        ),
        // 추천인원 수가 0이 아니면 보여짐
        if (detailController.nowCourseInfo['people'] != 0) DetailPeople(),
        // 소요시간이 0이 아니면 보여짐
        if (detailController.nowCourseInfo['time'] != 0) DetailTime(),
      ],
    );
  }
}

class DetailTag extends StatelessWidget {
  DetailTag({super.key});

  @override
  Widget build(BuildContext context) {
    Iterable<dynamic> hashtagList =
        detailController.nowCourseInfo['hashtagList'] as Iterable<dynamic>;

    return Wrap(
      spacing: 6,
      children: hashtagList.map((hashtag) {
        return Text("#$hashtag",
            style: TextStyle(fontSize: 12, color: Colors.blue[600]),
            softWrap: true);
      }).toList(),
    );
  }
}

class DetailTime extends StatelessWidget {
  DetailTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 5),
        Icon(Icons.timer, size: 14, color: Colors.black38),
        SizedBox(width: 3),
        Text(
          "${detailController.nowCourseInfo['time']}시간",
          style: TextStyle(fontSize: 12, color: Colors.black38),
        ),
      ],
    );
  }
}

class DetailPeople extends StatelessWidget {
  DetailPeople({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 5),
        Icon(Icons.people, size: 14, color: Colors.black38),
        SizedBox(width: 3),
        Text(
          "${detailController.nowCourseInfo['people']}명",
          style: TextStyle(fontSize: 12, color: Colors.black38),
        ),
      ],
    );
  }
}

class DetailScrap extends StatelessWidget {
  const DetailScrap({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Fluttertoast.showToast(
            msg: "코스 가져오기 실행!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          // Navigate to the CourseMake screen with the course ID
          // Get.to(
          //     () => CourseMake(courseId: detailController.nowIndex.toString()));
          print('99999');
          print(detailController.nowIndex);
          // 컨트롤러 인스턴스 초기화
          // final courseController = Get.put(CourseController());
          // courseController.title.value = '';
          // courseController.content.value = '';
          // courseController.people.value = 0;
          // courseController.time.value = 0;
          // courseController.visited.value = false;
          // courseController.locationList.clear();
          // courseController.hashtagList.clear();
          // courseController.themeIdList.clear();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CourseMake(courseId: detailController.nowIndex.toString()),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.ios_share),
            SizedBox(height: 8),
            Text("코스 가져오기")
          ],
        ),
      ),
    );
  }
}

class DetailShare extends StatelessWidget {
  DetailShare({super.key});

  Future<void> _shareToKakaoTalk() async {
    // 사용자 정의 템플릿 ID
    int templateId = 93826;
    // 카카오톡 실행 가능 여부 확인
    bool isKakaoTalkSharingAvailable =
        await ShareClient.instance.isKakaoTalkSharingAvailable();

    // 이후에 nowCourseDetail을 사용하여 locationDataList 구성
    List<Map<String, String>> locationDataList = [];
    for (int i = 0; i < detailController.nowCourseDetail.length; i++) {
      Map<String, dynamic> detail = detailController.nowCourseDetail[i];

      String title = detail['name'] ?? '';
      String sido = detail['sido'] ?? '';
      String gugun = detail['gugun'] ?? '';
      String address = '$sido $gugun';
      String picture = '';

      if (detail['locationImageList'] != null &&
          detail['locationImageList'].isNotEmpty) {
        picture = detail['locationImageList'][0] ?? '';
      } else {
        picture = detail['roadViewImage'] ?? '';
      }

      // String picture = detail['roadViewImage'];
      print(detail);

      Map<String, String> locationData = {
        'locationTitle': title,
        'locationAddress': address,
        'locationPicture': picture,
      };
      locationDataList.add(locationData);
    }
    print(locationDataList);

    Map<String, String> templateArgs = {
      'courseTitle': detailController.nowCourseInfo['title'] ?? '',
    };

    // Add location data to templateArgs
    for (int i = 0; i < locationDataList.length; i++) {
      templateArgs['locationTitle${i + 1}'] =
          locationDataList[i]['locationTitle']!;
      templateArgs['locationAddress${i + 1}'] =
          locationDataList[i]['locationAddress']!;
      templateArgs['locationPicture${i + 1}'] =
          locationDataList[i]['locationPicture']!;
    }

    if (isKakaoTalkSharingAvailable) {
      try {
        Uri uri = await ShareClient.instance.shareCustom(
          templateId: templateId,
          templateArgs: templateArgs,
        );
        await ShareClient.instance.launchKakaoTalk(uri);
        print('카카오톡 공유 완료');
      } catch (error) {
        print('카카오톡 공유 실패 $error');
      }
    } else {
      try {
        // // 호출하여 nowCourseDetail 업데이트
        // await detailcontroller.getCourseDetailList();

        Uri shareUrl = await WebSharerClient.instance.makeCustomUrl(
          templateId: templateId,
          templateArgs: templateArgs,
        );
        await launchBrowserTab(shareUrl, popupOpen: true);
      } catch (error) {
        print('카카오톡 공유 실패 $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          _shareToKakaoTalk();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.share),
            SizedBox(height: 8),
            Text("공유하기")
          ],
        ),
      ),
    );
  }
}

class DetailTheme extends StatelessWidget {
  DetailTheme({Key? key}) : super(key: key);
  late final Iterable<dynamic> themeList;

  @override
  Widget build(BuildContext context) {
    try {
      themeList =
          detailController.nowCourseInfo['themeList'] as Iterable<dynamic>;
    } catch (e) {
      themeList = [];
      print(e);
    }

    return Wrap(
      spacing: 6,
      children: themeList.map((theme) {
        return Chip(
          label: Text(theme['name'].toString()),
          backgroundColor: Color.fromARGB(255, 115, 81, 255),
          labelStyle: TextStyle(color: Colors.white, fontSize: 12),
        );
      }).toList(),
    );
  }
}

class DetailUserVisited extends StatelessWidget {
  DetailUserVisited({super.key});

  late final nickname;

  @override
  Widget build(BuildContext context) {
    try {
      nickname =
          detailController.nowCourseInfo['simpleInfoOfWriter']['nickname'];
    } catch (e) {
      nickname = "";
      print(e);
    }

    return Row(
      // 작성자 정보, 방문여부 라인
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 작성자 프로필 이미지, 작성자명
        Row(
          children: [
            // 작성자 프로필 이미지 연결
            ProfileImage(),
            SizedBox(width: 5),
            // 작성자명
            Text("$nickname", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
          ],
        ),
        // 방문여부
        Row(
          children: [
            // 방문한 곳이면 방문 체크 표시
            if (detailController.nowCourseInfo["visited"])
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 107, 211, 66),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.check, size: 14, color: Colors.white),
                    ),
                    Text("방문",
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                    SizedBox(width: 7),
                  ],
                ),
              )
          ],
        ),
      ],
    );
  }
}

class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  DetailAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black54),
      title: Text('CourseMores', style: TextStyle(color: Colors.black)),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.navigate_before),
        onPressed: () {
          Get.back();
        },
      ),
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

class ProfileImage extends StatelessWidget {
  ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      if (detailController.nowCourseInfo['simpleInfoOfWriter']
              ['profileImage'] !=
          "default") {
        return ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: CachedNetworkImage(
              imageUrl: detailController.nowCourseInfo['simpleInfoOfWriter']
                  ['profileImage'],
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              height: 25,
              width: 25,
              fit: BoxFit.cover,
            ));
      } else {
        const image = 'assets/default_profile.png';
        return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            clipBehavior: Clip.hardEdge,
            child: Image(
                image: AssetImage(image),
                height: 25,
                width: 25,
                fit: BoxFit.cover));
      }
    } catch (e) {
      print(e);
      const image = 'assets/default_profile.png';
      return Image(
          image: AssetImage(image), height: 25, width: 25, fit: BoxFit.cover);
    }
  }
}

class ThumbnailImage extends StatelessWidget {
  ThumbnailImage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image(
          image: AssetImage('assets/img1.jpg'),
          height: 150,
          width: 130,
          fit: BoxFit.cover),
    );
  }
}
