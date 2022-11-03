import 'dart:io';

import 'package:ari_gong_gan/const/colors.dart';
import 'package:ari_gong_gan/const/user_info.dart';
import 'package:ari_gong_gan/controller/requirement_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class BookCard extends StatefulWidget {
  const BookCard({Key? key}) : super(key: key);

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  final controller = Get.find<RequirementStateController>();
  AriUser userInfo = GetIt.I<AriUser>();
  @override
  Widget build(BuildContext context) {
    double windowHeight = MediaQuery.of(context).size.height;
    double windowWidth = MediaQuery.of(context).size.width;
    return Container(
      width: windowWidth - 146,
      height: 50,
      decoration: decoWithShadow(15.0),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            showModalBottomSheet<void>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                ),
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                      color: Colors.white,
                    ),
                    height: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              settingCheck(),
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: ClipOval(
                                  child: Container(
                                    color: Color(0xff4988e1),
                                    height: 20,
                                    width: 20,
                                    child: IconButton(
                                      iconSize: 15,
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
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 30),
                            width: 250,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xffD1E9FF),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
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
                                    content: '2022. 11. 01',
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  infoItem(
                                    title: "시간",
                                    content: '20:00 - 21:00',
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  infoItem(
                                    title: "장소",
                                    content: '아리관 4층 self 4',
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
                                  Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(60)),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(60)),
                                          splashColor:
                                              Colors.grey.withOpacity(0.5),
                                          onTap: () {},
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "예약인증",
                                    style: TextStyle(
                                        color: Color(0xff2772AC), fontSize: 12),
                                  )
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                    color: PRIMARY_COLOR_DEEP,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
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
                                "인증 가능 시간이 아닙니다",
                                style: TextStyle(
                                  color: Color(0xffe8cb1e),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "예약카드",
                  style: TextStyle(
                      color: Color(0xff2772AC), fontWeight: FontWeight.w600),
                ),
                Transform.translate(
                    offset: Offset(-7, 0),
                    child: Container(
                        width: 15, height: 50, color: Color(0xff2099e9)))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget infoItem({required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.only(left: 50),
      child: Text.rich(
        TextSpan(
          text: "$title     ",
          style: textStyle(),
          children: [
            TextSpan(
              text: content,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle textStyle() {
    return TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xff2772AC));
  }

  Widget settingCheck() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Obx(() {
          if (!controller.authorizationStatusOk)
            return customIconButton(
              tooltip: 'Not Authorized',
              onPressed: () async {
                await flutterBeacon.requestAuthorization;
              },
              icon: Icon(Icons.location_off),
              color: Colors.yellow,
            );

          return customIconButton(
            tooltip: controller.locationServiceEnabled
                ? 'Location Service ON'
                : 'Location Service OFF',
            onPressed: controller.locationServiceEnabled
                ? () {}
                : handleOpenLocationSettings,
            icon: Icon(
              controller.locationServiceEnabled
                  ? Icons.location_on
                  : Icons.location_off,
            ),
            color: controller.locationServiceEnabled ? Colors.blue : Colors.red,
          );
        }),
        Obx(() {
          if (!controller.locationServiceEnabled)
            return customIconButton(
              tooltip: 'Not Determined',
              onPressed: () {},
              icon: Icon(Icons.portable_wifi_off),
              color: Colors.grey,
            );

          if (!controller.authorizationStatusOk)
            return customIconButton(
              tooltip: 'Not Authorized',
              onPressed: () async {
                await flutterBeacon.requestAuthorization;
              },
              icon: Icon(Icons.portable_wifi_off),
              color: Colors.red,
            );

          return customIconButton(
            tooltip: 'Authorized',
            onPressed: () async {
              await flutterBeacon.requestAuthorization;
            },
            icon: Icon(Icons.wifi_tethering),
            color: Colors.blue,
          );
        }),
        Obx(() {
          final state = controller.bluetoothState.value;

          if (state == BluetoothState.stateOn) {
            return customIconButton(
              tooltip: 'Bluetooth ON',
              onPressed: () {
                print("asdsa");
              },
              icon: Icon(Icons.bluetooth_connected),
              color: Colors.lightBlueAccent,
            );
          }

          if (state == BluetoothState.stateOff) {
            return customIconButton(
              tooltip: 'Bluetooth OFF',
              onPressed: handleOpenBluetooth,
              icon: Icon(Icons.bluetooth),
              color: Colors.red,
            );
          }
          return customIconButton(
            tooltip: 'Bluetooth State Unknown',
            onPressed: () {},
            icon: Icon(Icons.bluetooth_disabled),
            color: Colors.grey,
          );
        }),
      ],
    );
  }

  Widget customIconButton(
      {required String tooltip,
      required Function()? onPressed,
      required Icon icon,
      required Color color}) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 40,
        child: IconButton(
            padding: const EdgeInsets.all(0),
            iconSize: 25,
            splashRadius: 20,
            icon: icon,
            tooltip: tooltip,
            onPressed: onPressed,
            color: color),
      ),
    );
  }

  handleOpenLocationSettings() async {
    if (Platform.isAndroid) {
      try {
        await flutterBeacon.requestAuthorization;
      } catch (e) {}
      await flutterBeacon.openLocationSettings;
    } else if (Platform.isIOS) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Location Services Off'),
            content: Text(
              'Please enable Location Services on Settings > Privacy > Location Services.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  handleOpenBluetooth() async {
    if (Platform.isAndroid) {
      try {
        await flutterBeacon.openBluetoothSettings;
      } on PlatformException catch (e) {
        print(e);
      }
    } else if (Platform.isIOS) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Bluetooth is Off'),
            content: Text('Please enable Bluetooth on Settings > Bluetooth.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

BoxDecoration decoWithShadow(double ridius) {
  return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(ridius)),
      boxShadow: [
        BoxShadow(
          blurRadius: 4.0,
          offset: Offset(0.5, 1.9),
          color: Color(0xffbdc3c7),
        )
      ]);
}
