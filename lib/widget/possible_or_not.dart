import 'package:flutter/material.dart';

Widget isPossibleColor(bool isPossible) {
  return Row(
    children: [
      Container(
        width: 13,
        height: 13,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(3),
          ),
          color: isPossible ? Color(0xffFFFFFF) : Color(0xffFFF4B4),
        ),
      ),
      Text(
        isPossible ? "  예약 가능" : "  예약 불가",
        style: TextStyle(
          fontFamily: "Noto_Sans_KR",
          fontSize: 12.0,
          color: Color(0xff2772AC),
        ),
      )
    ],
  );
}
