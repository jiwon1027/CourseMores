import 'package:cached_network_image/cached_network_image.dart';
import 'package:coursemores/course_search/search.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:dio/dio.dart';

CarouselController _controller = CarouselController();

class CourseDetail extends StatelessWidget {
  CourseDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Column(
            children: [
              CarouselSliderText(),
              CarouselIndicator(),
              SizedBox(height: 10),
              if (detailController.nowCourseDetail[
                          detailController.placeIndex.value]['title'] !=
                      "" ||
                  detailController.nowCourseDetail[
                          detailController.placeIndex.value]['content'] !=
                      "" ||
                  detailController
                      .nowCourseDetail[detailController.placeIndex.value]
                          ['locationImageList']
                      .isNotEmpty)
                Card(
                  elevation: 6,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                          child: Column(
                            children: [
                              if (detailController
                                  .nowCourseDetail[detailController
                                      .placeIndex.value]['locationImageList']
                                  .isNotEmpty)
                                ImageGridView(),
                              if (detailController.nowCourseDetail[
                                              detailController.placeIndex.value]
                                          ['title'] !=
                                      "" ||
                                  detailController.nowCourseDetail[
                                              detailController.placeIndex.value]
                                          ['content'] !=
                                      "")
                                Column(
                                  children: [
                                    SizedBox(height: 15),
                                    Text(
                                      "${detailController.nowCourseDetail[detailController.placeIndex.value]['title'] ?? ' '}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "${detailController.nowCourseDetail[detailController.placeIndex.value]['content'] ?? ' '}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          height: 1.7),
                                    ),
                                    SizedBox(height: 10),
                                    PlaceMap(),
                                    // SizedBox(height: 10),
                                    // GetDistanceTime()
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}

// class GetDistanceTime extends StatefulWidget {
//   const GetDistanceTime({
//     super.key,
//   });

//   @override
//   State<GetDistanceTime> createState() => _GetDistanceTime();
// }

// class _GetDistanceTime extends State<GetDistanceTime> {
//   final String apiKey = dotenv.get('GOOGLE_MAP_API_KEY');
//   String _distance = '';
//   String _duration = '';

//   Future<void> getDistanceAndTime() async {
//     Dio dio = Dio();

//     String origin =
//         "${detailController.nowCourseDetail[detailController.placeIndex.value]['latitude']},"
//         "${detailController.nowCourseDetail[detailController.placeIndex.value]['longitude']}";
//     String destination =
//         "${detailController.nowCourseDetail[detailController.placeIndex.value + 1]['latitude']},"
//         "${detailController.nowCourseDetail[detailController.placeIndex.value + 1]['longitude']}";

//     final response = await dio.get(
//       'https://maps.googleapis.com/maps/api/directions/json',
//       queryParameters: {
//         'origin': origin,
//         'destination': destination,
//         'key': apiKey,
//       },
//     );

//     if (response.statusCode == 200) {
//       print(response.data);
//       setState(() {
//         _distance = response.data['routes'][0]['legs'][0]['distance']['text'];
//         _duration = response.data['routes'][0]['legs'][0]['duration']['text'];
//       });
//     } else {
//       print('Error: ${response.statusCode}');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (detailController.placeIndex.value <
//         detailController.nowCourseDetail.length - 1) {
//       getDistanceAndTime();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 100,
//       width: 100,
//       child: Column(children: [
//         Row(
//           children: [Icon(Icons.straighten), Text('Distance: $_distance')],
//         ),
//         Row(
//           children: [Icon(Icons.drive_eta), Text('Duration: $_duration')],
//         )
//       ]),
//     );
//   }
// }

class PlaceMap extends StatefulWidget {
  const PlaceMap({
    super.key,
  });

  @override
  State<PlaceMap> createState() => _PlaceMapState();
}

class _PlaceMapState extends State<PlaceMap> {
  late Future<BitmapDescriptor> customIcon;

  @override
  void initState() {
    super.initState();
    customIcon = BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(30, 40)), 'assets/flower_marker.png');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BitmapDescriptor>(
      future: customIcon,
      builder:
          (BuildContext context, AsyncSnapshot<BitmapDescriptor> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SizedBox(
            height: 300, // Adjust as needed
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  detailController
                          .nowCourseDetail[detailController.placeIndex.value]
                      ['latitude'],
                  detailController
                          .nowCourseDetail[detailController.placeIndex.value]
                      ['longitude'],
                ),
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('locationMarker'),
                  position: LatLng(
                    detailController
                            .nowCourseDetail[detailController.placeIndex.value]
                        ['latitude'],
                    detailController
                            .nowCourseDetail[detailController.placeIndex.value]
                        ['longitude'],
                  ),
                  icon: snapshot.data!,
                ),
              },
            ),
          );
        } else {
          // While waiting for the icon to load, display a loading spinner.
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class CarouselIndicator extends StatelessWidget {
  const CarouselIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            (detailController.nowCourseDetail.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 12.0,
              height: 10.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(
                          detailController.placeIndex.value == entry.key
                              ? 0.9
                              : 0.2)),
            ),
          );
        }).toList()));
  }
}

