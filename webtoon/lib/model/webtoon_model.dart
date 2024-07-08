class WebtoonModel {
  final String title, thumb, id;

  // named constructor; 이름이 있는 생성자
  WebtoonModel.fromJson(Map<String, dynamic> json)
      :
      // WebtoonModel의 title을 api에서 받은 json의 title로 초기화
        title=json['title'],
        thumb=json['thumb'],
        id=json['id'];
}