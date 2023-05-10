import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'noti_list.dart' as noti;

class Notification extends StatefulWidget {
  const Notification({Key? key}) : super(key: key);

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  @override
  Widget build(BuildContext context) {
    // notiList.dart 안에 임시 정의해놓은 알림 리스트 가져오기
    var notiList = noti.notiList;

    // 알림 삭제하는 함수
    deleteOne(item) => setState(() {
          // notiList.removeAt(index);
          notiList.remove(item);
        });

    return Scaffold(
      appBar: AppBar(
        // 없어도 <- 모양의 뒤로가기가 기본으로 있으나 < 모양으로 바꾸려고 추가함
        leading: IconButton(
          icon: const Icon(
            Icons.navigate_before,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        // 알림 아이콘과 텍스트 같이 넣으려고 RichText 사용
        title: RichText(
            text: const TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                Icons.notifications,
                color: Colors.black,
              ),
            ),
            WidgetSpan(
              child: SizedBox(
                width: 5,
              ),
            ),
            TextSpan(
              text: '알림',
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
                Get.back();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              )),
        ],
      ),
      // 알림 리스트
      body: notiList.isEmpty
          ? displayNoNotificationScreen()
          : Container(
              color: Colors.grey[200],
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: notiList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: getNoti(notiList, notiList[index], deleteOne),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget getNoti(list, item, deleteOne) {
    // type에 따라 다른 문구와 아이콘으로 출력
    // 0 : 내 코스에 좋아요 눌렸을 때
    // 1 : 어떠한 코스에 적은 내 코멘트에 좋아요 눌렸을 때
    // 2 : 내 코스에 코멘트가 달렸을 때
    switch (item['type']) {
      case 0:
        return Row(
          children: [
            // 알림 유형별 아이콘
            const Padding(
              padding: EdgeInsets.only(left: 5, right: 10),
              child: Icon(Icons.route_outlined),
            ),
            // 알림 문구
            // Text가 길어지면 화면 밖을 빠져나가서 Expanded와 softwrap 사용
            Expanded(
              child: Text(
                "${item['nickname']}님이 ${item['course']} 코스에 좋아요를 눌렀습니다.",
                softWrap: true,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            // 삭제 아이콘
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                deleteOne(item);
              },
            )
          ],
        );
      case 1:
        return Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 5, right: 10),
              child: Icon(Icons.favorite),
            ),
            Expanded(
              child: Text(
                "${item['nickname']}님이 ${item['course']} 코스의 리뷰에 좋아요를 눌렀습니다.",
                softWrap: true,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                deleteOne(item);
              },
            )
          ],
        );
      case 2:
        return Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 5, right: 10),
              child: Icon(Icons.comment),
            ),
            Expanded(
              child: Text(
                "${item['nickname']}님이 ${item['course']} 코스에 코멘트를 남겼습니다.",
                softWrap: true,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                deleteOne(item);
              },
            )
          ],
        );
      default:
        return const Text("");
    }
  }

  displayNoNotificationScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("🔔", style: TextStyle(fontSize: 70)),
          SizedBox(height: 20),
          Text("지금은 알림이 없어요!"),
        ],
      ),
    );
  }
}
