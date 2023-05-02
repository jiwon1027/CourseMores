import 'package:flutter/material.dart';
// import 'search.dart' as search;
// import 'package:carousel_slider/carousel_slider.dart';
import 'carousel.dart' as carousel;
import 'course_list.dart' as course;

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
                  child: const Text('날씨..'),
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
          decoration: iconBoxDeco(),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune),
          ),
        ),
        Container(
          decoration: iconBoxDeco(),
          width: 300.0,
          child: searchButtonBar(),
        )
      ],
    ),
  );
}

class ButtonBar2 extends StatelessWidget {
  const ButtonBar2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const register.Register()),
              // );
            },
            child: Container(
              width: 80.0,
              height: 80.0,
              decoration: iconBoxDeco(),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[Icon(Icons.route), Text('코스 작성')],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const search.Search()),
              // );
            },
            child: Container(
              width: 80.0,
              height: 80.0,
              decoration: iconBoxDeco(),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(Icons.star_outline),
                    Text('관심 목록')
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const search.Search()),
              // );
            },
            child: Container(
              width: 80.0,
              height: 80.0,
              decoration: iconBoxDeco(),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const mypage.MyPage()));
                },
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.account_circle),
                      Text('마이페이지')
                    ],
                  ),
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
  return BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(10));
}

popularCourse() {
  return Container(
    decoration: iconBoxDeco(),
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
      decoration: iconBoxDeco(),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
          child: Column(
            children: [
              const Text(
                '이런 테마는 어때요? 😊',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
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
                              offset: const Offset(
                                  0, 2), // changes position of shadow
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
    decoration: iconBoxDeco(),
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
      // enabledBorder: UnderlineInputBorder(
      //   borderSide: BorderSide(color: Colors.grey),
      // ),
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
