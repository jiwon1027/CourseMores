import 'package:coursemores/course_make/make3.dart';
import 'package:coursemores/course_make/make_map.dart';
import 'package:coursemores/course_make/make_search.dart';
import 'package:flutter/material.dart';

class CourseMake extends StatefulWidget {
  const CourseMake({super.key});

  @override
  State<CourseMake> createState() => _CourseMakeState();
}

class _CourseMakeState extends State<CourseMake> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 없어도 <- 모양의 뒤로가기가 기본으로 있으나 < 모양으로 바꾸려고 추가함
        leading: IconButton(
          icon: const Icon(
            Icons.navigate_before,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // 알림 아이콘과 텍스트 같이 넣으려고 RichText 사용
        title: RichText(
            text: const TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                Icons.edit_note,
                color: Colors.black,
              ),
            ),
            WidgetSpan(
              child: SizedBox(
                width: 5,
              ),
            ),
            TextSpan(
              text: '코스 작성하기',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ],
        )),
        // 피그마와 모양 맞추려고 close 아이콘 하나 넣어둠
        // <와 X 중 하나만 있어도 될 것 같아서 상의 후 삭제 필요
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              )),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '장소 추가하기 🏙',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
            const Text(
              '장소는 최대 ~~개까지 추가할 수 있어요',
              style: TextStyle(color: Colors.grey),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CMSearch()),
                      );
                    },
                    icon: const Icon(Icons.search),
                    label: const Text(
                      '검색 추가',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CMMap()),
                      );
                    },
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    label: const Text(
                      '마커 추가',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )),
              ],
            ),
            ElevatedButton.icon(
                icon: const Icon(Icons.verified),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MakeStepper()),
                  );
                },
                label: const Text('코스 지정 완료')),
          ],
        ),
      ),
    );
  }
}
