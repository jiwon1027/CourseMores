import 'package:cached_network_image/cached_network_image.dart';
import 'package:coursemores/course_search/search.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timelines/timelines.dart';

class CourseIntroduction extends StatelessWidget {
  CourseIntroduction({super.key});

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      key: detailController.cardKey,
      fill: Fill.fillBack,
      flipOnTouch: false,
      alignment: Alignment.topRight,
      front: Container(
        alignment: Alignment.topRight,
        decoration: BoxDecoration(color: Color.fromARGB(255, 46, 85, 57), borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 30),
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: 600,
        child: ListView(
          children: [
            ChangeButton(icon: Icons.map, text: "지도로 보기"),
            SizedBox(height: 10),
            DetailTapCourseIntroductionTimeline()
          ],
        ),
      ),
      back: Container(
        alignment: Alignment.topRight,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 46, 85, 57),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 30),
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ChangeButton(icon: Icons.image_rounded, text: "코스로 보기"),
            SizedBox(height: 10),
            Expanded(child: LineMap()),
          ],
        ),
      ),
    );
  }
}

class ChangeButton extends StatelessWidget {
  ChangeButton({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        detailController.cardKey.currentState?.toggleCard();
      },
      icon: Icon(icon, color: Colors.white, size: 18),
      label: Text(text, style: TextStyle(color: Colors.white, fontSize: 14)),
      style: TextButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 115, 81, 255),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        elevation: 2,
        padding: EdgeInsets.fromLTRB(20, 3, 20, 3),
      ),
    );
  }
}

class LineMap extends StatelessWidget {
  LineMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GoogleMap(
          // 첫 번째 마커를 화면 중앙에 띄우기
          initialCameraPosition: CameraPosition(target: detailController.markerPositions[0], zoom: 15.0),
          markers: Set.from(detailController.markerPositions
              .toList()
              .map((position) => Marker(markerId: MarkerId(position.toString()), position: position))),
          polylines: {
            Polyline(
                polylineId: PolylineId('route'),
                points: detailController.markerPositions,
                color: Colors.blue,
                width: 5),
          },
        ));
  }
}

class DetailTapCourseIntroductionTimeline extends StatelessWidget {
  DetailTapCourseIntroductionTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
              connectorTheme: ConnectorThemeData(color: Color.fromARGB(69, 255, 255, 255), space: 30),
              indicatorTheme: IndicatorThemeData(color: Color.fromARGB(255, 141, 233, 127))),
          builder: TimelineTileBuilder.connectedFromStyle(
            contentsAlign: ContentsAlign.alternating,
            contentsBuilder: (context, index) => Padding(
              padding: EdgeInsets.all(15),
              child: Obx(() => Text("${detailController.nowCourseDetail[index]['title']}",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'KyoboHandwriting2020pdy'))),
            ),
            oppositeContentsBuilder: (context, index) => Card(
              elevation: 6,
              child: Container(
                padding: EdgeInsets.all(6.0),
                child: Column(
                  children: [
                    ThumbnailImage(index: index),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("${detailController.nowCourseDetail[index]['name']}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'KyoboHandwriting2020pdy')),
                    ),
                  ],
                ),
              ),
            ),
            connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
            indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
            itemCount: detailController.nowCourseDetail.length,
          ),
        ));
  }
}

class ThumbnailImage extends StatelessWidget {
  ThumbnailImage({super.key, required this.index});
  late final index;

  @override
  Widget build(BuildContext context) {
    try {
      late final image = detailController.nowCourseDetail[index]['roadViewImage'];
      return ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: CachedNetworkImage(
            imageUrl: image,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            height: 150,
            width: 130,
            fit: BoxFit.cover,
          ));
    } catch (e) {
      print(e);
      const image = 'assets/img1.jpg';
      return Image(image: AssetImage(image), height: 150, width: 130, fit: BoxFit.cover);
    }
  }
}
