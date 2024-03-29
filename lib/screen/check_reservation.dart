import 'package:ari_gong_gan/model/reservation_by_user.dart';
import 'package:ari_gong_gan/provider/reservation_by_user_provider.dart';
import 'package:ari_gong_gan/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CheckReservation extends StatefulWidget {
  const CheckReservation({Key? key}) : super(key: key);

  @override
  State<CheckReservation> createState() => _CheckReservationState();
}

class _CheckReservationState extends State<CheckReservation> {
  List<ReservationByUser> _inititemList = [];
  List<ReservationByUser> _itemList = [];
  DateTime realTime = GetIt.I<DateTime>();
  TextEditingController sYear = TextEditingController();
  TextEditingController sMonth = TextEditingController();
  TextEditingController sDay = TextEditingController();
  TextEditingController eYear = TextEditingController();
  TextEditingController eMonth = TextEditingController();
  TextEditingController eDay = TextEditingController();
  int _selected = 0;
  int bookedCount = 0;
  @override
  void initState() {
    super.initState();
    _inititemList = context.read<ReservationByUserProvider>().reservationByUser;
    _itemList = _inititemList;
    bookedCount = 0;
    countbooked();
    changeSort(_itemList, _selected);
  }

  @override
  void dispose() {
    sYear.dispose();
    sMonth.dispose();
    sDay.dispose();
    eYear.dispose();
    eMonth.dispose();
    eDay.dispose();
    super.dispose();
  }

  void countbooked() {
    for (int i = 0; i < _itemList.length; i++) {
      if (_itemList[i].status == 'booked') {
        bookedCount++;
      }
    }
  }

  void changePeroid(List<ReservationByUser> list) {
    Iterable<ReservationByUser> _tmp = list.where((e) {
      if (("${sYear.text}-${sMonth.text.padLeft(2, '0')}-${sDay.text.padLeft(2, '0')}"
                      .compareTo(e.realTime.substring(0, 10)) ==
                  -1 ||
              "${sYear.text}-${sMonth.text.padLeft(2, '0')}-${sDay.text.padLeft(2, '0')}"
                      .compareTo(e.realTime.substring(0, 10)) ==
                  0) &&
          ("${eYear.text}-${eMonth.text.padLeft(2, '0')}-${eDay.text.padLeft(2, '0')}"
                      .compareTo(e.realTime.substring(0, 10)) ==
                  1 ||
              "${eYear.text}-${eMonth.text.padLeft(2, '0')}-${eDay.text.padLeft(2, '0')}"
                      .compareTo(e.realTime.substring(0, 10)) ==
                  0)) {
        return true;
      } else {
        return false;
      }
    });
    setState(() {
      _itemList = _tmp.toList();
    });
  }

