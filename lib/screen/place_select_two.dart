import 'package:ari_gong_gan/const/colors.dart';
import 'package:ari_gong_gan/http/ari_server.dart';
import 'package:ari_gong_gan/model/reservation.dart';
import 'package:ari_gong_gan/model/reservation_place.dart';
import 'package:ari_gong_gan/model/resevation_all.dart';
import 'package:ari_gong_gan/screen/home_screen.dart';
import 'package:ari_gong_gan/screen/reservation_complete.dart';
import 'package:ari_gong_gan/widget/bottom_to_top_fade.dart';
import 'package:ari_gong_gan/widget/custom_appbar.dart';
import 'package:ari_gong_gan/widget/custom_radio_circle_button.dart';
import 'package:ari_gong_gan/widget/custom_showdialog.dart';
import 'package:ari_gong_gan/widget/possible_or_not.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class PlaceSelectTwo extends StatefulWidget {
  final String title;
  final List<ReservationPlace> rooms;
  final List<ReservationAll> placeListFilteredByfloor;
  const PlaceSelectTwo(
      {required this.title,
      required this.rooms,
      required this.placeListFilteredByfloor,
      Key? key})
      : super(key: key);

  @override
  State<PlaceSelectTwo> createState() => _PlaceSelectTwoState();
}

class _PlaceSelectTwoState extends State<PlaceSelectTwo> {
  List<bool> _isPressed = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.rooms.length; i++) {
      _isPressed.add(widget.rooms[i].isPressed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context, true),
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
                  height: 75,
                  child: Text.rich(
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
                          text: DateFormat('MMM. dd. yyyy')
                              .format(DateTime.now()),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 68),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 30,
                      ),
                      child: BottomToUpFade(
                        height: 40,
                        delayTime: 1,
                        initAlignment: Alignment(0.0, 1.0),
                        changeAlignment: Alignment(0.0, -1.0),
                        insideWidget: Text(
                          widget.title,
                          style: TextStyle(
                            color: Color(0xff2772AC),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 0,
                      color: Color(0xff2772AC),
                      thickness: 3,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15, left: 0.5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isPossibleColor(true),
                          SizedBox(
                            width: 20,
                          ),
                          isPossibleColor(false),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: GridView.builder(
                          padding: const EdgeInsets.all(5),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            mainAxisSpacing: 35,
                            crossAxisSpacing: 15,
                          ),
                          itemCount: widget.rooms.length,
                          itemBuilder: (gridContext, index) {
                            return BottomToUpFade(
                              height: 150,
                              delayTime: 350 + index * 50,
                              initAlignment:
                                  Alignment(index % 2 == 0 ? -1.0 : 1.0, 1.0),
                              changeAlignment:
                                  Alignment(index % 2 == 0 ? -1.0 : 1.0, -1.0),
                              insideWidget: Container(
                                margin:
                                    const EdgeInsets.only(left: 2, right: 2),
                                child: CustomRadioCircleButton(
                                    isPressed: _isPressed[index],
                                    isSelected: (bool isSelected) {
                                      setState(() {
                                        for (int i = 0;
                                            i < widget.rooms.length;
                                            i++) {
                                          if (i == index) {
                                            _isPressed[i] = isSelected;
                                          } else {
                                            if (isSelected == true) {
                                              _isPressed[i] = !isSelected;
                                            }
                                          }
                                        }
                                      });
                                    },
                                    size: 100,
                                    title: widget.rooms[index].place,
                                    isBooked: widget
                                        .placeListFilteredByfloor[index]
                                        .isBooked,
                                    pressedColor: Color(0xff4888E0),
                                    shadowColor:
                                        Color.fromARGB(223, 150, 150, 150),
                                    onTap: () {
                                      setState(() {
                                        reservationInfo.name =
                                            widget.rooms[index].place;
                                      });
                                      if (_isPressed[index]) {
                                        reservationInfo.name = "";
                                      }
                                    }),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 190,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: reservationInfo.name == ""
                            ? null
                            : () async {
                                var ariServer = AriServer();
                                int result = await ariServer.revervation();
                                late String tmpFloor, tmpName, tmpTime;
                                setState(() {
                                  tmpFloor = reservationInfo.floor;
                                  tmpName = reservationInfo.name;
                                  tmpTime = reservationInfo.time;
                                  reservationInfo.floor = "";
                                  reservationInfo.name = "";
                                  reservationInfo.time = "";
                                  reservationInfo.userNum = "";
                                });
                                if (result == 200) {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          child: ReservationComplete(
                                            floor: tmpFloor,
                                            name: tmpName,
                                            time: tmpTime,
                                          )));
                                } else {
                                  customShowDiaLog(
                                    context: context,
                                    title: diaLogTitle(),
                                    content: diaLogContent(),
                                    action: [diaLogAction()],
                                    isBackButton: false,
                                  );
                                }
                              },
                        child: Text(
                          "예약하기",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xff80bcfa),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget diaLogTitle() {
    return Container(
      child: Center(
        child: Text(
          "예약 실패",
          style: TextStyle(
              color: PRIMARY_COLOR_DEEP,
              fontSize: 18,
              fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget diaLogContent() {
    return Container(
        height: 50.0,
        child: Column(
          children: [
            Text(
              "잠시후에 다시 시도해주세요",
              style: TextStyle(
                color: PRIMARY_COLOR_DEEP,
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ));
  }

  Widget diaLogAction() {
    return Row(
      children: [
        Flexible(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(18.0),
              bottomRight: Radius.circular(18.0),
            ),
            child: Material(
              color: Color(0xffF9E769),
              child: InkWell(
                onTap: () {
                  setState(() {
                    reservationInfo.floor = "";
                    reservationInfo.name = "";
                    reservationInfo.time = "";
                    reservationInfo.userNum = "";
                  });

                  Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade, child: HomeScreen()),
                      (route) => false);
                },
                child: Container(
                  height: 53,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(18.0),
                      bottomLeft: Radius.circular(18.0),
                    ),
                  ),
                  child: Container(
                    child: Text(
                      "메인으로",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
