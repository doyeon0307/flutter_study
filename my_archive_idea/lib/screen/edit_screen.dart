import 'package:flutter/material.dart';
import 'package:my_archive_idea/database/database_helper.dart';
import '../data/idea_info.dart';

class EditScreen extends StatefulWidget {
  // ideaInfo가 null->floating button을 눌러 넘어온 것
  // 널이 아님->수정하기로 넘어온 것
  // 따라서 this.ideaInfo 앞에 required를 붙이지 않음 (필수 인자X)
  IdeaInfo? ideaInfo;

  EditScreen({super.key, this.ideaInfo});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  // 아이디어 제목
  final TextEditingController _titleController = TextEditingController();

  // 아이디어 계기
  final TextEditingController _motiveController = TextEditingController();

  // 아이디어 내용
  final TextEditingController _contentController = TextEditingController();

  // 아이디어 중요도 점수
  final TextEditingController _priorityController = TextEditingController();

  // 유저 피드백 사항
  final TextEditingController _feedbackController = TextEditingController();

  // 아이디어 중요도 점수 container 클릭 상태 관리 변수
  bool isClickPoint1 = false;
  bool isClickPoint2 = false;
  bool isClickPoint3 = true;
  bool isClickPoint4 = false;
  bool isClickPoint5 = false;

  // 현재 선택된 중요도    점수 (default value = 3)
  int priorityPoint = 3;

  // database helper
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // back버튼을 누르면 main으로 가도록 icon에 클릭기능
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 24,
            color: Colors.black,
          ),
          onTap: () {
            // back button
            Navigator.pop(context);
          },
        ),
        title: Text(
          '새 아이디어 작성하기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('제목'),
              Container(
                margin: EdgeInsets.only(top: 8),
                height: 41,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffd9d9d9),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: '아이디어 제목',
                    hintStyle: TextStyle(color: Color(0xffb4b4b4)),
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  controller: _titleController,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text('아이디어를 떠올린 계기'),
              Container(
                margin: EdgeInsets.only(top: 8),
                height: 41,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffd9d9d9),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: '아이디어를 떠올리게 된 계기',
                    hintStyle: TextStyle(color: Color(0xffb4b4b4)),
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  controller: _motiveController,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text('아이디어 내용'),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: TextField(
                  maxLength: 500,
                  maxLines: 5,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffd9d9d9),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: '떠올리신 아이디어를 자세하게 작성해주세요',
                    hintStyle: TextStyle(color: Color(0xffb4b4b4)),
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  controller: _contentController,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text('아이디어 중요도 점수'),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // button1
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 40,
                        decoration: ShapeDecoration(
                            color: isClickPoint1
                                ? Color(0xffd6d6d6)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            )),
                        child: Text(
                          '1',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        // 1. 모든 버튼 값 초기화
                        initClickStatus();
                        // 2. 선택된 변수에 대한 값 및 위젯 update
                        setState(() {
                          priorityPoint = 1;
                          isClickPoint1 = true;
                        });
                      },
                    ),
                    // button2
                    GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 40,
                          decoration: ShapeDecoration(
                              color: isClickPoint2
                                  ? Color(0xffd6d6d6)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              )),
                          child: Text(
                            '2',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          // 1. 모든 버튼 값 초기화
                          initClickStatus();
                          // 2. 선택된 변수에 대한 값 및 위젯 update
                          setState(() {
                            priorityPoint = 2;
                            isClickPoint2 = true;
                          });
                        }),
                    // button3
                    GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 40,
                          decoration: ShapeDecoration(
                              color: isClickPoint3
                                  ? Color(0xffd6d6d6)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              )),
                          child: Text(
                            '3',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          // 1. 모든 버튼 값 초기화
                          initClickStatus();
                          // 2. 선택된 변수에 대한 값 및 위젯 update
                          setState(
                            () {
                              priorityPoint = 3;
                              isClickPoint3 = true;
                            },
                          );
                        }),
                    // button4
                    GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 40,
                          decoration: ShapeDecoration(
                              color: isClickPoint4
                                  ? Color(0xffd6d6d6)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              )),
                          child: Text(
                            '4',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          // 1. 모든 버튼 값 초기화
                          initClickStatus();
                          // 2. 선택된 변수에 대한 값 및 위젯 update
                          setState(
                            () {
                              priorityPoint = 4;
                              isClickPoint4 = true;
                            },
                          );
                        }),
                    // button5
                    GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 40,
                          decoration: ShapeDecoration(
                              color: isClickPoint5
                                  ? Color(0xffd6d6d6)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              )),
                          child: Text(
                            '5',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          // 1. 모든 버튼 값 초기화
                          initClickStatus();
                          // 2. 선택된 변수에 대한 값 및 위젯 update
                          setState(
                            () {
                              priorityPoint = 5;
                              isClickPoint5 = true;
                            },
                          );
                        }),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text('유저 피드백 사항(선택)'),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: TextField(
                  maxLength: 500,
                  maxLines: 5,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffd9d9d9),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: '떠올리신 아이디어를 기반으로\n전달받은 피드백들을 정리해주세요',
                    hintStyle: TextStyle(color: Color(0xffb4b4b4)),
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  controller: _feedbackController,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              // 아이디어 작성 완료 버튼
              GestureDetector(
                child: Container(
                  height: 65,
                  alignment: Alignment.center,
                  child: Text('아이디어 작성 완료'),
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                onTap: () async {
                  // 아이디어 작성 처리 (database insert)
                  String titleValue = _titleController.text.toString();
                  String motiveValue = _motiveController.text.toString();
                  String contentValue = _contentController.text.toString();
                  String feedbackValue = _feedbackController.text.toString();

                  // 유효성 검사 (비어있는 필수 입력값 체크)
                  if (titleValue.isEmpty ||
                      motiveValue.isEmpty ||
                      contentValue.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('비어있는 입력값이 존재합니다'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  if (widget.ideaInfo == null) {
                    // 아이디어 정보 클래스 인스턴스 생성 후 db 삽입
                    var ideaInfo = IdeaInfo(
                      title: titleValue,
                      motive: motiveValue,
                      content: contentValue,
                      priority: priorityPoint,
                      feedback: feedbackValue.isNotEmpty ? feedbackValue : '',
                      createdAt: DateTime.now().millisecondsSinceEpoch,
                    );
                    await setInsertIdeaInfo(ideaInfo);
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void initClickStatus() {
    // 클릭 상태를 초기화하는 함수
    isClickPoint1 = false;
    isClickPoint2 = false;
    isClickPoint3 = false;
    isClickPoint4 = false;
    isClickPoint5 = false;
  }

  Future setInsertIdeaInfo(IdeaInfo ideaInfo) async {
    await dbHelper.initDatabase();
    await dbHelper.insertIdeaInfo(ideaInfo);
  }}