import 'package:first_project/screen/main_screen.dart';
import 'package:first_project/screen/splash_screen.dart';
import 'package:first_project/screen/sub_screen.dart';
import 'package:flutter/material.dart';

void main() {
  // 프로그램의 시작 지점
  // runApp으로 MyApp을 실행시킴
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp( // 하나의 애플리케이션 영역
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // home: 시작할 때 보이는 스크린 지정
      // 라우트로 더 유연한 작업 가능
      initialRoute: '/',
      routes: {
        // 두 screen은 다른 파일에 정의 -> import 필요
        '/': (context) => SplashScreen(),
        '/main': (context) => MainScreen(),
        // '/sub': (context) => SubScreen(),
      },
      // 화면 간 인자 전달을 위해 추가한 내용
      onGenerateRoute: (settings) {
        if (settings.name == '/sub') {
          String msg = settings.arguments as String;  // argument를 string으로 형변환
          return MaterialPageRoute(builder: (context) {
            return SubScreen(msg: msg,);
          },);
        }
      },
    );
  }
}
