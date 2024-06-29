import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 메인화면
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('메인화면'),
        ),
        body: Column(
          children: [
            TextButton(onPressed: (){
              // todo
              // 중요! 새로운 화면을 생성하면서 이동한다
              Navigator.pushNamed(context, '/sub', arguments: 'hello'); // argument-화면을 넘길 때 전달하는 인자
              // 화면 간 인자를 주고받기 위해서는 main.dart를 수정해야 함
            }, child: Text('텍스트를 클릭하여 서브화면으로 이동'))
          ],
        ),
        drawer: Drawer(child: ListView(children: [
          DrawerHeader(child: Text('헤더 영역')),
          ListTile(title: Text('홈 화면'), onTap: (){

          }),
          ListTile(title: Text('메인 화면'), onTap: (){

          }),
          ListTile(title: Text('서브 화면'), onTap: (){

          }),
      ],),),
    );
  }
}
