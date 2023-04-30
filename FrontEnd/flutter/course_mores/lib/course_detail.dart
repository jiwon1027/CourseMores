import 'package:flutter/material.dart';
import 'course_list.dart' as course;
import 'notification.dart' as noti;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:flip_card/flip_card.dart';
import 'package:timelines/timelines.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:multi_image_layout/multi_image_layout.dart';
// import 'package:galleryimage/galleryimage.dart';

class CourseDetail extends StatefulWidget {
  const CourseDetail({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  // ignore: library_private_types_in_public_api
  _CourseDetailState createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  // ignore: non_constant_identifier_names
  late var courseInfo = course.courseList[widget.index];
  late var themes = course.courseList[widget.index]['theme'].toString();
  late List<String> themeList =
      themes.substring(1, themes.length - 1).split(", ");
  late var tags = courseInfo['tag'].toString();
  late List<String> tagList = tags.substring(1, tags.length - 1).split(", ");

  @override
  Widget build(BuildContext context) {
    var index = widget.index;
    return Scaffold(
      appBar: const DetailAppBar(),
      body: ListView(
        children: [
          // 코스 정보 (바뀌지 않을 정보들)
          DetailCourseInfo(
              courseInfo: courseInfo,
              index: index,
              themeList: themeList,
              tagList: tagList),

          // 좋아요, 즐겨찾기, 공유하기, 가져오기
          DetailLikeBookmarkShareScrap(index: widget.index),

          // 코스 탭 (코스 소개, 코스 상세, 코멘트)
          DetailTaps(index: index),
        ],
      ),
    );
  }
}

class DetailTapSwitcher extends StatefulWidget {
  const DetailTapSwitcher({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DetailTapSwitcherState createState() => _DetailTapSwitcherState();
}

class _DetailTapSwitcherState extends State<DetailTapSwitcher> {
  final _selectedSegment = ValueNotifier('코스 소개');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        vertical: 50,
      ),
      child: Center(
        child: Column(
          children: [
            AdvancedSegment(
              controller: _selectedSegment,
              segments: const {
                '코스 소개': '코스 소개',
                '코스 상세': '코스 상세',
                '코멘트': '코멘트',
              },
              backgroundColor: const Color.fromARGB(255, 228, 220, 255),
              activeStyle: const TextStyle(
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

class DetailTaps extends StatefulWidget {
  const DetailTaps({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<DetailTaps> createState() => _DetailTapsState();
}

class _DetailTapsState extends State<DetailTaps> {
  late var index = widget.index;
  final _selectedSegment = ValueNotifier('코스 소개');

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 211, 211, 211),
            blurRadius: 10.0,
            spreadRadius: 1.0,
            offset: Offset(3, 3),
          ),
        ],
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Column(
                children: [
                  AdvancedSegment(
                    inactiveStyle: const TextStyle(
                      fontFamily: 'SCDream5',
                    ),
                    controller: _selectedSegment,
                    segments: const {
                      '코스 소개': '코스 소개',
                      '코스 상세': '코스 상세',
                      '코멘트': '코멘트',
                    },
                    backgroundColor: const Color.fromARGB(255, 228, 220, 255),
                    activeStyle: const TextStyle(
                      color: Color.fromARGB(255, 93, 0, 255),
                      fontWeight: FontWeight.w700,
                      fontFamily: 'SCDream5',
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: _selectedSegment,
                    builder:
                        (BuildContext context, dynamic value, Widget? child) {
                      switch (value) {
                        case '코스 소개':
                          return DetailTapCourseIntroduction(
                              courseIndex: index);
                        case '코스 상세':
                          return DetailTapCoursePlaces(courseIndex: index);
                        case '코멘트':
                          return const Text('코멘트 화면');
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

class DetailTapCoursePlaces extends StatefulWidget {
  const DetailTapCoursePlaces({
    super.key,
    required this.courseIndex,
  });

  final int courseIndex;

  @override
  State<DetailTapCoursePlaces> createState() => _DetailTapCoursePlacesState();
}

class _DetailTapCoursePlacesState extends State<DetailTapCoursePlaces> {
  late var courseIndex = widget.courseIndex;
  var placeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Column(
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
              height: 250,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 10),
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  placeIndex = index;
                });
              },
            ),
            itemCount:
                (course.courseList[courseIndex]['places'] as List<dynamic>)
                    .length,
            itemBuilder: (context, index, realIndex) => Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.fromLTRB(10, 20, 10, 30),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/img1.jpg'),
                    fit: BoxFit.cover,
                  ),
                  color: const Color.fromARGB(255, 241, 241, 241),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 157, 157, 157),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                            colors: [Colors.black, Colors.transparent],
                          )),
                          child: Text(
                            "${index + 1}. ${(course.courseList[courseIndex]['places'] as List<dynamic>)[index]['name']}",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  // MultiImageViewer(
                  //   images: [
                  //     "https://picsum.photos/id/1/200/300",
                  //     "https://picsum.photos/id/2/200/300",
                  //     "https://picsum.photos/id/3/200/300",
                  //   ],
                  //   height: 200,
                  //   width: 300,
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Text(
                          "${(course.courseList[courseIndex]['places'] as List<dynamic>)[placeIndex]['title']}",
                          // '''테스트 메시지. 테스트 메시지. 테스트 메시지. 테스트 메시지. 테스트 메시지. 테스트 메시지. ㄴ''',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${(course.courseList[courseIndex]['places'] as List<dynamic>)[placeIndex]['text']}",
                          // '''테스트 메시지. 테스트 메시지. 테스트 메시지. 테스트 메시지. 테스트 메시지. 테스트 메시지. ㄴ''',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ],
                    ),
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

class DetailTapCourseIntroduction extends StatefulWidget {
  const DetailTapCourseIntroduction({
    super.key,
    required this.courseIndex,
  });

  final int courseIndex;

  @override
  State<DetailTapCourseIntroduction> createState() =>
      _DetailTapCourseIntroductionState();
}

class _DetailTapCourseIntroductionState
    extends State<DetailTapCourseIntroduction> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  late var courseIndex = widget.courseIndex;

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      key: cardKey,
      fill: Fill.fillBack,
      flipOnTouch: false,
      alignment: Alignment.topRight,
      front: Container(
        alignment: Alignment.topRight,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 46, 85, 57),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.fromLTRB(0, 30, 0, 30),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        width: double.infinity,
        height: 650,
        child: Expanded(
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              DetailCourseIntroductionChangeButton(
                cardKey: cardKey,
                icon: Icons.map,
                text: "지도로 보기",
              ),
              const SizedBox(
                height: 10,
              ),
              DetailTapCourseIntroductionTimeline(courseIndex: courseIndex)
            ],
          ),
        ),
      ),
      back: Container(
        alignment: Alignment.topRight,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.fromLTRB(0, 30, 0, 30),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        width: double.infinity,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DetailCourseIntroductionChangeButton(
              cardKey: cardKey,
              icon: Icons.image_rounded,
              text: "코스로 보기",
            ),
          ],
        ),
      ),
    );
  }
}

class DetailTapCourseIntroductionTimeline extends StatelessWidget {
  const DetailTapCourseIntroductionTimeline({
    super.key,
    required this.courseIndex,
  });

