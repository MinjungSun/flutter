class WebtoonDetailModel {
  final String title, about, genre, age;

//JSON 값을 클래스의 속성에 자동으로 매핑하기 위해 WebtoonDetailModel 클래스에서 생성자 fromJson을 만들 수 있습니다.
  WebtoonDetailModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        about = json['about'],
        genre = json['genre'],
        age = json['age'];
}
