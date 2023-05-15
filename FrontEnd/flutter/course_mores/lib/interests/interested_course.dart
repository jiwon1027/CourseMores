import 'package:coursemores/controller/detail_controller.dart';
import 'package:coursemores/controller/getx_controller.dart';
import 'package:coursemores/controller/search_controller.dart';
import 'package:flutter/material.dart';
import '../auth/auth_dio.dart';
import 'package:get/get.dart';
import '../course_search/course_detail.dart' as detail;
import 'package:cached_network_image/cached_network_image.dart';

final interestController = Get.put(InterestedCourseInfo());
final searchController = Get.put(SearchController());
final detailController = Get.put(DetailController());

class InterestedCourse extends StatefulWidget {
  const InterestedCourse({super.key});

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
    // List<dynamic> data = response.data['myInterestCourseList'];
    // interestController.saveInterestedCourse(
    //     data.map((item) => Map<String, Object>.from(item)).toList());
    List<dynamic> data = response.data['myInterestCourseList'];
    interestController.saveInterestedCourse(data
        .map((item) => Map<String, Object>.from(item['coursePreviewResDto']))
        .toList());

    setState(() {
      courseList = interestController.interestedCourse;
    });
  }

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
                    Text(
                      '관심 등록한 코스 : ${courseList.length} 개',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Flexible(
                      child: MyInterestedCourse(),
                    )
                  ],
                ))));
  }
}

class MyInterestedCourse extends StatelessWidget {
  MyInterestedCourse({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(221, 244, 244, 244),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(8),
        itemCount: interestController.interestedCourse.length,

        // index 말고 코스id로??
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () async {
              print('관심 코스리스트 == ${interestController.interestedCourse}');
              int courseId = (interestController.interestedCourse[index]
                  ['courseId'] as int);

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
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 211, 211, 211),
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                        offset: Offset(3, 3)),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: SizedBox(
                          width: 300,
                          child: Row(children: [
                            ThumbnailImage(index: index),
                            SizedBox(width: 10),
                            Expanded(
                                child: MyInterestedCourseList(index: index)),
                          ]))),
                ],
              ),
            ),
          );
        },
      ),
    );
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ),
                  SizedBox(width: 10),
                  if (interestController.interestedCourse[index]["visited"] ==
                      true)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 107, 211, 66),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(Icons.check,
                                size: 14, color: Colors.white),
                          ),
                          Text("방문",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                          SizedBox(width: 7),
                        ],
                      ),
                    )
                ],
              ),
            ),
            if (interestController.interestedCourse[index]["interest"] == true)
              Icon(Icons.bookmark, size: 24),
            if (interestController.interestedCourse[index]["interest"] == false)
              Icon(Icons.bookmark_outline_rounded, size: 24),
          ],
        ),
        SizedBox(height: 2),
        Row(
          children: [
            Icon(Icons.map, size: 12, color: Colors.black54),
            SizedBox(width: 3),
            Text(
              "${interestController.interestedCourse[index]["sido"].toString()} ${interestController.interestedCourse[index]["gugun"].toString()}",
              style: TextStyle(fontSize: 12, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
            SizedBox(width: 8),
            Icon(Icons.people, size: 12, color: Colors.black54),
            SizedBox(width: 3),
            Text(
              "${interestController.interestedCourse[index]['people'].toString()}명",
              style: TextStyle(fontSize: 12, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
          ],
        ),
        SizedBox(height: 6),
        Text(
          "${interestController.interestedCourse[index]['content']}",
          style: TextStyle(fontSize: 14),
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
              style: TextStyle(fontSize: 12, color: Colors.black45),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
            SizedBox(width: 8),
            Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite, size: 14),
                    SizedBox(width: 3),
                    Text(interestController.interestedCourse[index]["likeCount"]
                        .toString()),
                  ],
                ),
                SizedBox(width: 8),
                Row(
                  children: [
                    Icon(Icons.comment, size: 14),
                    SizedBox(width: 3),
                    Text(interestController.interestedCourse[index]
                            ["commentCount"]
                        .toString()),
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
        imageUrl:
            interestController.interestedCourse[index]['image'].toString(),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        height: 80,
        width: 80,
        fit: BoxFit.cover,
      ),
      // child: Image(
      //   image: AssetImage(courseList[widget.index]['image']),
      //   // image: AssetImage('assets/img1.jpg'),
      //   height: 80,
      //   width: 80,
      //   fit: BoxFit.cover,
      // ),
    );
  }
}
