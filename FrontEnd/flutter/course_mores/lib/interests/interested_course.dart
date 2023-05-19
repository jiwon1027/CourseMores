import 'package:coursemores/controller/getx_controller.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import '../auth/auth_dio.dart';
import 'package:get/get.dart';
import '../course_search/course_detail.dart' as detail;
import 'package:cached_network_image/cached_network_image.dart';

import '../course_search/search.dart';

final interestController = Get.put(InterestedCourseInfo());

class InterestedCourse extends StatefulWidget {
  InterestedCourse({super.key});

  @override
  State<InterestedCourse> createState() => _InterestedCourseState();
}

class _InterestedCourseState extends State<InterestedCourse> {
  List<Map<String, Object>> courseList = interestController.interestedCourse;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final dio = await authDio();
    final response = await dio.get('interest');
    List<dynamic> data = response.data['myInterestCourseList'];
    interestController
        .saveInterestedCourse(data.map((item) => Map<String, Object>.from(item['coursePreviewResDto'])).toList());

    setState(() {
      courseList = interestController.interestedCourse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '관심 등록한 코스 : ${courseList.length}개',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
      headerWidget: headerWidget(context),
      headerExpandedHeight: 0.3,
      body: [
        MyInterestedCourse(),
      ],
      fullyStretchable: false,
      expandedBody: headerWidget(context),
      backgroundColor: Colors.white,
      appBarColor: Color.fromARGB(255, 80, 170, 208),
    );
  }
}

class MyInterestedCourse extends StatelessWidget {
  MyInterestedCourse({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(8),
        itemCount: interestController.interestedCourse.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () async {
              int courseId = (interestController.interestedCourse[index]['courseId'] as int);
              await searchController.changeNowCourseId(courseId: courseId);
              await detailController.changeNowIndex(courseId);
              await detailController.getCourseInfo('코스 소개');
              await detailController.getIsLikeCourse();
              await detailController.getIsInterestCourse();
              await detailController.getCourseDetailList();

              Get.to(detail.Detail());
            },
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
              padding: EdgeInsets.all(10),
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(255, 211, 211, 211),
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                    offset: Offset(3, 3)),
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
                            Expanded(child: MyInterestedCourseList(index: index)),
                          ]))),
                ],
              ),
            ),
          );
        },
      ),
    );

    // return SingleChildScrollView(
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(
    //       children: List.generate(
    //         interestController.interestedCourse.length,
    //         (index) {
    //           return Card(
    //             margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
    //             shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(10)),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Row(
    //                   children: [
    //                     Expanded(
    //                       child: InkWell(
    //                         onTap: () async {
    //                           int courseId = (interestController
    //                               .interestedCourse[index]['courseId'] as int);

    //                           await searchController.changeNowCourseId(
    //                               courseId: courseId);

    //                           await detailController.getCourseInfo('코스 소개');
    //                           await detailController.getIsLikeCourse();
    //                           await detailController.getIsInterestCourse();
    //                           await detailController.getCourseDetailList();

    //                           Get.to(() => detail.Detail());
    //                         },
    //                         child: Container(
    //                           margin: EdgeInsets.only(
    //                               left: 10, right: 10, top: 10, bottom: 5),
    //                           padding: EdgeInsets.all(10),
    //                           decoration: const BoxDecoration(
    //                               boxShadow: [
    //                                 BoxShadow(
    //                                     color:
    //                                         Color.fromARGB(255, 211, 211, 211),
    //                                     blurRadius: 10.0,
    //                                     spreadRadius: 1.0,
    //                                     offset: Offset(3, 3)),
    //                               ],
    //                               color: Colors.white,
    //                               borderRadius:
    //                                   BorderRadius.all(Radius.circular(10))),
    //                           child: Row(
    //                             mainAxisAlignment:
    //                                 MainAxisAlignment.spaceBetween,
    //                             children: [
    //                               Expanded(
    //                                   child: SizedBox(
    //                                       width: 300,
    //                                       child: Row(children: [
    //                                         ThumbnailImage(index: index),
    //                                         SizedBox(width: 10),
    //                                         Expanded(
    //                                             child: MyInterestedCourseList(
    //                                                 index: index)),
    //                                       ]))),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           );
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }
}

class MyInterestedCourseList extends StatelessWidget {
  MyInterestedCourseList({super.key, required this.index});
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
                      "${interestController.interestedCourse[index]['title']}",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ),
                  SizedBox(width: 10),
                  if (interestController.interestedCourse[index]["visited"] == true)
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
            if (interestController.interestedCourse[index]["interest"] == true)
              Icon(Icons.bookmark, size: 24, color: Colors.green[800]),
            if (interestController.interestedCourse[index]["interest"] == false)
              Icon(Icons.bookmark_outline_rounded, size: 24, color: Colors.green[800]),
          ],
        ),
        SizedBox(height: 2),
        Row(
          children: [
            Icon(Icons.map, size: 12, color: Colors.black38),
            SizedBox(width: 3),
            Text(
              "${interestController.interestedCourse[index]["sido"].toString()} ${interestController.interestedCourse[index]["gugun"].toString()}",
              style: TextStyle(fontSize: 10, color: Colors.black38),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
            SizedBox(width: 8),
            Icon(Icons.people, size: 12, color: Colors.black38),
            SizedBox(width: 3),
            Text(
              (interestController.interestedCourse[index]['people']! as int) <= 0
                  ? "상관 없음"
                  : (interestController.interestedCourse[index]['people']! as int) >= 5
                      ? "5명 이상"
                      : "${interestController.interestedCourse[index]['people']}명",
              style: TextStyle(fontSize: 10, color: Colors.black38),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
          ],
        ),
        SizedBox(height: 6),
        Text(
          "${interestController.interestedCourse[index]['content']}",
          style: TextStyle(fontSize: 12),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: true,
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${interestController.interestedCourse[index]['locationName']}",
              style: TextStyle(fontSize: 10, color: Colors.black45),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
            SizedBox(width: 8),
            Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite, size: 14, color: Colors.pink[300]),
                    SizedBox(width: 3),
                    Text(interestController.interestedCourse[index]["likeCount"].toString(),
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(width: 8),
                Row(
                  children: [
                    Icon(Icons.comment, size: 14),
                    SizedBox(width: 3),
                    Text(interestController.interestedCourse[index]["commentCount"].toString(),
                        style: TextStyle(fontSize: 12)),
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
        imageUrl: interestController.interestedCourse[index]['image'].toString(),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        height: 80,
        width: 80,
        fit: BoxFit.cover,
      ),
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
        Text("관심 등록한 코스", style: TextStyle(fontSize: 25, color: Colors.white)),
        SizedBox(height: 30),
        Text("나중에 가고 싶은 코스가 있다면", style: TextStyle(fontSize: 14, color: Colors.white)),
        SizedBox(height: 10),
        Text("관심 등록으로 저장해두고 볼 수 있어요", style: TextStyle(fontSize: 14, color: Colors.white)),
      ],
    ),
  );
}
