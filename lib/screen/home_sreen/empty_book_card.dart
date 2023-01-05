import 'package:ari_gong_gan/const/colors.dart';
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 30, top: 10),
                  child: ClipOval(
                    child: Container(
                      color: Color(0xff4988e1),
                      height: 25,
                      width: 25,
                      child: IconButton(
                        iconSize: 20,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: const EdgeInsets.all(0),
                        splashRadius: 10.0,
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              "인증가능한 내역이 없습니다",
              style: TextStyle(
                  fontSize: 20,
                  color: PRIMARY_COLOR_DEEP,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              '메인 페이지의 "예약하기"에서 예약을 진행해 보세요!',
              style: TextStyle(
                fontSize: 12,
                color: PRIMARY_COLOR_DEEP,
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
