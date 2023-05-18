import 'package:coursemores/course_make/make2.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import '../controller/make_controller.dart';

class MakeStart extends StatefulWidget {
  const MakeStart({super.key});

  @override
  State<MakeStart> createState() => _MakeState();
}

class _MakeState extends State<MakeStart> {
  final courseController = Get.put(CourseController());
  final LocationController locationController = Get.put(LocationController());
  // final CourseController courseController = Get.find();

  List<String> items = ['A', 'B', 'C'];

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [Text('코스 작성하기', style: TextStyle(color: Colors.white))],
      ),
      headerWidget: headerWidget(context),
      headerExpandedHeight: 0.3,
      body: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                    child: Column(
                  children: [
                    Lottie.asset('assets/course_plan.json', fit: BoxFit.fitWidth, width: 300),
                    Text(
                      '코스를 작성해볼까요?',
                      style: TextStyle(fontSize: 20),
                    ),
                    Padding(
                      padding: EdgeInsets.all(40),
                      child: FilledButton(
                        child: Text('코스 작성하러 가기', style: TextStyle(fontSize: 16)),
                        onPressed: () {
                          // 컨트롤러 인스턴스 초기화
                          courseController.title.value = '';
                          courseController.content.value = '';
                          courseController.people.value = 0;
                          courseController.time.value = 0;
                          courseController.visited.value = false;
                          courseController.locationList.clear();
                          courseController.hashtagList.clear();
                          courseController.themeIdList.clear();
                          // courseController의 모든 값 출력
                          print(courseController.title.value);
                          print(courseController.content.value);
                          print(courseController.people.value);
                          print(courseController.time.value);
                          print(courseController.visited.value);
                          print(courseController.locationList);
                          print(courseController.hashtagList);
                          print(courseController.themeIdList);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CourseMake()),
                          );
                        },
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ],
      fullyStretchable: false,
      backgroundColor: Colors.white,
      appBarColor: Color.fromARGB(255, 80, 170, 208),
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
        Text("코스 작성하기", style: TextStyle(fontSize: 25, color: Colors.white)),
        SizedBox(height: 30),
        Text("나만의 코스를 작성하고", style: TextStyle(fontSize: 16, color: Colors.white)),
        SizedBox(height: 10),
        Text("다른 사람들과 공유할 수 있어요", style: TextStyle(fontSize: 16, color: Colors.white)),
      ],
    ),
  );
}
