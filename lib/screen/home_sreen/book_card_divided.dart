import 'dart:async';
import 'package:ari_gong_gan/const/colors.dart';
import 'package:ari_gong_gan/const/user_info.dart';
import 'package:ari_gong_gan/controller/requirement_state_controller.dart';
import 'package:ari_gong_gan/http/ari_server.dart';
import 'package:ari_gong_gan/model/today_reservation_list.dart';
import 'package:ari_gong_gan/provider/reservation_by_user_provider.dart';
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
  TodayReservation reservationInfo;
  IsSetting isSetting;
  BookCardDivied(
      {required this.reservationInfo, required this.isSetting, super.key});

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

  double _settingErrorOpacitiy = 0.0;
  double _searchResultOpacitiy = 1.0;
  String _searchResultMessage = "인증 가능 시간이 아닙니다";
  int _searchResultMessageStatus = 0;
  bool isBeaconSearch = false;
  late ReservationByUserProvider _reservationByUserProvider;
  bool _isScanning = false;
  Map beaconRoom = {
    '아리관 3층': 62908,
    '아리관 4층': 62909,
    '수봉관 7층': 62895,
    '수리관 1층': 62902
  };

  startScanBeacon() async {
    await flutterBeacon.initializeScanning;

    // if (!controller.authorizationStatusOk ||
    //     !controller.locationServiceEnabled ||
    //     !controller.bluetoothEnabled) {
    //   if (_settingErrorOpacitiy == 1.0) {
    //     setState(() {
    //       widget.isSetting(0.0);
    //       _settingErrorOpacitiy = 0.0;
    //       Future.delayed(Duration(milliseconds: 150))
    //           .then((value) => setState(() {
    //                 _settingErrorOpacitiy = 1.0;
    //                  widget.isSetting(1.0);
    //               }));
    //     });
    //   } else {
    //     setState(() {
    //       _settingErrorOpacitiy = 1.0;
    //        widget.isSetting(1.0);
    //     });
    //   }

    //   return;
    // }

    if (controller.scanningStatus != true) {
      return;
    }
    if (!settingbuttonCheck()) {
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
      print(result);
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
          }
          stopScanning();
          showToast(msg: "1인증에 실패했습니다. 잠시후 다시 시도해주세요.");
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
    print("비교 부분");
    if (_beacons.isNotEmpty) {
      for (int i = 0; i < _beacons.length; i++) {
        if (_beacons[i].minor == beaconRoom[widget.reservationInfo.floor]) {
          stopScanning();
          AriServer ariServer = AriServer();
          try {
            int returnstatus = await ariServer.booked(
                floor: widget.reservationInfo.floor,
                name: widget.reservationInfo.name,
                time: widget.reservationInfo.time);
            if (returnstatus == 200) {
              showToast(msg: "예약 인증이 완료되었습니다.");
            } else {
              showToast(msg: "2인증에 실패했습니다. 잠시후 다시 시도해주세요.");
              if (mounted) {
                setState(() {
                  _isScanning = false;
                });
              }
              return;
            }
          } catch (e) {
            showToast(msg: "3인증에 실패했습니다. 잠시후 다시 시도해주세요.");
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
          await _reservationByUserProvider.getReservationByUser();
          if (mounted) {
            setState(() {});
          }
        }
      }
    }

    return;
  }

  pauseScanBeacon() async {
    _streamRanging!.cancel();
    // _streamRanging?.pause();
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

    if (widget.reservationInfo.resStatus == 'prebooked') {
      _searchResultMessage = "예약 인증이 가능합니다!";
    }
  }

  @override
  void dispose() {
    _streamRanging?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reservationInfo.resStatus == 'booked') {
      _searchResultMessage = "예약 인증이 완료되었습니다.";
    }
    _reservationByUserProvider =
        Provider.of<ReservationByUserProvider>(context, listen: false);
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
                        '${widget.reservationInfo.time.substring(0, 5)} - ${int.parse(widget.reservationInfo.time.substring(0, 2)) + 1}:00',
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  infoItem(
                    title: "장소",
                    content:
                        '${widget.reservationInfo.floor} ${widget.reservationInfo.name}',
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
                  widget.reservationInfo.resStatus == 'prebooked' //요기
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
                                  if (!settingbuttonCheck()) {
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
        Center(
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: _searchResultOpacitiy,
            child: Container(
              width: 190,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                color: Color(0xfffff4b4),
              ),
              child: Center(
                child: Text(
                  _searchResultMessage,
                  style: TextStyle(
                    color: Color(0xffe8cb1e),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  bool settingbuttonCheck() {
    if (!controller.authorizationStatusOk ||
        !controller.locationServiceEnabled ||
        !controller.bluetoothEnabled) {
      if (_settingErrorOpacitiy == 1.0) {
        if (mounted) {
          setState(() {
            _settingErrorOpacitiy = 0.0;
            widget.isSetting(0.0);
            Future.delayed(Duration(milliseconds: 200)).then((value) {
              return setState(() {
                _settingErrorOpacitiy = 1.0;
                widget.isSetting(1.0);
              });
            });
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _settingErrorOpacitiy = 1.0;
            widget.isSetting(1.0);
          });
        }
      }
      return false;
    }

    if (mounted) {
      setState(() {
        _settingErrorOpacitiy = 0.0;
        widget.isSetting(0.0);
      });
    }
    return true;
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
