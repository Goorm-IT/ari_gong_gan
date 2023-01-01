import 'package:flutter/material.dart';

class EmptyBookCard extends StatefulWidget {
  const EmptyBookCard({super.key});

  @override
  State<EmptyBookCard> createState() => _EmptyBookCardState();
}

class _EmptyBookCardState extends State<EmptyBookCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        color: Colors.white,
      ),
      height: 290,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "인증가능한 내역이 없습니다",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 40,
            ),
            Text('메인 페이지의 "예약하기"에서 예약을 진행해 보세요!'),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