  final int courseIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FixedTimeline.tileBuilder(
        theme: TimelineThemeData(
            connectorTheme: const ConnectorThemeData(
                color: Color.fromARGB(69, 255, 255, 255), space: 30),
            indicatorTheme: const IndicatorThemeData(
                color: Color.fromARGB(255, 141, 233, 127))),
        builder: TimelineTileBuilder.connectedFromStyle(
          contentsAlign: ContentsAlign.alternating,
          contentsBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
                "${(course.courseList[courseIndex]['places'] as List<dynamic>)[index]['text']}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'KyoboHandwriting2020pdy',
                )),
          ),
          oppositeContentsBuilder: (context, index) => Card(
            elevation: 6,
            child: Container(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  const ThumbnailImage(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "${(course.courseList[courseIndex]['places'] as List<dynamic>)[index]['name']}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'KyoboHandwriting2020pdy',
                        )),
                  ),
                ],
              ),
            ),
          ),
          connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
          indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
          itemCount: (course.courseList[courseIndex]['places'] as List<dynamic>)
              .length,
        ),
      ),
    );
  }
}

class DetailCourseIntroductionChangeButton extends StatelessWidget {
  const DetailCourseIntroductionChangeButton({
    super.key,
    required this.cardKey,
    required this.icon,
    required this.text,
  });

  final GlobalKey<FlipCardState> cardKey;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        cardKey.currentState?.toggleCard();
      },
      icon: Icon(icon, color: Colors.white, size: 18),
      label: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 115, 81, 255),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        elevation: 2,
        padding: const EdgeInsets.fromLTRB(20, 3, 20, 3),
      ),
    );
  }
}

class DetailCourseInfo extends StatefulWidget {
  const DetailCourseInfo({
    super.key,
    required this.courseInfo,
    required this.index,
    required this.themeList,
    required this.tagList,
  });

