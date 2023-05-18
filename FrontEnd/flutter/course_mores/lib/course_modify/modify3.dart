import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
// import 'make2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../controller/make_controller.dart';
import '../course_search/search.dart';
// import 'package:dio/dio.dart';

CourseController courseController = Get.find<CourseController>();

class ModifyStepper extends StatefulWidget {
  // const ModifyStepper({super.key});
  final String? courseId;
  ModifyStepper({Key? key, this.courseId}) : super(key: key);

  @override
  State<ModifyStepper> createState() => _ModifyStepperState();
}

class _ModifyStepperState extends State<ModifyStepper> {
  late final TextfieldTagsController hashtagcontroller;

  _ModifyStepperState() {
    hashtagcontroller = TextfieldTagsController();
  }

  int _currentStep = 0;

  List<Step> get _mySteps => [
        Step(
          isActive: _currentStep >= 0,
          title: Text('필수 입력'),
          content: Center(
              child: Column(
            children: [
              Text(
                '코스 상세 필수 내용',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '코스 이름과 방문 여부를 입력해주세요.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(height: 20),
              FractionallySizedBox(widthFactor: 0.95, child: PlaceListBox()),
              SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.95,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Container(
                    padding: EdgeInsets.all(16), // 박스 내부 패딩
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯을 왼쪽 정렬
                      children: [
                        Row(
                          children: const [
                            Text(
                              '코스 이름',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(' *', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                            SizedBox(width: 10),
                          ],
                        ),
                        SizedBox(height: 8), // 간격 추가
                        SingleChildScrollView(
                          child: Container(
                            constraints: BoxConstraints(maxHeight: 100),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
                            ),
                            padding: EdgeInsets.all(10),
                            child: TextField(
                              controller: TextEditingController(text: courseController.title.value),
                              onChanged: (text) {
                                // 사용자의 입력이 변화할 때마다 실행되는 콜백 함수
                                print('User typed: $text');
                                // CourseController의 title 변수 업데이트
                                Get.find<CourseController>().title.value = text;
                              },
                              maxLength: 50,
                              maxLines: null,
                              expands: true, // TextField의 높이를 가능한 한 최대로 확장
                              minLines: null, // 최소 줄 수를 지정하지 않음
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '최대 50자까지 작성할 수 있어요',
                                prefixText: ' ',
                                prefixStyle: TextStyle(color: Colors.transparent),
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FractionallySizedBox(
                widthFactor: 0.95,
                child: Card(
                  elevation: 4, // 그림자 높이
                  shape: RoundedRectangleBorder(
                    // 모서리 둥글기 설정
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16), // 박스 내부 패딩
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯을 왼쪽 정렬
                      children: [
                        Row(
                          children: const [
                            Text('방문 여부', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(' *', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                          ],
                        ),
                        SizedBox(height: 15),
                        CheckVisited()
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          )),
        ),
        Step(
            isActive: _currentStep >= 1,
            title: Text('선택 입력'),
            content: Center(
              child: Column(
                children: [
                  Text(
                    '코스 상세 선택 내용',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '코스 상세 내용을 선택적으로 입력해주세요.',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  SizedBox(height: 20),
                  FractionallySizedBox(
                    widthFactor: 0.95,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('인원수', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 8), // 간격 추가
                            Slider1(),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FractionallySizedBox(
                    widthFactor: 0.95,
                    child: Card(
                      elevation: 4, // 그림자 높이
                      shape: RoundedRectangleBorder(
                        // 모서리 둥글기 설정
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16), // 박스 내부 패딩
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯을 왼쪽 정렬
                          children: const [
                            Text('소요 시간', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 8), // 간격 추가
                            Slider2(),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FractionallySizedBox(
                    widthFactor: 0.95,
                    child: Card(
                      elevation: 4, // 그림자 높이
                      shape: RoundedRectangleBorder(
                        // 모서리 둥글기 설정
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16), // 박스 내부 패딩
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯을 왼쪽 정렬
                          children: [
                            Text('코스 내용', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 15),
                            SingleChildScrollView(
                              child: Container(
                                constraints: BoxConstraints(maxHeight: 200),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
                                ),
                                padding: EdgeInsets.all(10),
                                child: TextField(
                                  controller: TextEditingController(text: courseController.content.value),
                                  onChanged: (value) {
                                    // print(value);
                                    Get.find<CourseController>().content.value = value;
                                  },
                                  maxLength: 5000,
                                  maxLines: null,
                                  expands: true, // TextField의 높이를 가능한 한 최대로 확장
                                  minLines: null, // 최소 줄 수를 지정하지 않음
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '내용은 5000자까지 입력 가능합니다',
                                    prefixText: ' ',
                                    prefixStyle: TextStyle(color: Colors.transparent),
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FractionallySizedBox(
                    widthFactor: 0.95,
                    child: Card(
                      elevation: 4, // 그림자 높이
                      shape: RoundedRectangleBorder(
                        // 모서리 둥글기 설정
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16), // 박스 내부 패딩
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯을 왼쪽 정렬
                          children: const [
                            Text('해시태그', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 4), // 간격 추가
                            Text('원하는 해시태그를 작성하고 띄어쓰기를 누르세요', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            SizedBox(height: 8), // 간격 추가
                            // MakeHashtag(whatcontroller: hashtagcontroller),
                            MakeHashtag(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            )),
        Step(
            isActive: _currentStep >= 2,
            title: Text('테마 선택'),
            content: Center(
              child: Column(
                children: const [
                  Text(
                    '코스 상세 선택 내용',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '코스 상세 내용을 선택적으로 입력해주세요.',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '이 코스에 어울리는 테마는 무엇인가요?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  ThemeSelect()
                ],
              ),
            )),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 80, 170, 208),
        leading: IconButton(
          icon: Icon(Icons.navigate_before, color: Colors.white),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("경고"),
                  content: Text("작성하시던 내용이 사라집니다."),
                  actions: <Widget>[
                    TextButton(
                      child: Text("취소"),
                      onPressed: () {
                        Navigator.of(context).pop(); // Alert Dialog를 닫습니다.
                      },
                    ),
                    TextButton(
                      child: Text("확인"),
                      onPressed: () {
                        Navigator.of(context).pop(); // Alert Dialog를 닫습니다.
                        Navigator.pop(context); // 이전 페이지로 돌아갑니다.
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        title: Center(
          child: RichText(
              text: const TextSpan(
            children: [
              TextSpan(text: '코스 수정하기', style: TextStyle(fontSize: 22, color: Colors.white)),
            ],
          )),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close, color: Colors.white)),
        ],
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepTapped: (int index) {
          setState(() {
            _currentStep = index;
          });
        },
        onStepContinue: () {
          setState(() {
            if (_currentStep < _mySteps.length - 1) {
              _currentStep++;
            } else {
              // do something when the last step is reached
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Column(
                      children: [
                        Lottie.asset('assets/success.json', fit: BoxFit.fitWidth, width: 300),
                        Text("코스 작성을 완료했어요!"),
                      ],
                    ),
                    actions: <Widget>[
                      Center(
                        child: ElevatedButton(
                          child: Text("확인"),
                          onPressed: () {
                            // courseController의 모든 값 출력
                            print(courseController.title.value);
                            print(courseController.content.value);
                            print(courseController.people.value);
                            print(courseController.time.value);
                            print(courseController.visited.value);
                            print(courseController.locationList);
                            print(courseController.hashtagList);
                            print(courseController.themeIdList);
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
                            // Navigator를 이용해 적절한 이동 수행

                            detailController.getCourseInfo('코스 소개');

                            Navigator.of(context).pop();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          });
        },
        onStepCancel: () {
          setState(() {
            if (_currentStep > 0) {
              _currentStep--;
            } else {
              _currentStep = 0;

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("경고"),
                    content: Text("작성하시던 내용이 사라집니다."),
                    actions: <Widget>[
                      TextButton(
                        child: Text("취소"),
                        onPressed: () {
                          Navigator.of(context).pop(); // Alert Dialog를 닫습니다.
                        },
                      ),
                      TextButton(
                        child: Text("확인"),
                        onPressed: () {
                          Navigator.of(context).pop(); // Alert Dialog를 닫습니다.
                          Navigator.pop(context); // 이전 페이지로 돌아갑니다.
                        },
                      ),
                    ],
                  );
                },
              );
              // Navigator.pop(context);
            }
          });
        },
        steps: _mySteps,
        type: StepperType.horizontal,
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          if (_currentStep == _mySteps.length - 1) {
            return Row(
              children: <Widget>[
                Expanded(
                  child: FilledButton(
                    onPressed: details.onStepCancel,
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[400])),
                    child: Text('이전으로'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Column(
                              children: [
                                Lottie.asset(
                                  'assets/success.json',
                                  fit: BoxFit.fitWidth,
                                  width: 300,
                                ),
                                Text("코스 수정을 완료했어요!"),
                              ],
                            ),
                            actions: <Widget>[
                              Center(
                                child: FilledButton(
                                  child: Text("확인"),
                                  onPressed: () {
                                    // courseController의 모든 값 출력
                                    courseController.modifyCourse(widget.courseId);
                                    print(courseController.title.value);
                                    print(courseController.content.value);
                                    print(courseController.people.value);
                                    print(courseController.time.value);
                                    print(courseController.visited.value);
                                    print(courseController.locationList);
                                    print(courseController.hashtagList);
                                    print(courseController.themeIdList);
                                    // // 컨트롤러 인스턴스 초기화
                                    // courseController.title.value = '';
                                    // courseController.content.value = '';
                                    // courseController.people.value = 0;
                                    // courseController.time.value = 0;
                                    // courseController.visited.value = false;
                                    // courseController.locationList.clear();
                                    // courseController.hashtagList.clear();
                                    // courseController.themeIdList.clear();
                                    // // courseController의 모든 값 출력
                                    // print(courseController.title.value);
                                    // print(courseController.content.value);
                                    // print(courseController.people.value);
                                    // print(courseController.time.value);
                                    // print(courseController.visited.value);
                                    // print(courseController.locationList);
                                    // print(courseController.hashtagList);
                                    // print(courseController.themeIdList);
                                    // Navigator를 이용해 적절한 이동 수행
                                    Navigator.of(context).pop();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('작성 완료'),
                  ),
                ),
              ],
            );
          } else {
            return Row(
              children: <Widget>[
                Expanded(
                  child: FilledButton(
                    onPressed: details.onStepCancel,
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[400])),
                    child: Text('이전으로'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: details.onStepContinue,
                    // onPressed: () {
                    //   details.onStepContinue;
                    //   // 코스 저장여부 확인 코드 시작 check //
                    //   // GetX에서 CourseController 가져오기
                    //   CourseController courseController =
                    //       Get.find<CourseController>();

                    //   // courseController 내부의 값들 출력하기
                    //   print(courseController.title);
                    //   print(courseController.locationList);
                    //   print(courseController.locationList[0].name);
                    //   print(courseController.locationList[0].title);
                    //   print(courseController.locationList[0].sido);
                    //   print(courseController.locationList[0].gugun);
                    //   print(courseController.locationList[1].content);
                    //   // 코스 저장여부 확인 코드 끝 check //
                    // },
                    child: const Text('다음으로'),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}

class PlaceListBox extends StatefulWidget {
  const PlaceListBox({Key? key}) : super(key: key);

  @override
  State<PlaceListBox> createState() => _PlaceListBoxState();
}

class _PlaceListBoxState extends State<PlaceListBox> {
  List<LocationData> locations = Get.find<CourseController>().locationList;

  String _getLocationsString() {
    // List<LocationData> locations = Get.find<CourseController>().locationList;
    if (locations.isEmpty) {
      return '장소 없음';
    }
    String firstLocation = locations[0].name;
    int numOfLocations = locations.length;
    if (numOfLocations == 1) {
      return firstLocation;
    }
    return firstLocation;
  }

  @override
  Widget build(BuildContext context) {
    final String locationsString = _getLocationsString();

    final String apiKey = dotenv.get('GOOGLE_MAP_API_KEY');

    final String imgUrl =
        "https://maps.googleapis.com/maps/api/streetview?size=400x400&location=${locations[0].latitude},${locations[0].longitude}&fov=90&heading=235&pitch=10&key=$apiKey";

    int numOfLocations = locations.length;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                image: DecorationImage(
                  // image: AssetImage('assets/img1.jpg'),
                  image: NetworkImage(imgUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(
                  locationsString,
                  maxLines: 2,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 8),
                // Text(_address),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '외 ${numOfLocations - 1}곳',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Slider1 extends StatefulWidget {
  const Slider1({super.key});

  @override
  State<Slider1> createState() => _Slider1State();
}

class _Slider1State extends State<Slider1> {
  final CourseController courseController = Get.find<CourseController>();

  late double _sliderValue = courseController.people.value.toDouble();

  Map<int, String> peopleMapping = {
    0: '상관없음',
    1: '1인',
    2: '2인',
    3: '3인',
    4: '4인',
    5: '5인 이상',
  };

  @override
  Widget build(BuildContext context) {
    return SfSlider(
      value: _sliderValue,
      min: 0,
      max: 5,
      stepSize: 1,
      tooltipTextFormatterCallback: (value, formattedText) {
        return peopleMapping[value.toInt()]?.toString() ?? '';
      },
      labelFormatterCallback: (actualValue, formattedText) {
        return peopleMapping[actualValue.toInt()]?.toString() ?? '';
      },
      showDividers: true,
      interval: 1,
      showLabels: true,
      onChanged: (newValue) {
        setState(() {
          _sliderValue = newValue;
          courseController.people.value = newValue.toInt();
        });
      },
    );
  }
}

class Slider2 extends StatefulWidget {
  const Slider2({super.key});

  @override
  State<Slider2> createState() => _Slider2State();
}

class _Slider2State extends State<Slider2> {
  final CourseController courseController = Get.find<CourseController>();

  late double _sliderValue2 = courseController.time.value.toDouble();

  Map<int, String> timeMapping = {
    1: '1시간 이하',
    2: '1시간',
    3: '2시간',
    4: '3시간',
    5: '4시간 이상',
  };

  @override
  Widget build(BuildContext context) {
    // print(courseController.time.value.toDouble());
    return SfSlider(
      value: _sliderValue2,
      min: 1,
      max: 5,
      interval: 1,
      stepSize: 1,
      tooltipTextFormatterCallback: (value, formattedText) {
        return timeMapping[value.toInt()]?.toString() ?? '';
      },
      labelFormatterCallback: (actualValue, formattedText) {
        return timeMapping[actualValue.toInt()]?.toString() ?? '';
      },
      showDividers: true,
      showLabels: true,
      onChanged: (newValue) {
        setState(() {
          _sliderValue2 = newValue;
          courseController.time.value = newValue.toInt();
        });
      },
    );
  }
}

class MakeHashtag extends StatefulWidget {
  const MakeHashtag({Key? key}) : super(key: key);

  @override
  State<MakeHashtag> createState() => _MakeHashtagState();
}

class _MakeHashtagState extends State<MakeHashtag> {
  // 해시태그 관련 변수 //
  // late double _distanceToField;
  late TextfieldTagsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextfieldTagsController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  // 해시태그 관련 변수 끝 //

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFieldTags(
          textfieldTagsController: _controller,
          initialTags: courseController.hashtagList,
          textSeparators: const [' ', ','],
          letterCase: LetterCase.normal,
          validator: (String tag) {
            if (_controller.getTags?.contains(tag) == true) {
              return '이미 입력한 해시태그예요.';
            }
            return null;
          },
          inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
            return ((context, sc, tags, onTagDelete) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    TextField(
                      controller: tec,
                      focusNode: fn,
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 74, 137, 92), width: 3.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 74, 137, 92), width: 3.0),
                        ),
                        hintText: _controller.hasTags ? '' : "태그를 입력하세요",
                        errorText: error,
                        // prefixIcon: tags.isNotEmpty
                        //     ? SingleChildScrollView(
                        //         controller: sc,
                        //         scrollDirection: Axis.horizontal,
                        //         child: Row(
                        //             children: tags.map((String tag) {
                        //           return Container(
                        //             decoration: const BoxDecoration(
                        //               borderRadius: BorderRadius.all(
                        //                 Radius.circular(20.0),
                        //               ),
                        //               color: Color(0xFFEEEEEE),
                        //             ),
                        //             margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        //             padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        //             child: Row(
                        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 InkWell(
                        //                   child: Text(
                        //                     '#$tag',
                        //                     style: const TextStyle(color: Color(0xFF6D6AFF)),
                        //                   ),
                        //                   onTap: () {
                        //                     print("$tag selected");
                        //                   },
                        //                 ),
                        //                 const SizedBox(width: 4.0),
                        //                 InkWell(
                        //                   child: const Icon(
                        //                     Icons.cancel,
                        //                     size: 14.0,
                        //                     color: Color(0xFFAEAEAE),
                        //                   ),
                        //                   onTap: () {
                        //                     onTagDelete(tag);
                        //                   },
                        //                 )
                        //               ],
                        //             ),
                        //           );
                        //         }).toList()),
                        //       )
                        //     : null,
                      ),
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      controller: sc,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: tags.map((String tag) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)), color: Color(0xFFEEEEEE)),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: Text('#$tag', style: TextStyle(color: Color(0xFF6D6AFF))),
                                onTap: () {
                                  print("$tag selected");
                                },
                              ),
                              SizedBox(width: 4.0),
                              InkWell(
                                child: Icon(Icons.cancel, size: 14.0, color: Color(0xFFAEAEAE)),
                                onTap: () {
                                  onTagDelete(tag);
                                },
                              )
                            ],
                          ),
                        );
                      }).toList()),
                    )
                  ],
                ),
              );
            });
          },
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 240, 115, 115),
                ),
              ),
              onPressed: () {
                _controller.clearTags();
              },
              child: Text('태그 초기화', style: TextStyle(fontSize: 12)),
            ),
            SizedBox(width: 15),
            FilledButton(
              onPressed: () {
                final List<String>? tags = _controller.getTags;
                if (tags != null) {
                  Get.find<CourseController>().hashtagList.value = tags;
                }
              },
              child: Text('태그 저장', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ],
    );
  }
}

class ThemeSelect extends StatefulWidget {
  const ThemeSelect({Key? key}) : super(key: key);

  @override
  State<ThemeSelect> createState() => _ThemeSelectState();
}

class _ThemeSelectState extends State<ThemeSelect> {
  final Map<int, String> themeMapping = {
    1: '👨🏻‍🤝‍👨🏻 친구랑',
    2: '✨ 빛나는 솔로',
    3: '💑 데이트',
    4: '👪 가족과 함께',
    5: '💸 가성비',
    6: '🎮 오락',
    7: '🎠 기념일',
    8: '🍖 맛집',
    9: '🏠 실내',
    10: '🌅 힐링',
    11: '🔥 핫플',
    12: '🏃 활동적인',
    13: '🍂 계절맞춤',
    14: '🎪 공연/전시',
    15: '👘 전통/레트로',
    16: '🌳 자연',
    17: '📷 포토존',
    18: '🏛 관광지',
    19: '🕶 이색적인',
    20: '🌆 분위기 있는',
    21: '🛍 쇼핑',
    22: '👏🏻 단체',
  };

  @override
  Widget build(BuildContext context) {
    final List<MultiSelectCard> cards = themeMapping.entries.map((entry) {
      final int id = entry.key;
      final String text = entry.value;
      final bool isSelected = courseController.themeIdList.contains(id);
      return MultiSelectCard(
        margin: EdgeInsets.all(2.0),
        value: id,
        label: text,
        selected: isSelected,
        decorations: MultiSelectItemDecorations(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 3, offset: Offset(0, 2)),
            ],
          ),
          selectedDecoration: BoxDecoration(
            color: Color.fromARGB(255, 115, 81, 255),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      );
    }).toList();

    return Padding(
      padding: EdgeInsets.all(20),
      child: MultiSelectContainer(
        wrapSettings: WrapSettings(alignment: WrapAlignment.center, runSpacing: 12, spacing: 12),
        items: cards,
        onChange: (List<dynamic> allSelectedItems, dynamic selectedItem) {
          final List<int> selectedIds = allSelectedItems.whereType<int>().where(themeMapping.containsKey).toList();
          selectedIds.sort();
          courseController.themeIdList.value = selectedIds;
          print('선택된 아이템의 id 리스트: $selectedIds');
        },
      ),
    );
  }
}

class CheckVisited extends StatefulWidget {
  const CheckVisited({super.key});

  @override
  State<CheckVisited> createState() => _CheckVisitedState();
}

class _CheckVisitedState extends State<CheckVisited> {
  final CourseController courseController = Get.find<CourseController>();

  bool get _isVisited => courseController.visited.value;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: _isVisited
                ? null
                : () {
                    setState(() {
                      courseController.visited.value = true;
                    });
                  },
            label: Text('다녀왔어요!'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(_isVisited ? Colors.green[400] : Colors.grey[300]),
              foregroundColor: MaterialStateProperty.all(_isVisited ? Colors.white : Colors.grey[700]),
            ),
            icon: Icon(Icons.verified),
          ),
          SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: !_isVisited
                ? null
                : () {
                    setState(() {
                      courseController.visited.value = false;
                    });
                  },
            label: Text('계획중이에요!'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(!_isVisited ? Colors.green[400] : Colors.grey[300]),
              foregroundColor: MaterialStateProperty.all(!_isVisited ? Colors.white : Colors.grey[700]),
            ),
            icon: Icon(Icons.tour),
          ),
        ],
      ),
    );
  }
}
