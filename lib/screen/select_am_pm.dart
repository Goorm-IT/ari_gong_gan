import 'package:ari_gong_gan/model/reservation.dart';
import 'package:ari_gong_gan/model/reservation_time.dart';
import 'package:ari_gong_gan/model/reservation_time_list.dart';
import 'package:ari_gong_gan/model/resevation_all.dart';
import 'package:ari_gong_gan/provider/reservation_all_provider.dart';
import 'package:ari_gong_gan/screen/place_select_one.dart';
import 'package:ari_gong_gan/widget/custom_radio_circle_button.dart';
import 'package:ari_gong_gan/widget/possible_or_not.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:ari_gong_gan/widget/custom_appbar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:provider/provider.dart';

class SelectAMPM extends StatefulWidget {
  const SelectAMPM({Key? key}) : super(key: key);

  @override
  State<SelectAMPM> createState() => _SelectAMPMState();
}

class _SelectAMPMState extends State<SelectAMPM>
    with SingleTickerProviderStateMixin {
  bool _isPressedAM = false;
  bool _isPressedPM = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isPressedAM || _isPressedPM) {
          setState(() {
            _isPressedAM = false;
            _isPressedPM = false;
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: customAppbar(context),
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color(0xff2099e9),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 33.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 45,
                    ),
                    Text.rich(
                      TextSpan(
                        text: '시간',
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
                    SizedBox(
                      height: 45,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        CustomRadioCircleButton(
                          isSelected: (bool isSelected) {
                            setState(
                              () {
                                _isPressedAM = isSelected;
                                if (_isPressedPM == true) {
                                  _isPressedPM = false;
                                }
                              },
                            );
                          },
                          isPressed: _isPressedAM,
                          title: "오전",
                          size: 105.0,
                          pressedColor: Color(0xff2772ac),
                          shadowColor: Color.fromARGB(223, 59, 59, 59),
                          onTap: () {
                            _animationController.reverse();
                            reservationInfo.time = "";
                            setState(() {
                              for (ReservationTime list in tmpAM) {
                                list.isPressed = false;
                              }
                              for (ReservationTime list in tmpPM) {
                                list.isPressed = false;
                              }
                            });
                          },
                          isBooked: 'activate',
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustomRadioCircleButton(
                          isSelected: (bool isSelected) {
                            setState(
                              () {
                                _isPressedPM = isSelected;
                                if (_isPressedAM == true) {
                                  _isPressedAM = false;
                                }
                              },
                            );
                          },
                          isPressed: _isPressedPM,
                          title: "오후",
                          size: 105.0,
                          pressedColor: Color(0xff2772ac),
                          shadowColor: Color.fromARGB(223, 59, 59, 59),
                          onTap: () {
                            _animationController.reverse();
                            reservationInfo.time = "";
                            setState(() {
                              for (ReservationTime list in tmpAM) {
                                list.isPressed = false;
                              }
                              for (ReservationTime list in tmpPM) {
                                list.isPressed = false;
                              }
                            });
                          },
                          isBooked: 'activate',
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                height: 300,
                width: MediaQuery.of(context).size.width,
                transform: Matrix4.translationValues(
                    0, _isPressedAM || _isPressedPM ? 0 : 300, 0),
                child: CustomBottomSheet(
                  isPressedAM: _isPressedAM,
                  isPressedPM: _isPressedPM,
                  animationController: _animationController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomBottomSheet extends StatefulWidget {
  bool isPressedAM;
  bool isPressedPM;
  AnimationController animationController;
  CustomBottomSheet({
    required this.isPressedAM,
    required this.isPressedPM,
    required this.animationController,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet>
    with SingleTickerProviderStateMixin {
  bool isPressed = false;
  Function()? selectFunction = null;
  Color selectColor = Colors.grey;
  List<ReservationAll> _placeList = [];

  @override
  void initState() {
    super.initState();
    widget.animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    if (reservationInfo.time == "") {
      selectFunction = null;
      selectColor = Colors.grey;
    } else {
      selectFunction = () {
        List<ReservationAll> _list =
            context.read<RevervationAllProvider>().revervationAll;
        _placeList.clear();
        for (int i = 0; i < _list.length; i++) {
          if (_list[i].time == reservationInfo.time) {
            _placeList.add(_list[i]);
          }
        }

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlaceSelectOne(
                      placeListFilteredBytime: _placeList,
                    )));
      };
      selectColor = Color(0xff4988e1);
    }
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffD1E9FF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 35, top: 32),
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
            height: 44,
          ),
          Container(
            margin: const EdgeInsets.only(left: 35),
            child: SingleChildScrollView(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.isPressedAM
                    ? tmpAM.asMap().entries.map(
                        (e) {
                          ReservationTime val = e.value;
                          int index = e.key;
                          return timeButton(
                            reservationTimeInfo: val,
                            isAM: true,
                            idx: index,
                          );
                        },
                      ).toList()
                    : tmpPM.asMap().entries.map(
                        (e) {
                          ReservationTime val = e.value;
                          int index = e.key;
                          return timeButton(
                            reservationTimeInfo: val,
                            isAM: false,
                            idx: index,
                          );
                        },
                      ).toList(),
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Container(
            child: FadeTransition(
              opacity: widget.animationController,
              child: Text(
                "시간을 선택해 주세요",
                style: TextStyle(color: Colors.red, fontSize: 12.0),
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: selectFunction,
              // onPressed: reservationInfo.time == ""
              //     ? null
              //     : () {
              //         if (reservationInfo.time != "") {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => PlaceSelectOne()));
              //         } else {
              //           if (widget.animationController.status ==
              //               AnimationStatus.completed) {
              //             widget.animationController.reverse();
              //             Future.delayed(const Duration(milliseconds: 350), () {
              //               widget.animationController.forward();
              //             });
              //           } else {
              //             widget.animationController.forward();
              //           }
              //         }
              //       },
              child: Text(
                "선택완료",
                style: TextStyle(color: selectColor, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.grey,
                primary: Colors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget timeButton(
      {required ReservationTime reservationTimeInfo,
      required bool isAM,
      required int idx}) {
    // 시간 바꿔야함 임의로 해놓은것.

    Color textColor = Color(0xff4888E0);
    Color buttonColor = Colors.white;
    Color insetColor = Color.fromARGB(223, 178, 178, 178);
    if (isAM) {
      textColor = tmpAM[idx].isPressed ? Colors.white : Color(0xff2772ac);
      buttonColor = !tmpAM[idx].isPressed ? Colors.white : Color(0xff4887e1);
      insetColor = !tmpAM[idx].isPressed
          ? Color.fromARGB(223, 178, 178, 178)
          : Color.fromARGB(223, 70, 70, 70);
    } else {
      textColor = tmpPM[idx].isPressed ? Colors.white : Color(0xff2772ac);
      buttonColor = !tmpPM[idx].isPressed ? Colors.white : Color(0xff4887e1);
      insetColor = !tmpPM[idx].isPressed
          ? Color.fromARGB(223, 178, 178, 178)
          : Color.fromARGB(223, 70, 70, 70);
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.animationController.reverse();
          reservationInfo.time = reservationTimeInfo.time + ":00";
          if (isAM) {
            for (int i = 0; i < tmpAM.length; i++) {
              if (i != idx) {
                tmpAM[i].isPressed = false;
              }
            }
            tmpAM[idx].isPressed = !tmpAM[idx].isPressed;
            if (tmpAM[idx].isPressed == false) {
              reservationInfo.time = "";
            }
          } else {
            for (int i = 0; i < tmpPM.length; i++) {
              if (i != idx) {
                tmpPM[i].isPressed = false;
              }
            }
            tmpPM[idx].isPressed = !tmpPM[idx].isPressed;
            if (tmpPM[idx].isPressed == false) {
              reservationInfo.time = "";
            }
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        width: 86,
        height: 57,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              offset: Offset(0.5, 1.9),
              color: insetColor,
              inset: isAM ? tmpAM[idx].isPressed : tmpPM[idx].isPressed,
            )
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: buttonColor,
        ),
        child: Center(
          child: Text(
            reservationTimeInfo.time,
            style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFamily: "Noto_Sans_KR"),
          ),
        ),
      ),
    );
  }
}