  final Map<String, Object> courseInfo;
  final int index;
  final List<String> themeList;
  final List<String> tagList;

  @override
  State<DetailCourseInfo> createState() => _DetailCourseInfoState();
}

class _DetailCourseInfoState extends State<DetailCourseInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                // color: Colors.white24,
                color: Color.fromARGB(255, 211, 211, 211),
                blurRadius: 10.0,
                spreadRadius: 1.0,
                offset: Offset(3, 3)),
          ],
          color: Color.fromARGB(255, 255, 255, 255),
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
                      DetailUserVisited(courseInfo: widget.courseInfo),
                      const SizedBox(height: 10),
                      // 제목 라인
                      Text(
                        "${widget.courseInfo['course']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                      ),
                      const SizedBox(height: 10),
                      // 지역, 인원 수, 소요시간 라인
                      DetailAddressPeopleTime(
                          courseInfo: widget.courseInfo, index: widget.index),
                      const SizedBox(height: 10),
                      // 본문 텍스트 라인
                      Text(
                        "${widget.courseInfo['text']}",
                        style: const TextStyle(
                            // fontSize: 14,
                            ),
                      ),
                      const SizedBox(height: 10),
                      // 테마 라인
                      DetailTheme(themeList: widget.themeList),
                      const SizedBox(height: 10),
                      // 해시태그 라인
                      DetailTag(tagList: widget.tagList),
                      const SizedBox(height: 10),
                      // 작성일자, 조회수 라인
                      DetailDateViews(index: widget.index),
                      // SizedBox(height: 30),
                      // 좋아요, 즐겨찾기, 공유하기, 가져오기 라인
                      // DetailLikeBookmarkShareScrap(index: widget.index),
                    ],
                  ))),
        ],
      ),
    );
  }
}

class DetailLikeBookmarkShareScrap extends StatefulWidget {
  const DetailLikeBookmarkShareScrap({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<DetailLikeBookmarkShareScrap> createState() =>
      _DetailLikeBookmarkShareScrapState();
}

class _DetailLikeBookmarkShareScrapState
    extends State<DetailLikeBookmarkShareScrap> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      // padding: const EdgeInsets.all(20),
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DetailLikes(index: widget.index),
          DetailBookmark(index: widget.index),
          const DetailShare(),
          const DetailScrap(),
        ],
      ),
    );
  }
}

