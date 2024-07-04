import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> lstNewsInfo = [];

  @override
  void initState() {
    super.initState();
    // 뉴스 정보 가져오기
    getNewsInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '😎 Headline News',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xff424242),
      ),
      body: ListView.builder(
        itemCount: lstNewsInfo.length,
        itemBuilder: (context, index) {
          // lst에는 모든 뉴스 저장되어있음
          // newsItem에 개별 뉴스 저장
          var newsItem = lstNewsInfo[index];
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.all(16),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // 이미지
                  Container(
                    width: double.infinity,
                    height: 170,
                    child: newsItem['urlToImage'] != null
                        ? ClipRRect(
                            child: Image.network(
                              newsItem['urlToImage'],
                              fit: BoxFit.cover, // 이미지를 꽉 채움
                            ),
                            borderRadius: BorderRadius.circular(10),
                          )
                        : ClipRRect(
                            child: Image.asset('assets/no_image.png'),
                            borderRadius: BorderRadius.circular(10),
                          ),
                  ),
                  // 반투명 검정 박스
                  Container(
                    width: double.infinity,
                    height: 57,
                    decoration: ShapeDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ))),
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 제목
                          Text(
                            newsItem['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis, // 텍스트 자름
                          ),
                          SizedBox(height: 6,),
                          // 일자
                          Align(
                            child: Text(
                              formatDate(newsItem['publishedAt']),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                            alignment: Alignment.bottomRight,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/detail', arguments: newsItem);
            },
          );
        },
      ),
    );
  }

  String formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final formatter = DateFormat('yyyy.MM.dd HH:mm');
    return formatter.format(dateTime);
  }

  Future getNewsInfo() async {
    // 뉴스 정보를 가져오는 API 사용
    const apiKey = '73744916b30b4d0587f3f59f4d43642a';
    const apiUrl =
        'https://newsapi.org/v2/top-headlines?country=kr&apiKey=$apiKey';

    // 네트워크 통신 처리
    try {
      // 네트워크 통신을 요청하고 with response 변수에 결과 값이 저장된다.
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // 200->result ok
        // response의 body에 데이터가 쌓여있고,    decode로 Map형식으로 만듦
        final Map<String, dynamic> responseData = json.decode(response.body);
        // api의 json을 확인해보면 articles라는 key에 데이터가 저장됨
        // 리스트에 필요한 데이터를 받아와 사용
        setState(() {
          lstNewsInfo = responseData['articles'];
        });
        // 데이터 잘 받는지(통신 성공) 확인용 print
        // lstNewsInfo.forEach((element) {
        //   print(element);
        // });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (error) {
      print(error);
    }
  }
}
