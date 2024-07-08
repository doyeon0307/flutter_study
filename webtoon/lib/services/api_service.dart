import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtoon/model/webtoon_model.dart';

class ApiService {
  // Api url
  static const String baseUrl = 'https://webtoon-crawler.nomadcoders.workers.dev';
  static const String today = 'today';

  static Future<List<WebtoonModel>> getTodaysToons() async {
    // 1. api에게 데이터를 요청한다
    // 2. response를 다트에서 사용할 수 있는 정보로 만든다->클래스
    // 3. 데이터를 관리할 수 있도록 모든 클래스를 리스트에 담는다

    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    // async & await -> 비동기, response를 기다림
    // get의 return type이 future이므로 response의 데이터타입은 자동으로 Response가 됨
    final response = await http.get(url);
    if (response.statusCode == 200) { // 응답이 정상적이면
      // response.body는 String->json으로 decode
      // dynamic object(이하 webtoon)들을 List로 받아 webtoons에 저장
      // webtoon으로 클래스를 만듦(데이터 모델)
      final List<dynamic> webtoons = jsonDecode(response.body);
      // webtoon을 fromJson(constructor)으로 넘겨줌
      // 각 webtoon 오브젝트를 WebtoonModel로 만듦
      for (var webtoon in webtoons) {
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
      }
      return webtoonInstances;
    }
    throw Error();  // 응답이 비정상적이면
  }
}