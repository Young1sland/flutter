import 'package:flutter/material.dart';
import 'package:toonflix/screens/detail_screen.dart';

class Webtoon extends StatelessWidget {
  final String title, thumb, id;

  const Webtoon({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Navigator.push : 애니메이션 효과 통해 다른 페이지로 왔다고 느끼게 해줄 수 있음
        //화면 위에 새로운 위젯을 올려줌
        Navigator.push(
          context,
          MaterialPageRoute(
            //화면 전환의 애니메이션을 제공
            builder: (context) => DetailScreen(
              title: title,
              thumb: thumb,
              id: id,
            ),
            fullscreenDialog: true, //풀스크린 다이얼로그로 설정.
          ),
        );
      },
      child: Column(
        children: [
          //Hero : 두 화면 사이에 애니메이션 효과를 주는 컴포넌트
          Hero(
            tag: id,
            //이미지 크기를 SizedBox또는 Container로 제한해 줌
            child: Container(
              width: 250,
              //clipBehavior : 자식의 부모 영역 침범을 처리하는 방법 정의, BorderRadius 효과 주기 위함
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    offset: const Offset(10, 10),
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
              ),
              child: Image.network(thumb),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
