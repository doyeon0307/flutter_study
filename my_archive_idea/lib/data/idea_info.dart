class IdeaInfo {
  // 데이터에 대한 primary key
  int? id; // ?->null safety

  String title; // 아이디어 제목
  String motive; // 작성 계기
  String content; // 아이디어 내용
  int priority; // 아이디어 중요도 점수
  String feedback; // 유저 피드백 사항(선택)
  int createdAt; // 생성일시(년월일시분)

  // alt + insert -> Constructor
  // required -> 필수 입력
  IdeaInfo({
    this.id,
    required this.title,
    required this.motive,
    required this.content,
    required this.priority,
    required this.feedback,
    required this.createdAt,
  });

  // 데이터베이스와 연동할 때 Map 처리 필요
  // Map -> key, value로 이루어진 자료형
  Map<String, dynamic> toMap() {
    // Map 객체로 변환
    return {
      'id': id,
      'title': title,
      'motive': motive,
      'content': content,
      'priority': priority,
      'feedback': feedback,
      'createdAt': createdAt,
    };
  }

  // factory->캐싱->인스턴스를 매번 생성하지 않음
  factory IdeaInfo.fromMap(Map<String, dynamic> map) {
    return IdeaInfo(
      id: map['id'],
      title: map['title'],
      motive: map['motive'],
      content: map['content'],
      priority: map['priority'],
      feedback: map['feedback'],
      createdAt: map['createdAt'],
    );
  }
}