import 'package:ari_gong_gan/const/colors.dart';
import 'package:ari_gong_gan/model/reservation.dart';
import 'package:ari_gong_gan/model/reservation_place.dart';
import 'package:ari_gong_gan/model/reservation_place_list.dart';
import 'package:ari_gong_gan/model/reservation_all.dart';
import 'package:ari_gong_gan/screen/place_select_two.dart';
import 'package:ari_gong_gan/widget/bottom_to_top_fade.dart';
import 'package:ari_gong_gan/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class PlaceSelectOne extends StatefulWidget {
  List<ReservationAll> placeListFilteredBytime;
  PlaceSelectOne({required this.placeListFilteredBytime, Key? key})
      : super(key: key);

  @override
  State<PlaceSelectOne> createState() => _PlaceSelectOneState();
}

class _PlaceSelectOneState extends State<PlaceSelectOne> {
  List<ReservationAll> _placeList = [];
  DateTime realTime = GetIt.I<DateTime>();
  Map<String, int> _remainList = {
    "아리관 3층": 0,
    "아리관 4층": 0,
    "수봉관 7층": 0,
    "수리관 1층": 0,
  };
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.placeListFilteredBytime.length; i++) {
      if (widget.placeListFilteredBytime[i].isBooked == "activate") {
        _remainList[widget.placeListFilteredBytime[i].floor] =
            _remainList[widget.placeListFilteredBytime[i].floor]! + 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context, true, true),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Color(0xff2099e9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 45),
                Container(
                  margin: const EdgeInsets.only(left: 33),
                  child: BottomToUpFade(
                    height: 75,
                    delayTime: 1,
                    initAlignment: Alignment(-1.0, 1.0),
                    changeAlignment: Alignment(-1.0, -1.0),
                    insideWidget: Text.rich(
                      TextSpan(
                        text: '장소',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                            text: '을 선택해주세요\n',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                          TextSpan(
                            text: DateFormat('MMM. dd. yyyy').format(realTime),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height - 215,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(33),
                  topRight: Radius.circular(33),
                ),
                color: Color(0xffECF3FF),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 25, left: 62),
                    child: Text(
                      "장소 LIST",
                      style: TextStyle(
                        color: Color(0xff2772AC),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          BottomToUpFade(
                            height: 70,
                            delayTime: 350,
                            initAlignment: Alignment(-1.0, 0.0),
                            changeAlignment: Alignment(0.0, 0.0),
                            insideWidget: placeCard(
                              title: '아리관 3층',
                              imagePath: "ari_3rd_floor",
                              rooms: ari_3rd_floor,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          BottomToUpFade(
                            height: 70,
                            delayTime: 400,
                            initAlignment: Alignment(-1.0, 0.0),
                            changeAlignment: Alignment(0.0, 0.0),
                            insideWidget: placeCard(
                              title: '아리관 4층',
                              imagePath: "ari_4th_floor",
                              rooms: ari_4th_floor,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          BottomToUpFade(
                            height: 70,
                            delayTime: 450,
                            initAlignment: Alignment(-1.0, 0.0),
                            changeAlignment: Alignment(0.0, 0.0),
                            insideWidget: placeCard(
                              title: '수봉관 7층',
                              imagePath: "subong_7th_floor",
                              rooms: subong_7th_floor,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          BottomToUpFade(
                            height: 70,
                            delayTime: 500,
                            initAlignment: Alignment(-1.0, 0.0),
                            changeAlignment: Alignment(0.0, 0.0),
                            insideWidget: placeCard(
                              title: '수리관 1층',
                              imagePath: "suri_1st_floor",
                              rooms: suri_1st_floor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget placeCard(
      {required String title,
      required String imagePath,
      required List<ReservationPlace> rooms}) {
    return Container(
      width: 280,
      height: 70,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            reservationInfo.name = "";
          });

          reservationInfo.floor = title;
          _placeList.clear();
          for (int i = 0; i < widget.placeListFilteredBytime.length; i++) {
            if (reservationInfo.floor ==
                widget.placeListFilteredBytime[i].floor) {
              _placeList.add(widget.placeListFilteredBytime[i]);
            }
          }
          Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: PlaceSelectTwo(
                  title: title,
                  rooms: rooms,
                  placeListFilteredByfloor: _placeList,
                ),
              ));
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey,
          backgroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
            ),
            ClipOval(
              child: Container(
                color: Color(0xff80bcfa),
                width: 40,
                height: 40,
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
            ),
            SizedBox(
              width: 11,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xff4888E0),
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '잔여석 ${_remainList[title].toString()}',
                  style: TextStyle(fontSize: 10, color: Color(0xff2099EA)),
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.navigate_next,
              color: PRIMARY_COLOR_DEEP,
              size: 30.0,
            ),
            SizedBox(
              width: 22,
            ),
          ],
        ),
      ),
    );
  }
}
