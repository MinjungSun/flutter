import 'dart:convert';

import 'package:flutter_application_1/models/webtoon_detail_model.dart';
import 'package:flutter_application_1/models/webtoon_episode_model.dart';
import 'package:flutter_application_1/models/webtoon_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";
  //baseUrl에 /today를 추가하면 오늘의 웹툰으로 간다.

//여기서 async는 비동기 프로그래밍을 이야기함. await 붙은곳이 다 실행될때까지 기다리라는것.
//데이터가 올때까지 잠깐 멈춰있어야되는등. await는 무조건 async 함수 내에서만 사용
  static Future<List<WebtoonModel>> getTodaysToon() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    //아래 = 서버로 요청을 보내고, 서버에서 요청을 처리하고 응답을 주는걸 기다림
    //Flutter에서 await http.get(url)은 http 패키지를 사용하여 지정된 URL에 GET 요청을 보내고 응답을 받은 후 프로그램 실행을 계속하는 명령문입니다
    final response = await http.get(url);
    if (response.statusCode == 200) {
      //body에는 서버가 보낸 데이터가 있음
      //JSON 문자열을 Dart 객체로 디코딩하면 이를 사용하여 원하는 방식으로 UI 위젯을 채우고 계산을 수행하거나 데이터를 조작할 수 있습니다.
      final List<dynamic> webtoons = jsonDecode(response.body);

      for (var webtoon in webtoons) {
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
        // final toon = WebtoonModel.fromJson(webtoon);
        // print(toon.title);
      }
      return webtoonInstances;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }
}
