import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  dynamic newsItem;

  DetailScreen({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextButton(
          child: Text(
            '뒤로가기',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지
              Container(
                width: double.infinity,
                height: 245,
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
              // 제목
              Container(
                margin: EdgeInsets.only(top: 32),
                child: Text(
                  newsItem['title'],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              // 일자
              Align(
                child: Text(
                  formatDate(newsItem['publishedAt']),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
                alignment: Alignment.bottomRight,
              ),
              SizedBox(
                height: 32,
              ),
              // 내용
              newsItem['description'] != null
                  ? Text(
                      newsItem['description'],
                      style: TextStyle(),
                    )
                  : Text('내용없음')
            ],
          ),
        ),
      ),
    );
  }

  String formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final formatter = DateFormat('yyyy.MM.dd HH:mm');
    return formatter.format(dateTime);
  }
}
