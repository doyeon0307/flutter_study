import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:my_archive_idea/data/idea_info.dart';
import 'package:my_archive_idea/database/database_helper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // listView에 데이터베이스의 데이터를 표시하기 위한 변수 선언

  var dbHelper = DatabaseHelper(); // 데이터베이스 접근을 용이하게 하는 유틸 객체
  List<IdeaInfo> lstIdeaInfo = []; // 아이디어 목록 데이터가 담길 공간

  @override
  void initState() {
    super.initState();
    // 아이디어 목록들 가져오기
    // getIdeaInfo();

    // 임시 insert data
    dbHelper.initDatabase();
    setInsertIdeaInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Archive idea',
          style: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: lstIdeaInfo.length,
          itemBuilder: (context, index) {
            return GestureDetector(child: listItem(index), onTap: () {
              Navigator.pushNamed(context, '/detail', arguments: lstIdeaInfo[index]);
            },);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 새 아이디어 작성 화면으로 이동
          Navigator.pushNamed(context, '/edit');
        },
        child: Image.asset(
          'assets/idea_button.png',
          width: 48,
          height: 48,
        ),
        backgroundColor: Color(0xff7f52fd).withOpacity(0.7),
      ),
    );
  }

  Widget listItem(int index) {
    // Stack
    return Container(
      height: 82,
      margin: EdgeInsets.only(top: 16),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0xffd9d9d9), width: 1),
            borderRadius: BorderRadius.circular(10),
          )),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // 아이디어 제목
          Container(
            margin: EdgeInsets.only(left: 16, bottom: 16),
            child: Text(
              lstIdeaInfo[index].title,
              style: TextStyle(fontSize: 16),
            ),
          ),
          // 작성일시
          // Align->강제적으로 위치 지정
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(right: 16, bottom: 8),
              child: Text(
                DateFormat("yyyy.MM.dd HH:mm").format(
                    DateTime.fromMillisecondsSinceEpoch(
                        lstIdeaInfo[index].createdAt)),
                style: TextStyle(color: Color(0xffaeaeae), fontSize: 10),
              ),
            ),
          ),
          //아이디어 중요도 점수 (별 형태로)
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(left: 16, bottom: 8),
              child: RatingBar.builder(
                initialRating: lstIdeaInfo[index].priority.toDouble(),
                minRating: 1,
                maxRating: 5,
                direction: Axis.horizontal,
                itemSize: 16,
                itemPadding: EdgeInsets.symmetric(horizontal: 0),
                itemBuilder: (context, index) {
                  return Icon(
                    Icons.star,
                    color: Colors.amber,
                  );
                },
                ignoreGestures: true,
                updateOnDrag: false,
                onRatingUpdate: (double value) {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  // idea 목록 조회 (select)
  Future getIdeaInfo() async {
    // idea들을 DB에서 가져와서 lstInfo(리스트) 객체에 담기
    await dbHelper.initDatabase();
    // init이 완료되어야만 다음 라인 수행->await
    lstIdeaInfo = await dbHelper.getAllIdeaInfo();
    // 아이디어를 작성일시 역순으로 정렬해야 함(최신글이 위)
    lstIdeaInfo.sort(
          (a, b) => b.createdAt.compareTo(a.createdAt),
    );
    // lst ui update
    setState(() {});
  }

  Future setInsertIdeaInfo() async {
    await dbHelper.initDatabase();
    await dbHelper.insertIdeaInfo(
      IdeaInfo(
          title: 'tdd',
          motive: 'mmmm',
          content: 'ccc',
          priority: 5,
          feedback: 'fff?',
          createdAt: DateTime
              .now()
              .millisecondsSinceEpoch),
    );
  }
}