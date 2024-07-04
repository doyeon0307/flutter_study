import 'package:flutter/material.dart';
import 'package:my_archive_idea/data/idea_info.dart';

class DetailScreen extends StatelessWidget {
  IdeaInfo? ideaInfo;
  DetailScreen({super.key, this.ideaInfo});

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
    );
  }
}
