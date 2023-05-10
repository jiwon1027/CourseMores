import 'package:coursemores/course_make/make2.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import '../make_controller.dart';

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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Column(
          children: [
            Lottie.asset(
              'assets/course_plan.json',
              fit: BoxFit.fitWidth,
              width: 300,
            ),
            Text(
              '코스를 작성해볼까요?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                child: Text(
                  '코스 작성하러 가기',
                  style: TextStyle(fontSize: 18),
                ),
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
      ),
    );
  }
}