  void changeSort(List<ReservationByUser> list, int sort) {
    if (sort == 1) {
      //과거
      list.sort((a, b) => a.realTime.compareTo(b.realTime));
      setState(() {
        _itemList = list;
      });
    } else {
      //최근
      list.sort((a, b) => b.realTime.compareTo(a.realTime));
      setState(() {
        _itemList = list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double windowHeight = MediaQuery.of(context).size.height;
    double windowWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: customAppbar(context, true, true),
      body: Stack(
        children: [
          Container(
            height: windowHeight,
            width: windowWidth,
            color: Color(0xff2772ac),
          ),
          Column(
            children: [
              Container(
                width: windowWidth,
                height: 140,
                decoration: BoxDecoration(
                  color: Color(0xffecf3ff),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 33),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 35,
                      ),
                      Text(
                        "예약확인",
                        style: TextStyle(
                          color: Color(0xff2772AC),
                          fontSize: 19,
                          fontFamily: "Noto_Sans_KR",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              'assets/images/beaconSearch.png',
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "인증완료",
                            style: TextStyle(
                              color: Color(0xff2772AC),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 8,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Color(0xff2099EA),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              Container(
                                height: 8,
                                width: 200 * (bookedCount / _itemList.length),
                                decoration: BoxDecoration(
                                  color: Color(0xff2772AC),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ],
                          ),
                          Text.rich(
                            TextSpan(
                              text: '  $bookedCount',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Color(0xff2772AC),
                                  fontWeight: FontWeight.w600),
                              children: [
                                TextSpan(
                                    text: '/',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                                TextSpan(
                                  text: '${_itemList.length}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 28,
              ),
              Container(
                height: 20,
                margin: const EdgeInsets.symmetric(horizontal: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "이전내역",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: "Noto_Sans_KR",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        _sortNperiod(
                          ontap: () {
                            sYear.clear();
                            sMonth.clear();
                            sDay.clear();
                            eYear.clear();
                            eMonth.clear();
                            eDay.clear();
                            showCustomBottomSheet(
                              title: '조회기간',
                              content: _periodBottomSheet,
                            );
                          },
                          title: '조회기간',
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        _sortNperiod(
                          ontap: () {
                            showCustomBottomSheet(
                              title: '최신순',
                              content: _sortBottomSheet,
                            );
                          },
                          title: _selected == 1 ? '과거순' : '최신순',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _listItem(
                reservationInfo: _itemList,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _periodBottomSheet() {
    return Container(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Transform.translate(
              offset: Offset(48, 10),
              child: Row(
                children: [
                  Text(
                    "시작일",
                    style: periodTextStyle(),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.all(0),
                    width: 40,
                    child: TextField(
                      maxLength: 4,
                      style: periodTextStyle(),
                      keyboardType: TextInputType.number,
                      controller: sYear,
                      decoration:
                          inputDecoration(DateFormat('yyyy').format(realTime)),
                    ),
                  ),
                  Text(
                    " /  ",
                    style: periodTextStyle(),
                  ),
                  Container(
                      padding: const EdgeInsets.all(0),
                      width: 20,
                      child: TextField(
                        maxLength: 2,
                        style: periodTextStyle(),
                        keyboardType: TextInputType.number,
                        controller: sMonth,
                        decoration:
                            inputDecoration(DateFormat('MM').format(realTime)),
                      )),
                  Text(
                    " /  ",
                    style: periodTextStyle(),
                  ),
                  Container(
                      padding: const EdgeInsets.all(0),
                      width: 50,
                      child: TextField(
                        maxLength: 2,
                        style: periodTextStyle(),
                        keyboardType: TextInputType.number,
                        controller: sDay,
                        decoration:
                            inputDecoration(DateFormat('dd').format(realTime)),
                      )),
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(48, -5),
              child: Row(
                children: [
                  Text(
                    "종료일",
                    style: periodTextStyle(),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.all(0),
                    width: 40,
                    child: TextField(
                      maxLength: 4,
                      style: periodTextStyle(),
                      keyboardType: TextInputType.number,
                      controller: eYear,
                      decoration:
                          inputDecoration(DateFormat('yyyy').format(realTime)),
                    ),
                  ),
                  Text(
                    " /  ",
                    style: periodTextStyle(),
                  ),
                  Container(
                      padding: const EdgeInsets.all(0),
                      width: 20,
                      child: TextField(
                        maxLength: 2,
                        style: periodTextStyle(),
                        keyboardType: TextInputType.number,
                        controller: eMonth,
                        decoration:
                            inputDecoration(DateFormat('MM').format(realTime)),
                      )),
                  Text(
                    " /  ",
                    style: periodTextStyle(),
                  ),
                  Container(
                      padding: const EdgeInsets.all(0),
                      width: 50,
                      child: TextField(
                        maxLength: 2,
                        style: periodTextStyle(),
                        keyboardType: TextInputType.number,
                        controller: eDay,
                        decoration:
                            inputDecoration(DateFormat('dd').format(realTime)),
                      )),
                ],
              ),
            ),
            Container(
              height: 38,
              width: 145,
              child: ElevatedButton(
                  onPressed: () {
                    if (sYear.text != "" &&
                        sMonth.text != "" &&
                        sDay.text != "" &&
                        eYear.text != "" &&
                        eMonth.text != "" &&
                        eDay.text != "") {
                      if (int.parse(sYear.text) * 10000 +
                              int.parse(sMonth.text) * 100 +
                              int.parse(sDay.text) >
                          int.parse(eYear.text) * 10000 +
                              int.parse(eMonth.text) * 100 +
                              int.parse(eDay.text)) {
                        String sy = sYear.text;
                        String sm = sMonth.text;
                        String sd = sDay.text;
                        sYear.text = eYear.text;
                        sMonth.text = eMonth.text;
                        sDay.text = eDay.text;
                        eYear.text = sy;
                        eMonth.text = sm;
                        eDay.text = sd;
                      }
                      changePeroid(_inititemList);
                      bookedCount = 0;
                      countbooked();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  child: Text(
                    "확인",
                    style: periodTextStyle(),
                  )),
            )
          ],
        ),
      ),
    );
  }

  TextStyle periodTextStyle() {
    return TextStyle(
        color: Color(0xff2772AC),
        fontFamily: "Noto_Sans_KR",
        fontWeight: FontWeight.w700,
        fontSize: 14);
  }

  TextStyle sortNotSelectedTextStyle() {
    return TextStyle(
        color: Color(0xffECF3FF),
        fontFamily: "Noto_Sans_KR",
        fontWeight: FontWeight.w700,
        fontSize: 14);
  }

  InputDecoration inputDecoration(String hintText) {
    return InputDecoration(
      counterText: "",
      contentPadding: EdgeInsets.all(0),
      hintText: hintText,
      hintStyle: TextStyle(color: Color(0xffD6D6D6), fontSize: 13.0),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      fillColor: Colors.transparent,
      filled: true,
    );
  }

  Widget _sortBottomSheet() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
      return Container(
          child: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Row(
            children: [
              SizedBox(width: 45),
              Text(
                "기간",
                style: periodTextStyle(),
              ),
              SizedBox(
                width: 30,
              ),
              GestureDetector(
                onTap: () {
                  setModalState(() {
                    _selected = 1;
                  });
                },
                child: Text(
                  "과거순      ",
                  style: _selected == 1
                      ? periodTextStyle()
                      : sortNotSelectedTextStyle(),
                ),
              ),
              Text(
                "/",
                style: periodTextStyle(),
              ),
              GestureDetector(
                onTap: () {
                  setModalState(() {
                    _selected = 0;
                  });
                },
                child: Text(
                  "      최신순",
                  style: _selected == 0
                      ? periodTextStyle()
                      : sortNotSelectedTextStyle(),
                ),
              )
            ],
          ),
          SizedBox(
            height: 22,
          ),
          Container(
            height: 38,
            width: 145,
            child: ElevatedButton(
              onPressed: () {
                changeSort(_itemList, _selected);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              child: Text(
                "확인",
                style: periodTextStyle(),
              ),
            ),
          )
        ],
      ));
    });
  }

  Future<void> showCustomBottomSheet(
      {required String title, required Widget content()}) {
    return showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
        ),
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: 250,
                color: Colors.transparent,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 44,
                      ),
                      Container(
                        width: 250,
                        height: 50,
                        margin: const EdgeInsets.only(left: 33),
                        padding: const EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          color: Color(0xffECF3FF),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4.0,
                              offset: Offset(0.5, 1.9),
                              color: Color(0xffbdc3c7),
                            )
                          ],
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            title = title == "조회기간" ? title : "예약 내역 정렬",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff2772AC),
                              fontFamily: "Noto_Sans_KR",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      content(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _sortNperiod({required String title, required Function() ontap}) {
    return GestureDetector(
      onTap: ontap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
            child: Image.asset(
              'assets/images/reservation_sort.png',
              width: 8,
              height: 8,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: "Noto_Sans_KR",
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listItem({required List<ReservationByUser> reservationInfo}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: ListView.builder(
            itemCount: reservationInfo.length,
            itemBuilder: (listcontext, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                height: 90,
                decoration: BoxDecoration(
                  color: reservationInfo[index].status == "booked" ||
                          reservationInfo[index].status == "deactivation"
                      ? Color(0xffECF3FF)
                      : Color(0xffbcbcbc),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 25,
                      decoration: BoxDecoration(
                        color: reservationInfo[index].status == "booked" ||
                                reservationInfo[index].status == "deactivation"
                            ? Color(0xff2099EA)
                            : Color(0xffa6a6a6),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    _imageByFloor(
                        floor: reservationInfo[index].floor,
                        status: reservationInfo[index].status),
                    Flexible(
                      child: SizedBox(
                        width: 30,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          reservationInfo[index].floor,
                          style: TextStyle(
                            color: reservationInfo[index].status == "booked" ||
                                    reservationInfo[index].status ==
                                        "deactivation"
                                ? Color(0xff2099EA)
                                : Color(0xffffffff),
                            fontSize: 14,
                            fontFamily: "Noto_Sans_KR",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          reservationInfo[index]
                              .realTime
                              .substring(0, 10)
                              .replaceAll('-', '. '),
                          style: TextStyle(
                            color: reservationInfo[index].status == "booked" ||
                                    reservationInfo[index].status ==
                                        "deactivation"
                                ? Color(0xff80BCFA)
                                : Color(0xffffffff),
                            fontSize: 11,
                            fontFamily: "Noto_Sans_KR",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: SizedBox(
                        width: 30,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${reservationInfo[index].time.substring(0, 5)} - ${int.parse(reservationInfo[index].time.substring(0, 2)) + 1}:00',
                          style: TextStyle(
                            color: reservationInfo[index].status == "booked" ||
                                    reservationInfo[index].status ==
                                        "deactivation"
                                ? Color(0xff2099EA)
                                : Color(0xffffffff),
                            fontSize: 14,
                            fontFamily: "Noto_Sans_KR",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          reservationInfo[index].status == "canceled"
                              ? "미인증"
                              : reservationInfo[index].status == "delete"
                                  ? "취소함"
                                  : reservationInfo[index].status == "booked"
                                      ? "인증 완료"
                                      : "",
                          style: TextStyle(
                              color: reservationInfo[index].status == "booked"
                                  ? Color(0xff7f8c8d)
                                  : Color(0xffFFF4B4),
                              fontSize: 9),
                        ),
                        // Text(reservationInfo[index].status),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget _imageByFloor({required String floor, required String status}) {
    String imagePath = "ari_3rd_floor";
    if (floor == "아리관 3층") {
      imagePath = "ari_3rd_floor";
    } else if (floor == "아리관 4층") {
      imagePath = "ari_4th_floor";
    } else if (floor == "수봉관 7층") {
      imagePath = "subong_7th_floor";
    } else {
      imagePath = "suri_1st_floor";
    }
    return ClipOval(
      child: Container(
        color: status == "booked" || status == "deactivation"
            ? Color(0xff80bcfa)
            : Color(0xffa6a6a6),
        width: 35,
        height: 35,
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/${imagePath}.png',
                width: 21,
                height: 21,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
