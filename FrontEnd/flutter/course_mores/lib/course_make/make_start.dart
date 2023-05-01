import 'package:coursemores/course_make/make2.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MakeStart extends StatefulWidget {
  const MakeStart({super.key});

  @override
  State<MakeStart> createState() => _MakeState();
}

class _MakeState extends State<MakeStart> {
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
