// alt + enter -> 아래 import 코드 자동완성
import 'package:flutter/material.dart';

// 보통 시작화면을 Splash Screen이라 부름
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  // stf에서는 처음으로 실행될 요소를 initState()에 작성했음
  // stl은 state가 없으므로 initState 정의도 불가능
  // 그렇다면 초기 상태를 어떻게 정의할 것인가?
  // -> build 내부에!

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      // 화면 이동 코드
      // Navigator : 화면 이동에 대한 모든 것을 지원하는 클래스
      // pushNamed : 화면을 미는, 생성하는 메소드 ; 원래 화면 사라짐X, 그 위에 햄버거처럼 새 화면을 쌓는 것
      // Splash -> Main
      Navigator.pushNamed(context, '/main');
    });
    // Center 안에 배치된 요소들은 모두 화면 중앙에 위치, 정렬 위젯
    // 중요! 자동정렬 단축키 : Ctrl + Alt + L
    return Scaffold(
      body: Center(
        child: Text('시작화면입니다.'),
      ),
    );
  }
}
