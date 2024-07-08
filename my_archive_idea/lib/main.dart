import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_archive_idea/data/idea_info.dart';
import 'package:my_archive_idea/database/database_helper.dart';
import 'package:my_archive_idea/screen/detail_screen.dart';
import 'package:my_archive_idea/screen/edit_screen.dart';
import 'package:my_archive_idea/screen/main_screen.dart';
import 'package:my_archive_idea/screen/splash_screen.dart';

void setupLocator() {
  GetIt.instance.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
}

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Archive Idea',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/main': (context) => MainScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/edit') {
          // 1. 아이디어 기록값을 넘기지 못한다면 삽입 시나리오
          // 2. 아이디어 기록값을 넘길 수 있다면 수정 시나리오
          final IdeaInfo? ideaInfo = settings.arguments as IdeaInfo?;
          return MaterialPageRoute(
            builder: (context) {
              return EditScreen(ideaInfo: ideaInfo,);
            },
          );
        }
        else if (settings.name == '/detail') {
          final IdeaInfo? ideaInfo = settings.arguments as IdeaInfo?;
          return MaterialPageRoute(builder: (context) {
            return DetailScreen(ideaInfo: ideaInfo);
          },);
        }
      },
    );
  }
}
