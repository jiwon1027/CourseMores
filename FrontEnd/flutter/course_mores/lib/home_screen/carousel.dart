import 'package:carousel_slider/carousel_slider.dart';
import '../controller/getx_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../course_search/course_detail.dart' as detail;
import '../course_search/search.dart';

final myPageController = Get.put(MyPageInfo());
final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

// final hotCourse = homeController.hotCourse;

// final List<Widget> imageSliders = hotCourse
//     .map((item) => Container(
//           margin: const EdgeInsets.all(5.0),
//           child: ClipRRect(
//               borderRadius: const BorderRadius.all(Radius.circular(5.0)),
//               child: Stack(
//                 children: <Widget>[
//                   Image.network(item['image'].toString(),
//                       // Image.network(
//                       //     'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
//                       fit: BoxFit.cover,
//                       width: 1000.0),
//                   Positioned(
//                     bottom: 0.0,
//                     left: 0.0,
//                     right: 0.0,
//                     height: null,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.black,
//                         gradient: LinearGradient(
//                           colors: const [
//                             Color.fromARGB(200, 0, 0, 0),
//                             Color.fromARGB(0, 0, 0, 0)
//                           ],
//                           begin: Alignment.bottomCenter,
//                           end: Alignment.topCenter,
//                         ),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 10.0, horizontal: 10.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '${item['title']}',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 20.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text('${item['sido']} ${item['gugun']}',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 10.0,
//                               )),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Text('content',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 14.0,
//                                   ))
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               )),
//         ))
//     .toList();

// class CoourseCarousel extends StatelessWidget {
//   // const CoourseCarousel({super.key});
//   const CoourseCarousel({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
//         child: Column(
//           children: [
//             const Padding(
//               padding: EdgeInsets.fromLTRB(0, 0, 0, 15.0),
//               child: Text(
//                 '최근 인기 코스 🔥',
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//             // Text('${homeController.hotCourse[0]['title']}'),
//             CarouselSlider(
//               options: CarouselOptions(
//                 autoPlay: true,
//                 // aspectRatio: 2.0,
//                 enlargeCenterPage: false,
//               ),
//               items: imageSliders,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ReviewCarousel extends StatelessWidget {
//   const ReviewCarousel({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
//         child: Column(
//           children: [
//             const Padding(
//               padding: EdgeInsets.fromLTRB(0, 0, 0, 15.0),
//               child: Text(
//                 '지금 내 근처의 코스 👀',
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//             CarouselSlider(
//               options: CarouselOptions(
//                 autoPlay: true,
//                 // aspectRatio: 2.0,
//                 enlargeCenterPage: false,
//               ),
//               items: imageSliders,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CoourseCarousel extends StatefulWidget {
  const CoourseCarousel({Key? key}) : super(key: key);

  @override
  State<CoourseCarousel> createState() => _CoourseCarouselState();
}

class _CoourseCarouselState extends State<CoourseCarousel> {
  List<Map<String, Object>> hotCourse = [];
  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeScreenInfo>();
    final hotCourses = homeController.hotCourse
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    final futureHotCourses = Future.value(hotCourses);
    setState(() {
      hotCourse = homeController.hotCourse;
    });
// final homeController = Get.put(HomeScreenInfo());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 15.0),
              child: Text(
                '최근 인기 코스 🔥',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: futureHotCourses,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Widget> imageSliders = snapshot.data!
                      .map((item) => InkWell(
                            onTap: () async {
                              int courseId = (item['courseId'] as int);

                              await searchController.changeNowCourseId(
                                  courseId: courseId);

                              await detailController.getCourseInfo('코스 소개');
                              await detailController.getIsLikeCourse();
                              await detailController.getIsInterestCourse();
                              await detailController.getCourseDetailList();

                              Get.to(() => detail.Detail());
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5.0),
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                  child: Stack(
                                    children: <Widget>[
                                      Image.network(item['image'].toString(),
                                          fit: BoxFit.cover, width: 1000.0),
                                      Positioned(
                                        bottom: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        height: null,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            gradient: LinearGradient(
                                              colors: const [
                                                Color.fromARGB(200, 0, 0, 0),
                                                Color.fromARGB(0, 0, 0, 0)
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${item['title'].length > 20 ? item['title'].substring(0, 20) + '...' : item['title']}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                  '${item['sido']} ${item['gugun']}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10.0,
                                                  )),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      '${item['content'].length > 20 ? item['content'].substring(0, 20) + '...' : item['content']}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.0,
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ))
                      .toList();

                  return CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: false,
                    ),
                    items: imageSliders,
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NearCarousel extends StatefulWidget {
  const NearCarousel({Key? key}) : super(key: key);

  @override
  State<NearCarousel> createState() => _NearCarouselState();
}

class _NearCarouselState extends State<NearCarousel> {
  List<Map<String, Object>> nearCourse = [];
  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeScreenInfo>();
    final nearCourses = homeController.nearCourse
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    final futureNearCourses = Future.value(nearCourses);
    setState(() {
      nearCourse = homeController.nearCourse;
    });
// final homeController = Get.put(HomeScreenInfo());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 15.0),
              child: Text(
                '지금 내 근처의 코스 👀',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: futureNearCourses,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Widget> imageSliders = snapshot.data!
                      .map((item) => InkWell(
                            onTap: () async {
                              int courseId = (item['courseId'] as int);

                              await searchController.changeNowCourseId(
                                  courseId: courseId);

                              await detailController.getCourseInfo('코스 소개');
                              await detailController.getIsLikeCourse();
                              await detailController.getIsInterestCourse();
                              await detailController.getCourseDetailList();

                              Get.to(() => detail.Detail());
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5.0),
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                  child: Stack(
                                    children: <Widget>[
                                      Image.network(item['image'].toString(),
                                          fit: BoxFit.cover, width: 1000.0),
                                      Positioned(
                                        bottom: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        height: null,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            gradient: LinearGradient(
                                              colors: const [
                                                Color.fromARGB(200, 0, 0, 0),
                                                Color.fromARGB(0, 0, 0, 0)
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${item['title'].length > 20 ? item['title'].substring(0, 20) + '...' : item['title']}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                  '${item['sido']} ${item['gugun']}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10.0,
                                                  )),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${item['content'].length > 20 ? item['content'].substring(0, 20) + '...' : item['content']}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                  '내 위치로부터 ${item['distance'].round()}km',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10.0,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ))
                      .toList();

                  return CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: false,
                    ),
                    items: imageSliders,
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
