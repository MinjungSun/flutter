class WebtoonModel {
  final String title, thumb, id;

//이건 평범한 생성자
  // WebtoonModel({
  //   required this.title,
  //   required this.thumb,
  //   required this.id,
  // });

  //json으로 받는 생성자를 만들것임
  WebtoonModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'],
        id = json['id'];
}
