import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'course_list.dart' as course;
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
import 'package:like_button/like_button.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' show DateFormat;

class Detail extends StatelessWidget {
  Detail({Key? key}) : super(key: key);

class _CourseDetailState extends State<CourseDetail> {
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

    return DraggableHome(
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.settings, color: Colors.transparent)),
      ],
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [Text('코스 상세보기', style: TextStyle(color: Colors.white))],
      ),
      headerWidget: headerWidget(context),
      headerExpandedHeight: 0.3,
      body: [
        SingleChildScrollView(
          // controller: commentScrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ListView(
              //   children: [

              // 코스 정보
              DetailCourseInfo(),

              // 좋아요, 즐겨찾기, 공유하기, 가져오기
              DetailLikeBookmarkShareScrap(),

              // 코스 탭 (코스 소개, 코스 상세, 코멘트)
              DetailTaps(),
              // ],
              // ),
            ],
          ),
        ),
      ],
      fullyStretchable: false,
      backgroundColor: Colors.white,
      appBarColor: Color.fromARGB(255, 80, 170, 208),
      // appBarColor: Color.fromARGB(255, 248, 182, 182),
    );
  }
}

// class DetailTapSwitcher extends StatelessWidget {
//   DetailTapSwitcher({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.symmetric(vertical: 50),
//       child: Center(
//         child: Column(
//           children: [
//             AdvancedSegment(
//               controller: detailController.selectedSegment,
//               segments: detailController.segments,
//               backgroundColor: Color.fromARGB(255, 228, 220, 255),
//               activeStyle: TextStyle(
//                 color: Color.fromARGB(255, 93, 0, 255),
//                 fontWeight: FontWeight.w700,
//                 fontFamily: 'KyoboHandwriting2020pdy',
//               ),
//               itemPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class DetailTaps extends StatelessWidget {
  DetailTaps({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Column(
                children: [
                  AdvancedSegment(
                    inactiveStyle: TextStyle(fontFamily: 'SCDream5', fontSize: 12),
                    controller: detailController.selectedSegment,
                    segments: detailController.segments,
                    backgroundColor: Color.fromARGB(255, 228, 220, 255),
                    activeStyle: TextStyle(
                        color: Color.fromARGB(255, 93, 0, 255),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SCDream5',
                        fontSize: 12),
                    itemPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
                          return CourseDetail();
                        case '코멘트':
                          return CourseComments();
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
  State<DetailTapCourseComments> createState() =>
      _DetailTapCourseCommentsState();
}

class _DetailTapCourseCommentsState extends State<DetailTapCourseComments> {
  late var courseIndex = widget.courseIndex;

  late List commentsList =
      course.courseList[courseIndex]['comments_list'] as List;

  bool isCommentLatestSelected = true;
  bool isCommentPopularSelected = false;

  isCommentLatestSelectedClick() {
    setState(() {
      isCommentLatestSelected = true;
      isCommentPopularSelected = false;
      Fluttertoast.showToast(
        msg: "최신순 : $isCommentLatestSelected, 인기순 : $isCommentPopularSelected",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    });
  }

  isCommentPopularSelectedClick() {
    setState(() {
      isCommentLatestSelected = false;
      isCommentPopularSelected = true;
      Fluttertoast.showToast(
        msg: "최신순 : $isCommentLatestSelected, 인기순 : $isCommentPopularSelected",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Column(
        children: [
          DetailTapCourseCommentsCreateSection(courseIndex: courseIndex),
          SortButtonBar(
              isCommentLatestSelected: isCommentLatestSelected,
              isCommentPopularSelected: isCommentPopularSelected,
              isCommentLatestSelectedClick: isCommentLatestSelectedClick,
              isCommentPopularSelectedClick: isCommentPopularSelectedClick),
          SizedBox(
            height: commentsList.isEmpty ? null : 600,
            child:
                DetailTapCourseCommentsListSection(commentsList: commentsList),
          )
        ],
      ),
    );
  }
}

class SortButtonBar extends StatefulWidget {
  const SortButtonBar({
    Key? key,
    required this.isCommentLatestSelected,
    required this.isCommentPopularSelected,
    required this.isCommentLatestSelectedClick,
    required this.isCommentPopularSelectedClick,
  }) : super(key: key);

  final isCommentLatestSelected;
  final isCommentPopularSelected;
  final isCommentLatestSelectedClick;
  final isCommentPopularSelectedClick;

  @override
  State<SortButtonBar> createState() => _SortButtonBarState();
}

class _SortButtonBarState extends State<SortButtonBar> {
  late var isCommentLatestSelected = widget.isCommentLatestSelected;
  late var isCommentPopularSelected = widget.isCommentPopularSelected;
  late var isCommentLatestSelectedClick = widget.isCommentLatestSelectedClick;
  late var isCommentPopularSelectedClick = widget.isCommentPopularSelectedClick;

  @override
  void initState() {
    super.initState();
    isCommentLatestSelected = widget.isCommentLatestSelected;
    isCommentPopularSelected = widget.isCommentPopularSelected;
    isCommentLatestSelectedClick = widget.isCommentLatestSelectedClick;
    isCommentPopularSelectedClick = widget.isCommentPopularSelectedClick;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      height: 40,
      margin: EdgeInsets.only(top: 10),
      child: ButtonBar(
        buttonPadding: EdgeInsets.symmetric(horizontal: 0),
        alignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              isCommentLatestSelectedClick();
              isCommentLatestSelected = true;
              isCommentPopularSelected = false;
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(Size(30, 35)),
              elevation: MaterialStateProperty.all<double>(0),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
              foregroundColor: MaterialStateProperty.all<Color>(
                  isCommentLatestSelected ? Colors.blue : Colors.grey),
            ),
            child: const Text(
              '최신순',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              isCommentPopularSelectedClick();
              isCommentLatestSelected = false;
              isCommentPopularSelected = true;
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(Size(30, 35)),
              elevation: MaterialStateProperty.all<double>(0),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
              foregroundColor: MaterialStateProperty.all<Color>(
                  isCommentPopularSelected ? Colors.blue : Colors.grey),
            ),
            child: const Text(
              '인기순',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailTapCourseCommentsListSection extends StatelessWidget {
  const DetailTapCourseCommentsListSection({
    super.key,
    required this.commentsList,
  });

  final List commentsList;

  @override
  Widget build(BuildContext context) {
    return commentsList.isEmpty
        ? Container(
            margin: EdgeInsets.only(top: 50),
            child: Column(
              children: const [
                // Icon(Icons.tag_faces, color: Colors.black38, size: 70),
                Text("☺", style: TextStyle(fontSize: 70)),
                SizedBox(height: 20),
                Text("아직 코멘트가 없어요."),
                SizedBox(height: 10),
                Text("첫 작성자가 되어보시는 건 어떨까요?"),
              ],
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
            itemCount: commentsList.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 6,
                margin: EdgeInsets.fromLTRB(4, 10, 4, 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.account_circle),
                              SizedBox(width: 5),
                              Text(
                                commentsList[index]['user_name'],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.favorite_outline),
                              SizedBox(width: 5),
                              Text('${commentsList[index]['likes_cnt']}'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.calendar_month, size: 16),
                          SizedBox(width: 5),
                          Text('${commentsList[index]['date']}'),
                          SizedBox(width: 10),
                          Icon(Icons.people, size: 16),
                          SizedBox(width: 5),
                          Text('${commentsList[index]['people']}'),
                        ],
                      ),
                      SizedBox(height: 10),
                      SizedBox(height: 10),
                      Text('${commentsList[index]['text']}'),
                      SizedBox(height: 10),
                      ImageGridView(
                          commentImageList: commentsList[index]['images']),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

class ImageGridView extends StatelessWidget {
  const ImageGridView({
    Key? key,
    required this.commentImageList,
  }) : super(key: key);

  final List<String> commentImageList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: commentImageList.length > 3 ? 3 : commentImageList.length,
      itemBuilder: (context, imageIndex) {
        if (imageIndex == 2 && commentImageList.length > 3) {
          return Stack(
            children: [
              ImageInkWell(
                  commentImageList: commentImageList, imageIndex: imageIndex),
              Positioned(
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(100.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(2),
                    width: 94,
                    height: 94,
                    child: Center(
                      child: Text(
                        '+${commentImageList.length - 3}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return ImageInkWell(
              commentImageList: commentImageList, imageIndex: imageIndex);
        }
      },
    );
  }
}

class ImageInkWell extends StatelessWidget {
  const ImageInkWell({
    super.key,
    required this.commentImageList,
    required this.imageIndex,
  });

  final List<String> commentImageList;
  final imageIndex;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return CommentGallery(
              images: commentImageList,
              initialIndex: imageIndex,
            );
          },
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Hero(
          tag: 'image${commentImageList}_$imageIndex',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              commentImageList[imageIndex],
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
          ),
        ),
      ),
    );
  }
}

class CommentGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const CommentGallery({
    Key? key,
    required this.images,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<CommentGallery> createState() => _CommentGalleryState();
}

class _CommentGalleryState extends State<CommentGallery> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: AssetImage(widget.images[index]),
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes: PhotoViewHeroAttributes(
                  tag: 'image${widget.initialIndex}_$index',
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.0,
              );
            },
            itemCount: widget.images.length,
            pageController: PageController(initialPage: widget.initialIndex),
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          Positioned(
            top: 50,
            left: 30,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.images.map((image) {
                int index = widget.images.indexOf(image);
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Colors.grey.shade800
                        : Colors.grey.shade600,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailTapCourseCommentsCreateSection extends StatelessWidget {
  const DetailTapCourseCommentsCreateSection({
    super.key,
    required this.courseIndex,
  });

  final int courseIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 6,
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${(course.courseList[courseIndex]['comments_list'] as List<dynamic>).length}개의 코멘트가 있어요",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 8),
                  Text("코멘트를 남겨보세요"),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const comment.NewComment()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 115, 81, 255),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                elevation: 2,
                padding: const EdgeInsets.fromLTRB(20, 3, 20, 3),
              ),
              child: const Text(
                "작성하러 가기 →",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
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
  late CarouselController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Column(
        children: [
          CarouselSlider.builder(
            carouselController: _controller,
            options: CarouselOptions(
              height: 250,
              // 자동으로 넘어가게 하려면 autoPlay를 true로 설정할 것
              autoPlay: false,
              autoPlayInterval: const Duration(seconds: 10),
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  placeIndex = index;
                });
              },
              enableInfiniteScroll: false,
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
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  (course.courseList[courseIndex]['places'] as List<dynamic>)
                      .asMap()
                      .entries
                      .map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 10.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(placeIndex == entry.key ? 0.9 : 0.2)),
                  ),
                );
              }).toList()),
          SizedBox(height: 10),
          Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: Column(
                      children: [
                        ImageGridView(
                            commentImageList: (course.courseList[courseIndex]
                                    ['places'] as List<dynamic>)[placeIndex]
                                ['images']),
                        SizedBox(height: 15),
                        Text(
                          "${(course.courseList[courseIndex]['places'] as List<dynamic>)[placeIndex]['title']}",
                          // '''테스트 메시지. 테스트 메시지. 테스트 메시지. 테스트 메시지. 테스트 메시지. 테스트 메시지. ㄴ''',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${(course.courseList[courseIndex]['places'] as List<dynamic>)[placeIndex]['text']}",
                          // '''테스트 메시지. 테스트 메시지. 테스트 메시지. 테스트 메시지. 테스트 메시지. 테스트 메시지. ㄴ''',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            height: 1.7,
                          ),
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

  final List<LatLng> _markerPositions = [
    // LatLng(37.5665, 126.9780), // 서울역
    // LatLng(37.5547, 126.9707), // 광화문
    // LatLng(37.5719, 126.9768), // 종로3가
    // LatLng(37.5659, 126.9774), // 시청
    // LatLng(37.5702, 126.9832), // 청계천
    LatLng(37.5033214, 127.0384099), // 이도곰탕
    LatLng(37.5032488, 127.0387016), // 역삼 상도
    LatLng(37.5025164, 127.0372225), // 조선부뚜막 역삼점
    LatLng(37.501945, 127.0360264), // 한앤둘치킨 역삼점
    LatLng(37.4996299, 127.0358136), // 바스버거 역삼점
  ];

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
        height: 600,
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
          color: const Color.fromARGB(255, 46, 85, 57),
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
            const SizedBox(
              height: 10,
            ),
            Expanded(child: LineMap(markerPositions: _markerPositions)),
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
                "${(course.courseList[courseIndex]['places'] as List<dynamic>)[index]['title']}",
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
                          height: 1.3,
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
                          height: 1.7,
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

class DetailLikeBookmarkShareScrap extends StatelessWidget {
  DetailLikeBookmarkShareScrap({super.key});

  @override
  State<DetailLikeBookmarkShareScrap> createState() =>
      _DetailLikeBookmarkShareScrapState();
}

class _DetailLikeBookmarkShareScrapState
    extends State<DetailLikeBookmarkShareScrap> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 1, blurRadius: 7, offset: Offset(0, 3)),
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

class DetailLike extends StatelessWidget {
  DetailLike({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => LikeButton(
          likeBuilder: (isLiked) {
            return Icon(Icons.favorite, color: isLiked ? Colors.pink : Colors.black, size: 26);
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
  DetailDateViews({super.key});

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
                Icon(Icons.calendar_month, size: 18),
                SizedBox(width: 3),
                Text(DateFormat('yyyy. MM.dd').format(DateTime.parse(detailController.nowCourseInfo['createTime'])),
                    style: TextStyle(fontSize: 12)),
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
            Text(detailController.nowCourseInfo['viewCount'].toString(), style: TextStyle(fontSize: 12)),
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
        DetailPeople(),
        DetailTime(),
      ],
    );
  }
}

class DetailTag extends StatelessWidget {
  DetailTag({super.key});

  @override
  Widget build(BuildContext context) {
    Iterable<dynamic> hashtagList = detailController.nowCourseInfo['hashtagList'] as Iterable<dynamic>;

    return Wrap(
      spacing: 6,
      children: hashtagList.map((hashtag) {
        return Text("#$hashtag", style: TextStyle(fontSize: 12, color: Colors.blue[600]), softWrap: true);
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
            detailController.nowCourseInfo['time'] <= 1
                ? "1시간 이하"
                : detailController.nowCourseInfo['time'] >= 5
                    ? "4시간 이상"
                    : "${detailController.nowCourseInfo['time'] - 1}시간",
            style: TextStyle(fontSize: 12, color: Colors.black38)),
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
            detailController.nowCourseInfo['people'] <= 0
                ? "상관 없음"
                : detailController.nowCourseInfo['people'] >= 5
                    ? "5명 이상"
                    : "${detailController.nowCourseInfo['people']}명",
            style: TextStyle(fontSize: 12, color: Colors.black38)),
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
              builder: (context) => CourseMake(courseId: detailController.nowIndex.toString()),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [Icon(Icons.ios_share), SizedBox(height: 8), Text("코스 가져오기", style: TextStyle(fontSize: 12))],
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
    bool isKakaoTalkSharingAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();

    // 이후에 nowCourseDetail을 사용하여 locationDataList 구성
    List<Map<String, String>> locationDataList = [];
    for (int i = 0; i < detailController.nowCourseDetail.length; i++) {
      Map<String, dynamic> detail = detailController.nowCourseDetail[i];

      String title = detail['name'] ?? '';
      String sido = detail['sido'] ?? '';
      String gugun = detail['gugun'] ?? '';
      String address = '$sido $gugun';
      String picture = '';

      if (detail['locationImageList'] != null && detail['locationImageList'].isNotEmpty) {
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
      templateArgs['locationTitle${i + 1}'] = locationDataList[i]['locationTitle']!;
      templateArgs['locationAddress${i + 1}'] = locationDataList[i]['locationAddress']!;
      templateArgs['locationPicture${i + 1}'] = locationDataList[i]['locationPicture']!;
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
          Fluttertoast.showToast(
            msg: "카카오톡 공유가 실행됩니다\n잠시만 기다려주세요.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
          );
          _shareToKakaoTalk();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [Icon(Icons.share), SizedBox(height: 8), Text("공유하기", style: TextStyle(fontSize: 12))],
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
      themeList = detailController.nowCourseInfo['themeList'] as Iterable<dynamic>;
    } catch (e) {
      themeList = [];
      print(e);
    }

    return Wrap(
      runSpacing: -8,
      spacing: 6,
      children: themeList.map((theme) {
        return Chip(
          label: Text(theme['name'].toString()),
          backgroundColor: Color.fromARGB(255, 115, 81, 255),
          labelStyle: TextStyle(color: Colors.white, fontSize: 10),
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
      nickname = detailController.nowCourseInfo['simpleInfoOfWriter']['nickname'];
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
            Text("$nickname", style: TextStyle(fontSize: 13)),
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
  DetailAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.black54, // 아이콘 색깔
      ),
      title: const Text('CourseMores', style: TextStyle(color: Colors.black)),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.navigate_before),
        onPressed: () {
          Get.back();
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: Colors.black,
          ),
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
      if (detailController.nowCourseInfo['simpleInfoOfWriter']['profileImage'] != "default") {
        return ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: CachedNetworkImage(
              imageUrl: detailController.nowCourseInfo['simpleInfoOfWriter']['profileImage'],
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
            child: Image(image: AssetImage(image), height: 25, width: 25, fit: BoxFit.cover));
      }
    } catch (e) {
      print(e);
      const image = 'assets/default_profile.png';
      return Image(image: AssetImage(image), height: 25, width: 25, fit: BoxFit.cover);
    }
  }
}

class ThumbnailImage extends StatelessWidget {
  ThumbnailImage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image(image: AssetImage('assets/img1.jpg'), height: 150, width: 130, fit: BoxFit.cover),
    );
  }
}

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
        Text("코스 상세보기", style: TextStyle(fontSize: 25, color: Colors.white)),
        SizedBox(height: 30),
        Text("다른 사람의 코스를 구경하고", style: TextStyle(fontSize: 16, color: Colors.white)),
        SizedBox(height: 10),
        Text("마음에 들면 공유할 수 있어요", style: TextStyle(fontSize: 16, color: Colors.white)),
      ],
    ),
  );
}
