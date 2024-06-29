import 'package:flutter/material.dart';

class SubScreen extends StatelessWidget {
  String msg;

  SubScreen({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            // appBar가 곧 네이게이션바
            automaticallyImplyLeading: false,
            // 좌측 상단의 기본 백버튼 없앰
            leading: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  '뒤로가기',
                  style: TextStyle(color: Colors.teal),
                )),
            title: Text('서브화면'),
            actions: [
              Icon(Icons.ac_unit),
            ],
            // Tab 전환 구현
            bottom: TabBar(tabs: [
              Tab(text: 'Tab1'),
              Tab(text: 'Tab2'),
              Tab(text: 'Tab3'),
            ],),
          ),
          body: TabBarView(
            children: [
              // 단순히 나타낼 탭들을 표현한 것
              // 탭 전환은 AppBar에서 수행
              Center(child: Text('Tab1 Content'),),
              Center(child: Text('Tab2 Content'),),
              Center(child: Text('Tab3 Content'),),
            ],
          )
        ));
  }
}
