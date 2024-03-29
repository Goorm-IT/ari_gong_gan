import 'dart:async';
import 'package:ari_gong_gan/const/user_info.dart';
import 'package:ari_gong_gan/controller/ble_location_state_controller.dart';
import 'package:ari_gong_gan/controller/requirement_state_controller.dart';
import 'package:ari_gong_gan/http/ari_server.dart';
import 'package:ari_gong_gan/model/today_reservation_list.dart';
import 'package:ari_gong_gan/provider/today_reservation_provider.dart';
import 'package:ari_gong_gan/widget/custom_gradient_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

typedef IsSetting = void Function(double);

class BookCardDivied extends StatefulWidget {
  int index;
  IsSetting isSetting;
  BookCardDivied({required this.index, required this.isSetting, super.key});

  @override
  State<BookCardDivied> createState() => _BookCardDiviedState();
}

class _BookCardDiviedState extends State<BookCardDivied> {
  StreamSubscription<RangingResult>? _streamRanging;
  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];
  AriUser userInfo = GetIt.I<AriUser>();
  final controller = Get.find<RequirementStateController>();
  DateTime realTime = GetIt.I<DateTime>();
  bool buttonState = false;
  double _settingErrorOpacitiy = 0.0;
  final _bleLoctionStateController = Get.find<BLELoctionStateController>();
  List<TodayReservation> _list = [];

  String bottomMessageText = "인증 가능 시간이 아닙니다";
  Color bottomMessageTextColor = Color(0xffe8cb1e);
  Color bottomMessageBackgroundColor = Color(0xfffff4b4);
  bool isBeaconSearch = false;

  late TodayReservationProvider _todayReservationProvider;
  bool _isScanning = false;
  Map beaconRoom = {
    '아리관 3층': 62908,
    '아리관 4층': 62909,
    '수봉관 7층': 62895,
    '수리관 1층': 62902
  };

  startScanBeacon() async {
    await flutterBeacon.initializeScanning;
    if (controller.scanningStatus != true) {
      return;
    }

    if (mounted) {
      setState(() {
        _settingErrorOpacitiy = 0.0;
        widget.isSetting(0.0);
      });
    }

    final regions = <Region>[
      Region(
        identifier: 'MBeacon',
        proximityUUID: '74278BDA-B644-4520-8F0C-720EAF059935',
      ),
      Region(
        identifier: 'BeaconType2',
        proximityUUID: '6a84c716-0f2a-1ce9-f210-6a63bd873dd9',
      ),
    ];

    if (_streamRanging != null) {
      if (_streamRanging!.isPaused) {
        _streamRanging?.resume();
        return;
      }
    }
    controller.startScanning();
    _streamRanging =
        flutterBeacon.ranging(regions).listen((RangingResult result) {
      if (mounted) {
        setState(() {
          _regionBeacons[result.region] = result.beacons;
          _beacons.clear();
          _regionBeacons.values.forEach((list) {
            _beacons.addAll(list);
          });
          _beacons.sort(_compareParameters);
          compareBeaconRoom();
        });
      }
    });

    Future.delayed(Duration(seconds: 30)).then((value) {
      if (mounted) {
        setState(() {
          if (controller.scanningStatus == true) {
            setState(() {
              _isScanning = false;
            });
            showToast(msg: "인증에 실패했습니다. 잠시후 다시 시도해주세요.");
            stopScanning();
          }
        });
      }
    });

    return;
  }

  int _compareParameters(Beacon a, Beacon b) {
    int compare = a.proximityUUID.compareTo(b.proximityUUID);

    if (compare == 0) {
      compare = a.major.compareTo(b.major);
    }

    if (compare == 0) {
      compare = a.minor.compareTo(b.minor);
    }

    return compare;
  }

  compareBeaconRoom() async {
    if (_beacons.isNotEmpty) {
      for (int i = 0; i < _beacons.length; i++) {
        if (_beacons[i].minor == beaconRoom[_list[widget.index].floor]) {
          stopScanning();
          AriServer ariServer = AriServer();
          try {
            int returnstatus = await ariServer.booked(
                floor: _list[widget.index].floor,
                name: _list[widget.index].name,
                time: _list[widget.index].time);
            if (returnstatus == 200) {
              showToast(msg: "예약 인증이 완료되었습니다.");
              setState(() {
                buttonState = false;
                bottomMessageText = "예약 인증이 완료되었습니다!!";
                bottomMessageTextColor = Color(0xff303952);
                bottomMessageBackgroundColor = Color(0xff778beb);
              });
            } else {
              showToast(msg: "인증에 실패했습니다. 잠시후 다시 시도해주세요.(1)");
              if (mounted) {
                setState(() {
                  _isScanning = false;
                });
              }
              return;
            }
          } catch (e) {
            showToast(msg: "인증에 실패했습니다. 잠시후 다시 시도해주세요.(2)");
            if (mounted) {
              setState(() {
                _isScanning = false;
              });
            }
            return;
          }
          if (mounted) {
            setState(() {
              _isScanning = false;
            });
          }

          await _todayReservationProvider.getTodayReservation();
        }
      }
    }

    return;
  }

  pauseScanBeacon() async {
    _streamRanging!.cancel();
    if (mounted) {
      if (_beacons.isNotEmpty) {
        setState(() {
          _beacons.clear();
        });
      }
    }
  }

  stopScanning() {
    controller.pauseScanning();
    pauseScanBeacon();
    if (mounted) {
      setState(() {
        _isScanning = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _list = context
        .read<TodayReservationProvider>()
        .todayReservation
        .where((TodayReservation element) {
      return element.resStatus != "delete";
    }).toList();
    _list.sort((a, b) => a.time.compareTo(b.time));
    if (_list[widget.index].resStatus == 'booked') {
      bottomMessageText = "예약 인증이 완료되었습니다!!";
      bottomMessageTextColor = Color(0xff303952);
      bottomMessageBackgroundColor = Color(0xff778beb);
    }
    if (_list[widget.index].resStatus == 'canceled') {
      bottomMessageText = "인증을 하지 않아 하루 동안 비활성화되었습니다";
      bottomMessageTextColor = Color(0xffd63031);
      bottomMessageBackgroundColor = Color(0xfff78fb3);
    }

    if (_list[widget.index].resStatus == 'prebooked') {
      buttonState = true;
      bottomMessageText = "예약 인증이 가능합니다!";
    }
  }

  @override
  void dispose() {
    _streamRanging?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _todayReservationProvider =
        Provider.of<TodayReservationProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: const EdgeInsets.only(left: 30),
            width: 250,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xffD1E9FF),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4.0,
                  offset: Offset(0.5, 1.9),
                  color: Color(0xffbdc3c7),
                )
              ],
            ),
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 20),
              child: Text.rich(
                TextSpan(
                  text: userInfo.name,
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff2772AC),
                      fontWeight: FontWeight.w600),
                  children: [
                    TextSpan(
                      text: '님의 예약카드',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            )),
        SizedBox(
          height: 25,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  infoItem(
                    title: "날짜",
                    content: DateFormat('yyyy. MM. dd').format(realTime),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  infoItem(
                    title: "시간",
                    content:
                        '${_list[widget.index].time.substring(0, 5)} - ${int.parse(_list[widget.index].time.substring(0, 2)) + 1}:00',
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  infoItem(
                    title: "장소",
                    content:
                        '${_list[widget.index].floor} ${_list[widget.index].name}',
                  ),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 1,
              ),
              Column(
                children: [
                  buttonState //요기
                      ? Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(60)),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    offset: Offset(0.5, 1.9),
                                    color: Color(0xffbdc3c7),
                                  )
                                ],
                              ),
                              width: 60,
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/beaconSearch.png',
                                  width: 38,
                                  height: 38,
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(60)),
                                splashColor: Colors.grey.withOpacity(0.5),
                                onTap: () async {
                                  await _bleLoctionStateController
                                      .setLocationState();

                                  if (!_bleLoctionStateController
                                          .getBluetoothState ||
                                      !_bleLoctionStateController
                                          .getLocationState) {
                                    widget.isSetting(1.0);
                                    return;
                                  }

                                  if (mounted) {
                                    setState(() {
                                      _isScanning = true;
                                    });
                                  }
                                  controller.startScanning();
                                  startScanBeacon();
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                            ),
                            _isScanning == true
                                ? GestureDetector(
                                    onTap: () {
                                      stopScanning();
                                      showToast(msg: '예약인증을 취소했습니다.');
                                    },
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.7),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(60)),
                                      ),
                                      child: Container(
                                          width: 40,
                                          height: 40,
                                          margin: const EdgeInsets.all(13),
                                          child: CustomCircularProgress(
                                            size: 40,
                                          )),
                                    ),
                                  )
                                : Container()
                          ],
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                          ),
                          width: 60,
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/beaconSearch.png',
                              width: 38,
                              height: 38,
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "예약인증",
                    style: TextStyle(color: Color(0xff2772AC), fontSize: 12),
                  )
                ],
              ),
              Expanded(
                child: SizedBox(
                  width: 60,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                color: bottomMessageBackgroundColor,
              ),
              child: Center(
                child: Text(
                  bottomMessageText,
                  style: TextStyle(
                    color: bottomMessageTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget infoItem({required String title, required String content}) {
    return Container(
      width: MediaQuery.of(context).size.width - 200,
      margin: const EdgeInsets.only(left: 50),
      child: Text.rich(
        TextSpan(
          text: "$title     ",
          style: textStyle(),
          children: [
            TextSpan(
              text: content,
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  TextStyle textStyle() {
    return TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xff2772AC));
  }

  showToast({required String msg}) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      fontSize: 15,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
    );
  }
}