class DetailBookmark extends StatefulWidget {
  const DetailBookmark({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<DetailBookmark> createState() => _DetailBookmarkState();
}

class _DetailBookmarkState extends State<DetailBookmark> {
  late var index = widget.index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            if (course.courseList[index]['bookmark'] == true) {
              course.courseList[index]['bookmark'] = false;
              course.courseList[index]['bookmark_cnt'] =
                  (course.courseList[index]['bookmark_cnt'] as int) - 1;
            } else if (course.courseList[index]['bookmark'] == false) {
              course.courseList[index]['bookmark'] = true;
              course.courseList[index]['bookmark_cnt'] =
                  (course.courseList[index]['bookmark_cnt'] as int) + 1;
            }
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (course.courseList[index]['bookmark'] == true)
              const Icon(Icons.bookmark),
            if (course.courseList[index]['bookmark'] == false)
              const Icon(Icons.bookmark_outline),
            const SizedBox(height: 5),
            Text(
              course.courseList[index]['bookmark_cnt'].toString(),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailLikes extends StatefulWidget {
  const DetailLikes({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<DetailLikes> createState() => _DetailLikesState();
}

class _DetailLikesState extends State<DetailLikes> {
  late var index = widget.index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
          onTap: () {
            setState(() {
              if (course.courseList[index]['likes'] == false) {
                // print("좋아요");
                course.courseList[index]['likes'] = true;
                course.courseList[widget.index]['likes_cnt'] =
                    (course.courseList[widget.index]['likes_cnt'] as int) + 1;
              } else {
                // print("좋아요 취소");
                course.courseList[index]['likes'] = false;
                course.courseList[widget.index]['likes_cnt'] =
                    (course.courseList[widget.index]['likes_cnt'] as int) - 1;
              }
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (course.courseList[index]['likes'] == true)
                const Icon(Icons.favorite),
              if (course.courseList[index]['likes'] == false)
                const Icon(Icons.favorite_outline),
              const SizedBox(height: 5),
              Text(
                course.courseList[widget.index]['likes_cnt'].toString(),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          )),
    );
  }
}

class DetailDateViews extends StatelessWidget {
  const DetailDateViews({
    super.key,
    required this.index,
  });
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 작성일자
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                const Icon(Icons.calendar_month, size: 12),
                const SizedBox(width: 3),
                Text(
                  "${course.courseList[index]['date']}",
                  // "작성일자",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        // 조회수
        Row(
          children: [
            const Icon(Icons.remove_red_eye, size: 16),
            const SizedBox(width: 3),
            Text(
              course.courseList[index]['views'].toString(),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}

class DetailAddressPeopleTime extends StatelessWidget {
  const DetailAddressPeopleTime({
    super.key,
    required this.courseInfo,
    required this.index,
  });

  final Map<String, Object> courseInfo;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 지역 아이콘 & 텍스트
        const Icon(
          Icons.location_pin,
          size: 14,
          color: Colors.black38,
        ),
        const SizedBox(width: 3),
        Text(
          // "지역",
          "${courseInfo['address']}",
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black38,
          ),
        ),
        // 추천인원 수가 0이 아니면 보여짐
        if (courseInfo['people'] != 0) DetailPeople(index: index),
        // 소요시간이 0이 아니면 보여짐
        if (courseInfo['time'] != 0) DetailTime(index: index),
      ],
    );
  }
}

class DetailTag extends StatelessWidget {
  const DetailTag({
    super.key,
    required this.tagList,
  });

  final List<String> tagList;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 3,
      runSpacing: 4,
      children: tagList.map((tag) {
        return Text(
          "#$tag",
          style: TextStyle(
            fontSize: 12,
            color: Colors.blue[600],
          ),
          softWrap: true,
        );
      }).toList(),
    );
  }
}

class DetailTime extends StatelessWidget {
  const DetailTime({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 5),
        const Icon(
          Icons.timer,
          size: 14,
          color: Colors.black38,
        ),
        const SizedBox(width: 3),
        Text(
          "${course.courseList[index]['time'].toString()}시간",
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black38,
          ),
        ),
      ],
    );
  }
}

class DetailPeople extends StatelessWidget {
  const DetailPeople({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 5),
        const Icon(
          Icons.people,
          size: 14,
          color: Colors.black38,
        ),
        const SizedBox(width: 3),
        Text(
          "${course.courseList[index]['people'].toString()}명",
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black38,
          ),
        ),
      ],
    );
  }
}

class DetailScrap extends StatelessWidget {
  const DetailScrap({
    super.key,
  });

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
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.ios_share),
            SizedBox(height: 8),
            Text("코스 가져오기"),
          ],
        ),
      ),
    );
  }
}

class DetailShare extends StatelessWidget {
  const DetailShare({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Fluttertoast.showToast(
            msg: "공유하기 실행!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.share),
            SizedBox(height: 8),
            Text("공유하기"),
          ],
        ),
      ),
    );
  }
}

class DetailTheme extends StatelessWidget {
  const DetailTheme({
    super.key,
    required this.themeList,
  });

  final List<String> themeList;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: themeList.map((theme) {
        return Chip(
          label: Text(theme),
          backgroundColor: const Color.fromARGB(255, 115, 81, 255),
          labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
        );
      }).toList(),
    );
  }
}

class DetailUserVisited extends StatelessWidget {
  const DetailUserVisited({
    super.key,
    required this.courseInfo,
  });

  final Map<String, Object> courseInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      // 작성자 정보, 방문여부 라인
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 작성자 프로필 이미지, 작성자명
        Row(
          children: [
            // 작성자 프로필 이미지 연결
            const ProfileImage(),
            const SizedBox(
              width: 5,
            ),
            // 작성자명
            Text("${courseInfo['author']}",
                style: const TextStyle(
                  // fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
        // 방문여부
        Row(
          children: [
            // 방문한 곳이면 방문 체크 표시
            if (courseInfo["visited"] == true)
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 107, 211, 66),
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
                    SizedBox(
                      width: 7,
                    ),
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
  const DetailAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.black54, // 아이콘 색깔
      ),
      title: const Text('CourseMores', style: TextStyle(color: Colors.black)),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.navigate_before),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
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

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: const Image(
        image: AssetImage('assets/img1.jpg'),
        height: 25,
        width: 25,
        fit: BoxFit.cover,
      ),
    );
  }
}

class ThumbnailImage extends StatelessWidget {
  const ThumbnailImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: const Image(
        image: AssetImage('assets/img1.jpg'),
        height: 150,
        width: 130,
        fit: BoxFit.cover,
      ),
    );
  }
}
