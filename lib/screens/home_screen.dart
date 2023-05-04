import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/webtoon_model.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToon();

  @override
  Widget build(BuildContext context) {
    //Scaffold는 screen을 위한 기본적인 레이아웃과 설정을 제공해줌.
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        //elevation은 앱바의 그림자임
        foregroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          "오늘의 웹툰",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // return const Text('There is data!');
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                //제한없는 높이값같은 오류가 나지 않기 위해 빈공간을 알아서 채우는 Expanded 위젯으로 감쌌음
                Expanded(child: makeList(snapshot)),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

//이건 wrap with mathod 한거임.
  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return WebToonWidget(
            title: webtoon.title, thumb: webtoon.thumb, id: webtoon.id);
      },
      //item에 margin이나 padding을 주지 않아도 separatorBuilder가 알아서 배치해줌
      separatorBuilder: (context, index) => const SizedBox(width: 40),
    );
  }
}
