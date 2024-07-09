import 'package:flutter/material.dart';
import 'package:webtoon/model/webtoon_model.dart';
import 'package:webtoon/services/api_service.dart';
import 'package:webtoon/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // 사용할 변수 지정
  Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.green,
        backgroundColor: Colors.white,
        title: Text(
          "오늘의 웹툰",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder(
        // 비동기 구현을 알아서 해주는 위젯
        // 기다리고 싶은 것=webtoons, 즉 api를 받아 클래스 리스트를 만드는 작업
        future: webtoons,
        // builder는 UI를 구현하는 것, future가 끝나고 실행됨
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(child: makeList(snapshot))
              ],
            ); // 여기에 바로 return한 것을 method로 분리
          }
          return Center(
            child: CircularProgressIndicator(), // 로딩하는 원
          );
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    // return ListView(
    //   children: [
    //     // snapshot은 future의 결과
    //     // if문 내부는 future를 정상적으로 불러온 경우 실행->null이 확실히 없다!
    //     // 이를 표현하기 위해 snapshot.data의 끝에 !를 붙여줌
    //     for (var webtoon in snapshot.data!) Text(webtoon.title)
    //   ],
    // );
    // ListView의 단점: 모든 데이터를 가져옴->인스타의 모든 피드를 가져온다? 메모리 die...
    // 사용자가 보고 있는 것만 build하는 최적화된 ListView를 사용한다!
    return ListView.separated(
      // 처음에는 ListView.builder 사용
      // 이후에 separated로 변경
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      // itemCount: 핵심 최적화 기능
      itemBuilder: (context, index) {
        // ListView.builder가 아이템을 build할 때 호출하는 함수
        // index->어떤 아이템이 build되는지 알 수 있음
        var webtoon = snapshot.data![index];
        return Webtoon(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      // 위젯을 리턴, 위젯은 구분자 역할을 함
      separatorBuilder: (context, index) => SizedBox(
        width: 40,
      ),
    );
  }
}