class CarouselSliderText extends StatelessWidget {
  const CarouselSliderText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      carouselController: _controller,
      options: CarouselOptions(
        height: 250,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          detailController.changePlaceIndex(index);
        },
        enableInfiniteScroll: false,
      ),
      itemCount: detailController.nowCourseDetail.length,
      itemBuilder: (context, index, realIndex) => Container(
        clipBehavior: Clip.antiAlias,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(10, 20, 10, 30),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
                detailController.nowCourseDetail[index]['roadViewImage']),
            fit: BoxFit.cover,
          ),
          color: Color.fromARGB(255, 241, 241, 241),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 157, 157, 157),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: const [Colors.black, Colors.transparent])),
                  child: Text(
                    "${index + 1}. ${detailController.nowCourseDetail[index]['name']}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ThumbnailImage extends StatelessWidget {
  ThumbnailImage({super.key, required this.index});
  late final index;

  @override
  Widget build(BuildContext context) {
    try {
      late final image =
          detailController.nowCourseDetail[index]['roadViewImage'];
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
      return Image(
          image: AssetImage(image), height: 150, width: 130, fit: BoxFit.cover);
    }
  }
}

class ImageGridView extends StatelessWidget {
  ImageGridView({Key? key}) : super(key: key);
  final List<dynamic> imageList = detailController
      .nowCourseDetail[detailController.placeIndex.value]['locationImageList'];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: imageList.length > 3 ? 3 : imageList.length,
      itemBuilder: (context, imageIndex) {
        if (imageIndex == 2 && imageList.length > 3) {
          return Stack(
            children: [
              ImageInkWell(imageIndex: imageIndex),
              Positioned(
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.all(2),
                    width: 94,
                    height: 94,
                    child: Center(
                        child: Text('+${imageList.length - 3}',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20))),
                  ),
                ),
              ),
            ],
          );
        } else {
          return ImageInkWell(imageIndex: imageIndex);
        }
      },
    );
  }
}

class ImageInkWell extends StatelessWidget {
  ImageInkWell({super.key, required this.imageIndex});

  final imageIndex;

  @override
  Widget build(BuildContext context) {
    late final image =
        detailController.nowCourseDetail[detailController.placeIndex.value]
            ['locationImageList'];
    return Obx(() => InkWell(
          onTap: () {
            Get.to(() => Gallery(initialIndex: imageIndex));
          },
          child: Padding(
            padding: EdgeInsets.all(2),
            child: Hero(
              tag:
                  'image${detailController.nowCourseDetail[detailController.placeIndex.value]['locationImageList']}_$imageIndex',
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: image[imageIndex],
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )),
            ),
          ),
        ));
  }
}

class Gallery extends StatefulWidget {
  Gallery({Key? key, this.initialIndex = 0}) : super(key: key);

  final int initialIndex;
  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 사진 상세보기 갤러리 뷰에서 사진 표시
          PhotoViewGallery.builder(
            scrollPhysics: BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(detailController
                        .nowCourseDetail[detailController.placeIndex.value]
                    ['locationImageList'][_currentIndex]),
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes: PhotoViewHeroAttributes(
                    tag: 'image${widget.initialIndex}_$index'),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.0,
              );
            },
            itemCount: detailController
                .nowCourseDetail[detailController.placeIndex.value]
                    ['locationImageList']
                .length,
            pageController: PageController(initialPage: widget.initialIndex),
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),

          // 사진 상세보기 갤러리 뷰에서 상단 좌측의 뒤로가기
          Positioned(
            top: 50,
            left: 30,
            child: GestureDetector(
                onTap: () => Get.back(),
                child: Icon(Icons.arrow_back_ios, color: Colors.white)),
          ),
          // 사진 상세보기 갤러리 뷰에서 밑의 인디케이터
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                detailController
                    .nowCourseDetail[detailController.placeIndex.value]
                        ['locationImageList']
                    .length,
                (index) {
                  return Container(
                    width: 10.0,
                    height: 10.0,
                    margin: EdgeInsets.symmetric(horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Colors.grey.shade800
                          : Colors.grey.shade600,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
