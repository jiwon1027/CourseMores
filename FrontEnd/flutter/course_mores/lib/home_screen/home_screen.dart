import 'package:coursemores/auth/login_page.dart';
import 'package:flutter/material.dart';
import './carousel.dart' as carousel;
// import 'search.dart' as search;
// import 'package:carousel_slider/carousel_slider.dart';
// import 'carousel.dart';
import '../course_search/course_list.dart' as course;
// import '../mypage/mypage.dart' as mypage;
// import '../controller/getx_controller.dart';
import '../main.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../auth/auth_dio.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _currentPosition;
  // late Function changePageNum = widget.changePageNum;

  Future<void> _getCurrentLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // 권한이 거부됨
      return;
    }
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = position;
    });
  }

  @override
  void initState() {
    super.initState();
    getHotCourse(tokenController.accessToken);
  }

  Future<void> getHotCourse(aToken) async {
    final dio = await authDio();
    final response = await dio.get('course/hot',
        options: Options(
          headers: {'Authorization': 'Bearer $aToken'},
        ));
    print('4646464646');
    print(response);
  }

  // openweathermap의 api키
  final String apiKey = dotenv.get('OPENWEATHER_API_KEY');
  final String apiBaseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> getWeatherData(double lat, double lon) async {
    try {
      final dio = await authDio();
      final response = await dio.get(apiBaseUrl, queryParameters: {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'appid': apiKey,
        'units': 'metric',
        'lang': 'kr'
      });
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  Future<Map<String, dynamic>> _getWeather() async {
    if (_currentPosition == null) {
      await _getCurrentLocation();
    }
    final lat = _currentPosition?.latitude;
    final lon = _currentPosition?.longitude;
    if (lat != null && lon != null) {
      final weatherData = await getWeatherData(lat, lon);
      return weatherData;
    }
    throw Exception('Failed to get current location');
  }

  Future<String> _getAddress(double lat, double lon) async {
    final List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(lat, lon, localeIdentifier: 'ko');
    if (placemarks != null && placemarks.isNotEmpty) {
      final placemark = placemarks.first;
      final String address = '${placemark.subLocality} ${placemark.thoroughfare} ';
      return address;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: double.infinity,
                  height: 200.0,
                  color: Colors.amber,
                  child: Center(
                    child: Column(children: [
                      Text('날씨~~'),
                      SizedBox(
                        child: FutureBuilder<Map<String, dynamic>>(
                          future: _getWeather(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final weatherData = snapshot.data!;
                              final temp = weatherData['main']['temp'].toString();
                              final weather = weatherData['weather'][0]['description'].toString();
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '위치: ${_currentPosition?.latitude}, ${_currentPosition?.longitude}',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    '기온: $temp °C',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    '날씨: $weather',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  FutureBuilder<String>(
                                    future:
                                        _getAddress(_currentPosition?.latitude ?? 0, _currentPosition?.longitude ?? 0),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Text('검색중...');
                                      } else if (snapshot.hasData) {
                                        final address = snapshot.data!;
                                        return Text(
                                          '장소: $address',
                                          style: TextStyle(fontSize: 24),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        return Text('');
                                      }
                                    },
                                  ),
                                ],
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      )
                    ]),
                  ),
                ),
                buttonBar1(),
                ButtonBar2(),
                popularCourse(),
                themeList(),
                reviews(),
              ],
            ),
          ),
        ));
  }
}

buttonBar1() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 50.0,
          decoration: boxDeco(),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune),
          ),
        ),
        Container(
          decoration: boxDeco(),
          width: 300.0,
          child: searchButtonBar(),
        )
      ],
    ),
  );
}

class ButtonBar2 extends StatefulWidget {
  const ButtonBar2({super.key});

  // final changePageNum;

  @override
  State<ButtonBar2> createState() => _ButtonBar2State();
}

class _ButtonBar2State extends State<ButtonBar2> {
  var pageNum = pageController.pageNum.value;
  // late Function changePageNum = widget.changePageNum;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              pageController.changePageNum(1);
              print(pageController.pageNum.value);
            },
            child: Container(
              width: 110.0,
              height: 80.0,
              decoration: boxDeco(),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const <Widget>[
                    Icon(Icons.route),
                    Text(
                      '코스 작성',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              pageController.changePageNum(3);
              print(pageController.pageNum.value);
            },
            child: Container(
              width: 110.0,
              height: 80.0,
              decoration: boxDeco(),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const <Widget>[
                    Icon(Icons.star_outline),
                    Text('관심 목록', style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              pageController.changePageNum(4);
              print(pageController.pageNum.value);
            },
            child: Container(
              width: 110.0,
              height: 80.0,
              decoration: boxDeco(),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const <Widget>[
                    Icon(Icons.account_circle),
                    Text('마이페이지', style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

iconBoxDeco() {
  return BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10));
}

boxDeco() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 3,
        offset: const Offset(0, 2), // changes position of shadow
      ),
    ],
  );
}

popularCourse() {
  return Container(
    decoration: boxDeco(),
    child: const Padding(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
      child: SizedBox(
        height: 300.0,
        child: carousel.CoourseCarousel(),
      ),
    ),
  );
}

themeList() {
  var themes = [];
  for (var theme in course.themeList) {
    themes.add(theme["text"]);
  }

  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
    child: Container(
      decoration: boxDeco(),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
          child: Column(
            children: [
              const Text(
                '이런 테마는 어때요? 😊',
                style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 200.0,
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: themes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 30.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(child: Text('${themes[index]}')),
                      );
                    }),
              )
            ],
          )),
    ),
  );
}

reviews() {
  return Container(
    decoration: boxDeco(),
    child: const Padding(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
      child: SizedBox(
        height: 300.0,
        child: carousel.ReviewCarousel(),
      ),
    ),
  );
}

TextEditingController searchTextEditingController = TextEditingController();

emptyTheTextFormField() {
  searchTextEditingController.clear();
}

controlSearching(str) {}

searchButtonBar() {
  return TextFormField(
    controller: searchTextEditingController,
    decoration: InputDecoration(
      hintText: "원하는 코스를 검색해보세요",
      hintStyle: const TextStyle(color: Colors.grey),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      // focusedBorder: UnderlineInputBorder(
      //   borderSide: BorderSide(color: Colors.white),
      // ),
      filled: true,
      suffixIcon: IconButton(
        icon: const Icon(Icons.search),
        color: Colors.grey,
        iconSize: 30,
        onPressed: () {
          // print("${searchTextEditingController.text} 검색하기");
          pageController.changePageNum(2);
        },
      ),
    ),
    style: const TextStyle(
      fontSize: 18,
      color: Colors.black,
    ),
    onFieldSubmitted: controlSearching,
  );
}
