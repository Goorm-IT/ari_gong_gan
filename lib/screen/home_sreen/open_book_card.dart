import 'dart:async';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:ari_gong_gan/const/colors.dart';
import 'package:ari_gong_gan/controller/requirement_state_controller.dart';
import 'package:ari_gong_gan/model/today_reservation_list.dart';
import 'package:ari_gong_gan/provider/today_reservation_provider.dart';
import 'package:ari_gong_gan/screen/home_sreen/book_card_divided.dart';
import 'package:ari_gong_gan/screen/home_sreen/empty_book_card.dart';
import 'package:ari_gong_gan/widget/custom_icon_button.dart';
import 'package:ari_gong_gan/widget/custom_rotate_refresh.dart';
import 'package:ari_gong_gan/widget/custom_showdialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../controller/ble_location_state_controller.dart';

class OpenBookCard extends StatefulWidget {
  const OpenBookCard({super.key});

  @override
  State<OpenBookCard> createState() => _OpenBookCardState();
}

class _OpenBookCardState extends State<OpenBookCard>
    with WidgetsBindingObserver {
  final controller = Get.find<RequirementStateController>();

  StreamSubscription<RangingResult>? _streamRanging;
  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];
  StreamSubscription<BluetoothState>? _streamBluetooth;
  int buttonStatus = 0;
  double _settingErrorOpacitiy = 0.0;
  final _bleLoctionStateController = Get.find<BLELoctionStateController>();
  bool isBeaconSearch = false;
  final flutterReactiveBle = FlutterReactiveBle();

  List<TodayReservation> _list = [];

  final PageController _pageController = PageController(initialPage: 0);

  // listeningState() async {
  //   print('Listening to bluetooth state');
  //   _streamBluetooth = flutterBeacon
  //       .bluetoothStateChanged()
  //       .listen((BluetoothState state) async {
  //     print('state: $state');
  //     controller.updateBluetoothState(state);
  //     // await checkAllRequirements();
  //   });
  // }

  // checkAllRequirements() async {
  //   final bluetoothState = await flutterBeacon.bluetoothState;
  //   controller.updateBluetoothState(bluetoothState);
  //   print('BLUETOOTH $bluetoothState');

  //   final authorizationStatus = await flutterBeacon.authorizationStatus;
  //   controller.updateAuthorizationStatus(authorizationStatus);
  //   print('AUTHORIZATION $authorizationStatus');

  //   final locationServiceEnabled =
  //       await flutterBeacon.checkLocationServicesIfEnabled;
  //   controller.updateLocationService(locationServiceEnabled);
  //   print('LOCATION SERVICE $locationServiceEnabled');

  //   // if (controller.bluetoothEnabled &&
  //   //     controller.authorizationStatusOk &&
  //   //     controller.locationServiceEnabled) {
  //   //   print('STATE READY');
  //   //   if (isBeaconSearch == true) {
  //   //     print('SCANNING');
  //   //     controller.startScanning();
  //   //   } else {
  //   //     print('STOPScannig');
  //   //     controller.pauseScanning();
  //   //   }
  //   // } else {
  //   //   print('STATE NOT READY');
  //   //   controller.pauseScanning();
  //   // }
  // }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    flutterReactiveBle.statusStream.listen((status) {
      if (status.toString() == "BleStatus.ready") {
        _bleLoctionStateController.setBluetoothState(true);
      } else {
        _bleLoctionStateController.setBluetoothState(false);
      }
    });

    _list = context
        .read<TodayReservationProvider>()
        .todayReservation
        .where((TodayReservation element) {
      return element.resStatus != "delete";
    }).toList();
    // listeningState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('AppLifecycleState = $state');
    if (state == AppLifecycleState.resumed) {
      if (_streamBluetooth != null) {
        if (_streamBluetooth!.isPaused) {
          _streamBluetooth?.resume();
        }
      }
      // await checkAllRequirements();
    } else if (state == AppLifecycleState.paused) {
      _streamBluetooth?.pause();
    }
  }

  @override
  void dispose() {
    _streamRanging?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_list.isEmpty) {
      return EmptyBookCard();
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          color: Colors.white,
        ),
        height: 290,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              height: 37,
              margin: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  settingCheck(),
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
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _settingErrorOpacitiy,
              child: Container(
                height: 15,
                color: PRIMARY_COLOR_DEEP,
                child: Center(
                  child: Text(
                    "상단의 설정버튼을 확인해주세요",
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              height: 200,
              child: PageView.builder(
                itemCount: _list.length,
                controller: _pageController,
                onPageChanged: (change) {
                  setState(() {
                    _settingErrorOpacitiy = 0.0;
                  });
                },
                itemBuilder: ((BuildContext context, int index) {
                  return BookCardDivied(
                    index: index,
                    isSetting: (double isSetting) {
                      if (mounted) {
                        setState(() {
                          _settingErrorOpacitiy = isSetting;
                        });
                      }
                    },
                  );
                }),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SmoothPageIndicator(
                controller: _pageController,
                count: _list.length,
                effect: ExpandingDotsEffect(
                  dotWidth: 8,
                  dotHeight: 8,
                  activeDotColor: PRIMARY_COLOR_DEEP,
                  dotColor: Color(0xff80bcfa),
                ),
                onDotClicked: (index) {
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeIn,
                  );
                })
          ],
        ),
      );
    }
  }

  Widget settingCheck() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Obx(() {
          if (!_bleLoctionStateController.getBluetoothState)
            return customIconButton(
              tooltip: 'Not Authorized',
              onPressed: () async {
                try {
                  AppSettings.openBluetoothSettings();
                } catch (e) {}
              },
              icon: Icon(Icons.bluetooth),
              color: Colors.red,
            );

          return customIconButton(
            tooltip: 'Authorized',
            onPressed: () {},
            icon: Icon(Icons.bluetooth),
            color: Colors.blue,
          );
        }),
        Obx(() {
          if (!_bleLoctionStateController.getLocationState)
            return customIconButton(
              tooltip: 'Not Authorized',
              onPressed: () async {
                try {
                  // AppSettings.openLocationSettings(callback: () {
                  //   print("흠");
                  // });
                  Location location = Location();
                  if (await location.requestService()) {
                    _bleLoctionStateController.setLocationState();
                  } else {
                    if (Platform.isAndroid) {
                      customShowDiaLog(
                        context: context,
                        title: Container(
                          height: 20.0,
                          child: Center(
                            child: Text(
                              "위치 기능",
                              style: TextStyle(
                                  color: Color(0xff4888E0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        content: Container(
                          height: 45.0,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "바콘 인증을 위해서는 위치 기능을 켜야합니다.",
                              style: TextStyle(
                                  color: Color(0xff4888E0),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        action: [emptyListAction()],
                        isBackButton: true,
                      ).then((value) {
                        Navigator.pop(context);
                      });
                    }
                  }
                } catch (e) {}
              },
              icon: Icon(Icons.location_on),
              color: Colors.red,
            );

          return customIconButton(
            tooltip: 'Authorized',
            onPressed: () {},
            icon: Icon(Icons.location_on),
            color: Colors.blue,
          );
        }),
        CustomRotateRefresh(
          widget: Container(
            width: 40,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Icon(
              Icons.refresh,
              color: Colors.blue,
              size: 27,
            ),
          ),
        )
      ],
    );
  }

  Widget emptyListAction() {
    return Container(
      height: 53,
      child: Row(
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
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(18.0),
                        bottomLeft: Radius.circular(18.0),
                      ),
                    ),
                    child: Container(
                      child: Text(
                        "확인",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
