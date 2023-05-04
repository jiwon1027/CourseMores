import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:lottie/lottie.dart';

class MakeStepper extends StatefulWidget {
  const MakeStepper({super.key});

  @override
  State<MakeStepper> createState() => _MakeStepperState();
}

class _MakeStepperState extends State<MakeStepper> {
  int _currentStep = 0;

  final List<Step> _mySteps = [
    Step(
      title: Text('필수 입력'),
      content: Center(
          child: Column(
        children: [
          Text(
            '코스 상세 필수 내용',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            '코스 이름과 방문 여부를 입력해주세요.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          SizedBox(
            height: 30,
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
                    Text(
                      '코스 장소',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: const [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage("assets/img1.jpg"),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          '이도곰탕 외 3곳',
                          style: TextStyle(fontSize: 20, color: Colors.cyan),
                        ),
                      ],
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
                        Text(
                          '코스 이름',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '*',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    SizedBox(height: 8), // 간격 추가
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '코스 이름을 입력하세요',
                      ),
                      onChanged: (text) {
                        // 사용자의 입력이 변화할 때마다 실행되는 콜백 함수
                        print('User typed: $text');
                      },
                    ),
                    Text(
                      '(30자 이상, 기타 입력조건)',
                      style: TextStyle(color: Colors.grey),
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
                        Text(
                          '방문 여부',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '*',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
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
        title: Text('선택 입력'),
        content: Center(
          child: Column(
            children: [
              Text(
                '코스 상세 선택 내용',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                '코스 상세 내용을 선택적으로 입력해주세요.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
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
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // 자식 위젯을 왼쪽 정렬
                      children: const [
                        Text(
                          '인원수',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 8), // 간격 추가
                        Slider1(),
                        SizedBox(height: 5),
                        // Text('Slider Value: $_sliderValue'),
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
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // 자식 위젯을 왼쪽 정렬
                      children: const [
                        Text(
                          '소요 시간',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
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
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // 자식 위젯을 왼쪽 정렬
                      children: [
                        Text(
                          '코스 내용',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 8), // 간격 추가
                        TextField(
                          decoration: InputDecoration(
                            hintText: '내용은 150자까지 입력이 가능합니다', // 힌트 텍스트
                            border: OutlineInputBorder(), // 외곽선
                            labelText: '글 내용', // 라벨 텍스트
                          ),
                          maxLines: null, // 다중 라인으로 입력 가능하게 설정
                          keyboardType:
                              TextInputType.multiline, // 다중 라인으로 입력 가능하게 설정
                          onChanged: (value) {
                            // 사용자가 입력한 텍스트가 변경될 때마다 호출됩니다.
                            print(value);
                          },
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
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // 자식 위젯을 왼쪽 정렬
                      children: const [
                        Text(
                          '해시태그',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 8), // 간격 추가
                        MakeHashtag()
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
        title: Text('테마 선택'),
        content: Center(
          child: Column(
            children: const [
              Text(
                '코스 상세 선택 내용',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                '코스 상세 내용을 선택적으로 입력해주세요.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                '이 코스에는 어울리는 테마는 무엇인가요?',
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
                        Lottie.asset(
                          'assets/success.json',
                          fit: BoxFit.fitWidth,
                          width: 300,
                        ),
                        Text("코스 작성을 완료했어요!"),
                      ],
                    ),
                    actions: <Widget>[
                      Center(
                        child: ElevatedButton(
                          child: Text("확인"),
                          onPressed: () {
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
                  child: ElevatedButton(
                    onPressed: details.onStepCancel,
                    child: const Text('이전으로'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
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
                                Text("코스 작성을 완료했어요!"),
                              ],
                            ),
                            actions: <Widget>[
                              Center(
                                child: ElevatedButton(
                                  child: Text("확인"),
                                  onPressed: () {
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
                    child: const Text('작성 완료'),
                  ),
                ),
              ],
            );
          } else {
            return Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepCancel,
                    child: const Text('이전으로'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
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

class Slider1 extends StatefulWidget {
  const Slider1({
    super.key,
  });

  @override
  State<Slider1> createState() => _Slider1State();
}

class _Slider1State extends State<Slider1> {
  late double _sliderValue = 3;

  Map<int, String> peopleMapping = {
    0: '상관없음',
    1: '1인',
    2: '2인',
    3: '3인',
    4: '4인',
    5: '5인 이상',
  };
  // _slider1State() {
  //   _sliderValue = 0.0;
  // }

  @override
  Widget build(BuildContext context) {
    return SfSlider(
      value: _sliderValue,
      // value: 0,
      min: 0,
      max: 5,
      stepSize: 1,
      shouldAlwaysShowTooltip: true,
      // tooltipTextFormatterCallback: ,
      tooltipTextFormatterCallback: (value, formattedText) {
        return peopleMapping[value.toInt()]?.toString() ?? '';
      },
      showTicks: true,
      showDividers: true,
      interval: 1,
      // showLabels: true,
      onChanged: (newValue) {
        setState(() {
          _sliderValue = newValue;
        });
      },
    );
  }
}

class Slider2 extends StatefulWidget {
  const Slider2({
    super.key,
  });

  @override
  State<Slider2> createState() => _Slider2State();
}

class _Slider2State extends State<Slider2> {
  late double _sliderValue2 = 3;

  Map<int, String> timeMapping = {
    1: '30분 이하',
    2: '30분',
    3: '1시간',
    4: '1시간 30분',
    5: '2시간 이상',
  };
  // _slider1State() {
  //   _sliderValue = 0.0;
  // }

  @override
  Widget build(BuildContext context) {
    return SfSlider(
      value: _sliderValue2,
      // value: 0,
      min: 1,
      max: 5,
      interval: 1,
      stepSize: 1,
      shouldAlwaysShowTooltip: true,
      // tooltipTextFormatterCallback: ,
      tooltipTextFormatterCallback: (value, formattedText) {
        return timeMapping[value.toInt()]?.toString() ?? '';
      },
      showTicks: true,
      showDividers: true,
      // showLabels: true,
      onChanged: (newValue) {
        setState(() {
          _sliderValue2 = newValue;
        });
      },
    );
  }
}

class MakeHashtag extends StatefulWidget {
  // const MakeHashtag({
  //   super.key,
  // });
  const MakeHashtag({
    Key? key,
  }) : super(key: key);

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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // _distanceToField = MediaQuery.of(context).size.width;
    // });
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
          initialTags: const ['연남동맛집', '최애코스', '마포골목대장', '데이트코스'],
          textSeparators: const [' ', ','],
          letterCase: LetterCase.normal,
          validator: (String tag) {
            if (tag == 'php') {
              return 'No, please just no';
              // } else if (_controller.getTags?.contains(tag)) {
            } else if (_controller.getTags?.contains(tag) == true) {
              return 'you already entered that';
            }
            return null;
          },
          inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
            return ((context, sc, tags, onTagDelete) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  controller: tec,
                  focusNode: fn,
                  decoration: InputDecoration(
                    isDense: true,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 74, 137, 92),
                        width: 3.0,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 74, 137, 92),
                        width: 3.0,
                      ),
                    ),
                    // helperText: 'Enter language...',
                    // helperStyle: const TextStyle(
                    //   color: Color.fromARGB(255, 74, 137, 92),
                    // ),
                    hintText: _controller.hasTags ? '' : "태그를 입력하세요",
                    errorText: error,
                    // prefixIconConstraints:
                    //     BoxConstraints(maxWidth: _distanceToField * 0.74),
                    prefixIcon: tags.isNotEmpty
                        ? SingleChildScrollView(
                            controller: sc,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: tags.map((String tag) {
                              return Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  ),
                                  color: Color(0xFFEEEEEE),
                                ),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: Text(
                                        '#$tag',
                                        style: const TextStyle(
                                            color: Color(0xFF6D6AFF)),
                                      ),
                                      onTap: () {
                                        print("$tag selected");
                                      },
                                    ),
                                    const SizedBox(width: 4.0),
                                    InkWell(
                                      child: const Icon(
                                        Icons.cancel,
                                        size: 14.0,
                                        color: Color(0xFFAEAEAE),
                                      ),
                                      onTap: () {
                                        onTagDelete(tag);
                                      },
                                    )
                                  ],
                                ),
                              );
                            }).toList()),
                          )
                        : null,
                  ),
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                ),
              );
            });
          },
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 74, 137, 92),
            ),
          ),
          onPressed: () {
            _controller.clearTags();
          },
          child: const Text('태그 초기화'),
        ),
      ],
    );
  }
}

class ThemeSelect extends StatefulWidget {
  const ThemeSelect({
    super.key,
  });

  @override
  State<ThemeSelect> createState() => _ThemeSelectState();
}

class _ThemeSelectState extends State<ThemeSelect> {
  var themeList = [
    {"text": "혼자 가기 좋은 😎"},
    {"text": "특별한 날 🎠"},
    {"text": "활동적인 🤸‍♀️"},
    {"text": "힐링 🌈"},
    {"text": "갓성비 💸"},
    {"text": "봄놀이 🌸"},
    {"text": "핫플 🔥"},
    {"text": "분위기 좋은 🥂"},
    {"text": "실내 액티비티 🎯"},
    {"text": "가족과 함께 👪"},
  ];

  @override
  Widget build(BuildContext context) {
    List<MultiSelectCard> cards = [];
    for (var theme in themeList) {
      var card = MultiSelectCard(
        value: theme['text'],
        label: theme['text'],
        decorations: MultiSelectItemDecorations(
          decoration: BoxDecoration(
            color: Colors.white,
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
      cards.add(card);
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: MultiSelectContainer(
        items: cards,
        onChange: (allSelectedItems, selectedItem) {
          print("선택된 아이템 리스트 : ");
          print(allSelectedItems);
        },
      ),
    );
  }
}

class CheckVisited extends StatefulWidget {
  const CheckVisited({
    super.key,
  });

  @override
  State<CheckVisited> createState() => _CheckVisitedState();
}

class _CheckVisitedState extends State<CheckVisited> {
  late bool _selectedFirst;
  late bool _selectedSecond;

  _CheckVisitedState() {
    _selectedFirst = false;
    _selectedSecond = false;
  }

  void _selectFirst() {
    setState(() {
      _selectedFirst = true;
      _selectedSecond = false;
    });
  }

  void _selectSecond() {
    setState(() {
      _selectedFirst = false;
      _selectedSecond = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: _selectedFirst ? null : _selectFirst,
            label: Text('다녀왔어요!'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedFirst ? Colors.green : null,
            ),
            icon: Icon(Icons.verified),
          ),
          SizedBox(width: 10),
          ElevatedButton.icon(
              onPressed: _selectedSecond ? null : _selectSecond,
              label: Text('계획중이에요!'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedSecond ? Colors.green : null,
              ),
              icon: Icon(Icons.tour)),
          // SizedBox(height: 20),
          // ElevatedButton(
          //   onPressed: _selectedFirst || _selectedSecond
          //       ? () {
          //           // do something when a selection is made
          //         }
          //       : null,
          //   child: Text('다음'),
          // ),
        ],
      ),
    );
  }
}
