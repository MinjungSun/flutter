import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/detail_screen.dart';

class WebToonWidget extends StatelessWidget {
  final String title, thumb, id;

  //이 웹툰 클래스를 불러다 쓸때, 아래 세개는 꼭 입력해야된다는것
  const WebToonWidget({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    //제스쳐디텍터는 대부분의 동작을 감지해줌
    debugPrint('thumb=$thumb');
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          //루트로 감싸서 마치 다른 페이지처럼 보이게 해줌
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              //여기서 디테일스크린으로 3가지 정보를 보내줬기때문에 detail_screen.dart에서 title을 불러다 쓸 수 있는것임.
              title: title,
              thumb: thumb,
              id: id,
            ),
            //화면전환할때 이미지가 밑에서 풀스크린으로 오고, 아이콘은 x로 바뀜
            fullscreenDialog: true,
          ),
        );
      },
      child: Column(
        children: [
          //컨테이너를 Hero로 감쌌고, 같은부분이 있는 다른 페이지에서 똑같이 tag를 주면 연결됨
          Hero(
            tag: id,
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
              // child: Image.network(
              //   thumb,
              //   headers: const {'Accept': 'image/*'},
              // ),
              // child: Image.network(
              //   thumb,
              //   headers: const {
              //     "User-Agent":
              //         "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
              //     'Accept': 'image/*',
              //   },
              child: Image.network(
                thumb,
              ),
            ),
          ),

          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
