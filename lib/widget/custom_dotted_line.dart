import 'package:flutter/material.dart';

Widget custom_dotted_line({required double margin, required int divide}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: margin),
    child: Row(
      children: List.generate(
        220 ~/ divide,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0 ? Colors.transparent : Color(0xff4888E0),
            height: 1,
          ),
        ),
      ),
    ),
  );
}
