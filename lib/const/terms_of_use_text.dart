import 'package:ari_gong_gan/widget/custom_dotted_line.dart';
import 'package:flutter/material.dart';

Widget suriTermsOfUse() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "이용수칙",
          style: titleStyle(),
        ),
        SizedBox(
          height: 9,
        ),
        Text(
          "1. 음료 반입 가능, 음식 반입 불가 \n2. 대화/토론 가능, 고성방가 불가\n3. 학승용 룸 예약 가능\n4. 쓰레기는 쓰레기통에 버리기\n5. 그네를 자이로스윙처럼 타기 금지",
          style: contentStyle(),
        ),
        SizedBox(
          height: 32,
        ),
        custom_dotted_line(margin: 0, divide: 2),
        SizedBox(
          height: 21,
        ),
        Text(
          "Life DESIGN Lab Carrer\nDESIGN Room/Smart Room(회의실)",
          style: titleStyle(),
        ),
        SizedBox(
          height: 9,
        ),
        Text(
          "1. 안양대학교 재학생들의 학승공간\n2. 학생지도공동체(Life DESIGN Lab 프로그램)활동장소\n3. 비교과 프로그램 운영 장소",
          style: contentStyle(),
        ),
        SizedBox(
          height: 32,
        ),
        custom_dotted_line(margin: 0, divide: 2),
        SizedBox(
          height: 21,
        ),
        Text(
          "Career DESIGN Room/\nSmart Room(회의실)",
          style: titleStyle(),
        ),
        SizedBox(
          height: 9,
        ),
        Text(
          "1. 학생지도공동체, 스터디, 공모전 준비 등 다양한 팀 활동을 지원하기 위한 공간\n2. 개인의 단독 사용은 불가\n3. 이용시간은 최대 2시간으로 제한\n4. 개인짐을 놓고 장시간 자리를 비울 경우 타 학우들에게 피해가 갈 수 있으니 주의 바람\n5. 다음 사용자를 위해 쓰레기는 휴지통에 버리고, 책상과 의자 등 주변 정리\n6. 학샐지도공동체(Life DESIGN Lab 프로그램)활동 및 비교과 프로그램이 있을 경우 Room 사용이 불가",
          style: contentStyle(),
        ),
        SizedBox(
          height: 32,
        ),
        custom_dotted_line(margin: 0, divide: 2),
        SizedBox(
          height: 21,
        ),
        Text(
          "운영시간",
          style: titleStyle(),
        ),
        SizedBox(
          height: 9,
        ),
        Text(
          "운영시간은 9:00-21:00 입니다.",
          style: contentStyle(),
        ),
        SizedBox(
          height: 32,
        ),
        custom_dotted_line(margin: 0, divide: 2),
        SizedBox(
          height: 21,
        ),
        Text(
          "안내사항",
          style: titleStyle(),
        ),
        SizedBox(
          height: 9,
        ),
        Text(
          "이 공간은 자유로운 분위기 속에서 창의적인 아이디어를 창출하기 위해 만들어진공간입니다.\n\n따라서 이 공간은 9:00-17:00까지는 음악을 틀어놓고, 카페 같은 자연스러운 분위기를 연출하는 곳입니다.\n\n정숙한 분위기의 공부를 원하시는 학우께서는 바로 옆에 위치한 열람실을 이용해 주시기 바라오며, 중간고사 기간이 끝난 이후부터 다시 음악을 재생할 예정이오니 참고하시기 바랍니다.",
          style: contentStyle(),
        ),
        SizedBox(
          height: 32,
        ),
      ],
    ),
  );
}

Widget subongTermsOfUse() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "이용수칙",
          style: titleStyle(),
        ),
        SizedBox(
          height: 9,
        ),
        Text(
          "1. 코로나 19 방역 수칙 준수\n    (마스크 미착용 시 출입 불가) \n2. 음식물 반입 및 취식 금지\n3. 주변 청결 유지",
          style: contentStyle(),
        ),
        SizedBox(
          height: 32,
        ),
        custom_dotted_line(margin: 0, divide: 2),
        SizedBox(
          height: 21,
        ),
        Text(
          "Life DESIGN Lab",
          style: titleStyle(),
        ),
        SizedBox(
          height: 9,
        ),
        Text(
          "1. 안양대학교 재학생들의 학습공간\n2. 학생지도공동체(Life DESIGN Lab) 활동 장소",
          style: contentStyle(),
        ),
        SizedBox(
          height: 32,
        ),
        custom_dotted_line(margin: 0, divide: 2),
        SizedBox(
          height: 21,
        ),
        Text(
          "안내사항",
          style: titleStyle(),
        ),
        SizedBox(
          height: 9,
        ),
        Text(
          "이곳은 모두가 함께 사용하는 공간이므로 일부 개인 또는 그룹의 독점 사용을 금지합니다.",
          style: contentStyle(),
        )
      ],
    ),
  );
}

Widget ariTermsOfUse() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "이용수칙",
          style: titleStyle(),
        ),
        SizedBox(
          height: 9,
        ),
        Text(
          "1. 예약표에 사용하려는 시간에 인적사항 적기 \n2. 예약한 시간에 스터디룸 방문하여 이용\n3. 이용이 끝난 후 꼭 자리정돈하고 일어날 것",
          style: contentStyle(),
        ),
        SizedBox(
          height: 32,
        ),
        custom_dotted_line(margin: 0, divide: 2),
        SizedBox(
          height: 21,
        ),
        Text(
          "제한사항",
          style: titleStyle(),
        ),
        SizedBox(
          height: 9,
        ),
        Text(
          "스터디룸 내 식사 절대 금지",
          style: contentStyle(),
        ),
        SizedBox(
          height: 32,
        ),
        custom_dotted_line(margin: 0, divide: 2),
        SizedBox(
          height: 21,
        ),
        Text(
          "안내사항",
          style: titleStyle(),
        ),
        SizedBox(
          height: 9,
        ),
        Text(
          "쾌적한 스터디룸 이용을 위한 규칙입니다.\n불이행시 스터디룸 이용이 제한될 수 있습니다.\n\n이곳은 모두를 위한 스터디 공간입니다.",
          style: contentStyle(),
        )
      ],
    ),
  );
}

TextStyle titleStyle() {
  return TextStyle(
      fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xff4888E0));
}

TextStyle contentStyle() {
  return TextStyle(
      fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xff4888E0));
}
