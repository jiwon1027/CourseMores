import 'package:flutter/material.dart';
import 'course_list.dart' as course;
import 'notification.dart' as noti;

class CourseDetail extends StatefulWidget {
  const CourseDetail({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  // ignore: library_private_types_in_public_api
  _CourseDetailState createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  // ignore: non_constant_identifier_names
  late var course_info = course.courseList[widget.index];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar(),
      // body: Text("${course_info['course']}"),
      body: Container(
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
                        Row(
                          // 작성자 정보, 방문여부 라인
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              // 작성자 프로필 이미지, 작성자명
                              children: [
                                // 작성자 프로필 이미지 연결
                                ThumbnailImage(),
                                SizedBox(
                                  width: 5,
                                ),
                                // 작성자명
                                Text("${course_info['author']}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                            // 방문여부
                            Row(
                              children: [
                                // 방문한 곳이면 방문 체크 표시
                                if (course_info["visited"] == true)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 111, 209, 72),
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
                                                TextStyle(color: Colors.white)),
                                        SizedBox(
                                          width: 7,
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // 제목 라인
                        Text(
                          "${course_info['course']}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // 지역, 인원 수, 소요시간 라인
                        Row(
                          children: [
                            // 지역 아이콘 & 텍스트
                            Icon(
                              Icons.location_pin,
                              size: 16,
                              color: Colors.black38,
                            ),
                            SizedBox(width: 3),
                            Text(
                              "${course_info['address']}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black38,
                              ),
                            ),
                            // 추천인원 수가 0이 아니면 보여짐
                            if (course_info['people'] != 0)
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.people,
                                    size: 16,
                                    color: Colors.black38,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    "${course_info['people'].toString()}명",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
                            // 소요시간이 0이 아니면 보여짐
                            if (course_info['time'] != 0)
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.timer,
                                    size: 16,
                                    color: Colors.black38,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    "${course_info['time'].toString()}시간",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // 작성일자, 조회수 라인
                        Row(
                          children: [
                            // 작성일자
                            Text(
                              "${course_info['date']}",
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            // 조회수
                            Row(
                              children: [
                                Icon(Icons.remove_red_eye, size: 18),
                                SizedBox(width: 3),
                                Text(
                                  course_info['views'].toString(),
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ))),
          ],
        ),
      ),
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
      iconTheme: IconThemeData(
        color: Colors.black54, // 아이콘 색깔
      ),
      title: const Text('CourseMores', style: TextStyle(color: Colors.black)),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.navigate_before),
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
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class ThumbnailImage extends StatelessWidget {
  const ThumbnailImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Image(
        image: AssetImage('assets/img1.jpg'),
        height: 35,
        width: 35,
        fit: BoxFit.cover,
      ),
    );
  }
}
