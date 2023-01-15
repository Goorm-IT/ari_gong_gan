import 'dart:async';
import 'dart:io';
import 'package:ari_gong_gan/const/user_info.dart';
import 'package:ari_gong_gan/controller/ble_location_state_controller.dart';
import 'package:ari_gong_gan/provider/today_reservation_provider.dart';
import 'package:ari_gong_gan/screen/home_sreen/open_book_card.dart';
import 'package:ari_gong_gan/widget/custom_showdialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

typedef IsLoadingType = void Function(bool);

class BookCard extends StatefulWidget {
  IsLoadingType isLoadingType;
  BookCard({required this.isLoadingType, Key? key}) : super(key: key);
  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> with WidgetsBindingObserver {
  AriUser userInfo = GetIt.I<AriUser>();
  late TodayReservationProvider _todayReservationProvider;

  final _bleLoctionStateController = Get.find<BLELoctionStateController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _todayReservationProvider =
        Provider.of<TodayReservationProvider>(context, listen: false);
    double windowHeight = MediaQuery.of(context).size.height;
    double windowWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          width: windowWidth - 146,
          height: 50,
          decoration: decoWithShadow(15.0),
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              onTap: () async {
                widget.isLoadingType(true);
                await _todayReservationProvider.getTodayReservation();
                var result = await flutterBeacon.bluetoothState;

                await _bleLoctionStateController.setBluetoothState(
                    result.toString() == "STATE_ON" ? true : false);

                widget.isLoadingType(false);

                await _bleLoctionStateController.setLocationState();

                showModalBottomSheet<void>(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                    ),
                    context: context,
                    builder: (BuildContext context) {
                      return OpenBookCard();
                    });
                await checkPerm();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "예약카드",
                      style: TextStyle(
                          color: Color(0xff2772AC),
                          fontWeight: FontWeight.w600),
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
        ),
      ],
    );
  }

  checkPerm() async {
    if (Platform.isAndroid) {
      if (await Permission.bluetoothScan.status.isDenied) {
        await Permission.bluetoothScan.request();
      }
      if (await Permission.location.status.isDenied) {
        await Permission.location.request();
      }
      if (!(await Permission.bluetoothScan.isGranted)) {
        Navigator.pop(context);
        requestPerm(
            title: "권한 요청", content: "주변기기 권한이 없으면 비콘 인증이 불가합니다.\n권한을 허용해주세요.");
      }
      if (!(await Permission.location.isGranted)) {
        Navigator.pop(context);
        requestPerm(
            title: '권한 요청',
            content: '정확한 위치 권한이 없으면 비콘 인증이 불가합니다.\n권한을 허용해주세요.');
      }
    } else if (Platform.isIOS) {
      if (await Permission.bluetooth.status.isDenied) {
        await Permission.bluetooth.request();
      }

      if (await Permission.location.status.isDenied) {
        await Permission.location.request();
      }
      if (!(await Permission.bluetooth.status.isGranted)) {
        Navigator.pop(context);
        requestPerm(
            title: '권한 요청', content: '블루투스 권한이 없으면 비콘 인증이 불가합니다.\n권한을 허용해주세요.');
      }

      if (!_bleLoctionStateController.getLocationState) {
        Navigator.pop(context);
        customShowDiaLog(
          context: context,
          title: Text(
            "위치 서비스",
            style: TextStyle(
                color: Color(0xff4888E0),
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          content: Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              "비콘 인증을 하기위해서는 위치를 켜야합니다.\n설정 > 위치 에서 위치 서비스를 켜주세요.",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Color(0xff4888E0),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
          action: [logoutDiaLogAction()],
          isBackButton: true,
        );
      } else if (!(await Permission.location.status.isGranted)) {
        Navigator.pop(context);
        requestPerm(
            title: '권한 요청',
            content: '정확한 위치 권한이 없으면 비콘 인증이 불가합니다.\n권한을 허용해주세요.');
      }
    }

    return "Done";
  }

  Future requestPerm({required String title, required String content}) {
    return customShowDiaLog(
      context: context,
      title: Text(
        title,
        style: TextStyle(
            color: Color(0xff4888E0),
            fontSize: 16,
            fontWeight: FontWeight.w600),
      ),
      content: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Text(
          content,
          style: TextStyle(
              color: Color(0xff4888E0),
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
      ),
      action: [logoutDiaLog2Action()],
      isBackButton: true,
    );
  }

  Widget logoutDiaLog2Action() {
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
                    openAppSettings();
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

  Widget logoutDiaLogAction() {
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
