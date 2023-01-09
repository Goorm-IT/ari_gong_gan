import 'dart:io';

import 'package:ari_gong_gan/const/user_info.dart';
import 'package:ari_gong_gan/provider/today_reservation_provider.dart';
import 'package:ari_gong_gan/screen/home_sreen/open_book_card.dart';
import 'package:ari_gong_gan/widget/custom_showdialog.dart';
import 'package:flutter/material.dart';
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
                widget.isLoadingType(false);
                if (Platform.isAndroid) {
                  checkPerm();
                }
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
    var status = await Permission.bluetoothScan.status;
    print(status);
    if (status.isDenied) {
      await Permission.bluetoothScan.request();
    }
    if (!(await Permission.bluetoothScan.isGranted)) {
      Navigator.pop(context);
      customShowDiaLog(
        context: context,
        title: Text(
          "주변기기 권한",
          style: TextStyle(
              color: Color(0xff4888E0),
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        content: Container(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Text(
            "주변기기 권한이 없으면 인증이 불가합니다.\n권한을 허용해주세요.",
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
    // else if (await Permission.bluetoothScan.isRestricted) {
    //   // openAppSettings();
    //   print("여기 아니야?2");
    // } else if (await Permission.bluetoothScan.isPermanentlyDenied) {
    //   print("여기 아니야?3");
    // }

    // if (await Permission.bluetoothScan.status.isPermanentlyDenied) {
    //   // openAppSettings();
    //   print("여기 아니야?4");
    // }
    return "Done";
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
                  onTap: () {
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
