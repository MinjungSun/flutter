import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/webtoon_detail_model.dart';
import 'package:flutter_application_1/models/webtoon_episode_model.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/widgets/episode_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;
  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  //초기화하고싶은 메소드가 있지만 constrouctor에서는 불가능할때 late를 쓰고 밑에서 초기화한다.
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;

  //하트 누르는것
  late SharedPreferences prefs;

  //like 누른적 있는지 체크하려는 것
  bool isLiked = false;

  //메소드로 인스턴스를 만들었음->사용자의 저장소에 connection이 생김
  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');
    //여기서 getStringList가 might be null 이기 때문에 아래 if문으로 체크하고 없으면 만든다.
    if (likedToons != null) {
      if (likedToons.contains(widget.id) == true) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      await prefs.setStringList('likedToons', []);
    }
  }

  //위에 webtoon에서 바로 부르면 생성자 안에서 초기화할 수 없기 때문에 아래 initState에서 한다.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //사용자가 클릭해서 나온 id가 필요하기때문에 homeScreen에서와 달리 이렇게 하는것임.
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
    initPrefs();
  }

  onHeartTap() async {
    final likedToons = prefs.getStringList('likedToons');
    //like 눌렀는지 보고 눌렀으면 리스트에서 제거하고 안눌렀으면 리스트에 추가함
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.id);
      } else {
        likedToons.add(widget.id);
      }
      //이제 이 결과를 폰 저장소에 저장해야됨
      //('key',value) 임
      await prefs.setStringList('likedToons', likedToons);
      //그리고 마지막으로 isliked의 반대 상태를 저장함(눌렀으니까)
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(isLiked ? Icons.favorite : Icons.favorite_outline),
          )
        ],
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      //body에 있던 padding을 스크롤뷰로 바꿨음.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //컨테이너를 Hero로 감쌌고, 같은부분이 있는 다른 페이지에서 똑같이 tag를 주면 연결됨
                  Hero(
                    //여기에 있는 widget은 맨 위에 DetailScreen 클래스를 나타냄
                    //이것이 StatefulWidget의 build 메소드가 DetailScreen의 정보를 받아오는 방법임
                    //wiget은 부모에게 가라는 의미임. DetailScreen과 StatefulWidget으로 가라.
                    tag: widget.id,
                    child: Container(
                      width: 250,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15,
                            offset: const Offset(10, 10),
                            color: Colors.black.withOpacity(0.3),
                          )
                        ],
                      ),
                      //child: Image.network(widget.thumb),
                      child: Image.network(
                        widget.thumb,
                        headers: const {
                          "User-Agent":
                              "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                //첫번째 future는(기다리는것) webtoon future이다.
                future: webtoon,
                //builder는 widget을 리턴하는 펑션이다.
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  }
                  return const Text('데이터 없음');
                },
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: episodes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var episode in snapshot.data!)
                          Episode(episode: episode, webtoonId: widget.id),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
