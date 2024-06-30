import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 텍스트 필드에 입력된 값을 저장하려면 controller 필요
  // controller 객체를 전역변수로 선언
  TextEditingController introduceController = TextEditingController();
  bool isEditMode = false; // 자기소개 수정 모드 상태

  @override
  void initState() {
    super.initState();
    // 위젯이 처음 실행될 때 호출하는 부분
    getIntroduceData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.accessibility_new,
          color: Colors.black,
          size: 32,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '발전하는 개발자 전도연을 소개합니다',
          style: TextStyle(
              fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        // 스크롤
        child: Column(
          // Column은 기본적으로 가운데 정렬
          crossAxisAlignment: CrossAxisAlignment.start, // 좌측 정렬
          children: [
            // 프로필 사진
            Container(
              margin: EdgeInsets.all(16),
              width: double.infinity, // 디바이스 기준으로 좌우를 최대로 늘림
              height: 300,
              child: ClipRRect(
                // Clip'R'Rect->둥글게 자름
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/me.jpg',
                  fit: BoxFit.cover,
                ),
              ), // fit->이미지 잘라서 화면 채움
            ),
            // 이름 섹션
            Container(
              // symmetric->가로/세로 규격
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Container(
                      width: 150,
                      child: Text(
                        '이름',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Text(
                    '전도연',
                  ),
                ],
              ),
            ),
            // 나이 섹션
            Container(
              // symmetric->가로/세로 규격
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Container(
                      width: 150,
                      child: Text(
                        '나이',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Text(
                    '22',
                  ),
                ],
              ),
            ),
            // 취미 섹션
            Container(
              // symmetric->가로/세로 규격
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Container(
                      width: 150,
                      child: Text(
                        '취미',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Text(
                    '게임',
                  ),
                ],
              ),
            ),
            // 직업 섹션
            Container(
              // symmetric->가로/세로 규격
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Container(
                      width: 150,
                      child: Text(
                        '직업',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Text(
                    '학생',
                  ),
                ],
              ),
            ),
            // 학력 섹션
            Container(
              // symmetric->가로/세로 규격
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Container(
                      width: 150,
                      child: Text(
                        '학력',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Text(
                    '경희대학교 재학',
                  ),
                ],
              ),
            ),
            // MBTI 섹션
            Container(
              // symmetric->가로/세로 규격
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Container(
                      width: 150,
                      child: Text(
                        'MBTI',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Text(
                    'INTJ',
                  ),
                ],
              ),
            ),

            // 자기소개
            Row(
              // spaceBetween->row의 요소 사이를 최대로 벌림
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16, top: 16),
                  child: Text(
                    '자기소개',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Container나 Icon에는 클릭 기능X->GestureDetector로 억지로 부여
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(right: 16, top: 16),
                    child: Icon(
                      Icons.mode_edit,
                      color:
                          isEditMode == true ? Colors.blueAccent : Colors.black,
                      size: 24,
                    ),
                  ),
                  onTap: () async {
                    if (isEditMode == false) {
                      setState(() {
                        // 변경되는 값은 setState로 감싸기
                        // update widget

                        isEditMode = true;
                      });
                    } else {
                      // 편집이 종료->저장 로직 구현
                      // SharedPreference->데이터 저장을 위한 간단한 라이브러리
                      // 주의: 여기서는 저장만 함->불러오는 로직도 따로 구현해야 함(맨 위)
                      var sharedPref = await SharedPreferences.getInstance();

                      // 입력값이 없는 경우
                      if (introduceController.text.isEmpty) {
                        // snackBar->사용자에게 안내 메시지를 보여줌
                        var snackBar = SnackBar(  // snackBar 정의
                          content: Text('자기소개 입력값이 비어있습니다.'),
                          duration: Duration(seconds: 2), // 메시지가 보여지는 시간
                        );
                        // snackBar 사용
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }

                      // 문자열을 저장함->setString
                      // key 값->introduce
                      // value 값->컨트롤러가 갖는 텍스트 값
                      sharedPref.setString(
                          'introduce', introduceController.text);

                      // 저장이 정상적으로 종료된 후에 편집모드 변경
                      setState(() {
                        isEditMode = false;
                      });
                    }
                  },
                ),
              ],
            ),
            // 텍스트 필드
            Container(
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: TextField(
                  maxLines: 5, // 최대 입력 줄 수->필드 높이 조정 가능
                  controller: introduceController, // controller 연동
                  enabled: isEditMode, // 쓰기 활성화
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color(0xffd9d9d9)), // Color->RGB
                  )),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> getIntroduceData() async {
    // 저장된 자기소개 데이터를 가져오는 메서드
    // 여기서 정의, initState에서 불러옴
    var SharedPref = await SharedPreferences.getInstance();
    String introduceMsg = SharedPref.getString('introduce').toString();

    // 저장된 값이 없는, null인 상황을 고려해야 함->일단 컨트롤러에게 전달
    introduceController.text = introduceMsg ?? "";  // ?? : null 함유 연산자
  }
}
