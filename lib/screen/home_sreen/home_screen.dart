import 'package:ari_gong_gan/const/user_info.dart';
import 'package:ari_gong_gan/controller/requirement_state_controller.dart';
import 'package:ari_gong_gan/provider/reservation_all_provider.dart';
import 'package:ari_gong_gan/provider/reservation_by_user_provider.dart';
import 'package:ari_gong_gan/provider/today_reservation_provider.dart';
import 'package:ari_gong_gan/screen/check_reservation.dart';
import 'package:ari_gong_gan/screen/home_sreen/book_card.dart';
import 'package:ari_gong_gan/screen/select_am_pm.dart';
import 'package:ari_gong_gan/screen/studyroom.dart';
import 'package:ari_gong_gan/widget/custom_appbar.dart';
import 'package:ari_gong_gan/widget/custom_gradient_progress.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

import 'package:provider/provider.dart';
import "dart:math" show pi;
import 'package:page_transition/page_transition.dart';
import '../../const/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AriUser userInfo = GetIt.I<AriUser>();
  DateTime realTime = GetIt.I<DateTime>();
  Color bookBorderColor = Colors.white;
  double bookBorderWidth = 0.0;
  bool isPressed = false;
  bool _isLoading = false;
  bool _noProgressLoading = false;
  late RevervationAllProvider _revervationAllProvider;
  late ReservationByUserProvider _reservationByUserProvider;
  late TodayReservationProvider _todayReservationProvider;
  final controller = Get.find<RequirementStateController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _revervationAllProvider =
        Provider.of<RevervationAllProvider>(context, listen: false);
    _reservationByUserProvider =
        Provider.of<ReservationByUserProvider>(context, listen: false);
    _todayReservationProvider =
        Provider.of<TodayReservationProvider>(context, listen: false);
    double windowHeight = MediaQuery.of(context).size.height;
    double windowWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: customAppbar(context, true, false),
      body: Stack(
        children: [
          Container(
            height: windowHeight,
            width: windowWidth,
            color: PRIMARY_COLOR_DEEP,
          ),
          Container(
            height: 213.0,
            decoration: const BoxDecoration(
              color: Color(0xff80bcfa),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50.0),
                bottomRight: Radius.circular(50.0),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 53,
              ),
              Container(
                  margin: const EdgeInsets.only(left: 35),
                  height: 25,
                  child: Text.rich(
                    TextSpan(
                      text: userInfo.name,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                            text: '님 반갑습니다.\n',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(left: 35),
                child: Text(
                  DateFormat('MMM. dd. yyyy').format(realTime),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          Positioned(
            top: 160,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 48.0),
              child: Material(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
                child: Ink(
                  width: windowWidth - 96,
                  height: 105,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: bookBorderColor,
                      width: bookBorderWidth,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(28),
                    ),
                    onTap: () async {
                      setState(() {
                        _noProgressLoading = true;
                      });
                      DateTime tmp = await NTP.now();
                      DateTime currentTime =
                          tmp.toUtc().add(Duration(hours: 9));
                      GetIt.I.registerSingleton<DateTime>(currentTime);
                      await _revervationAllProvider.getReservationAll();
                      setState(() {
                        _noProgressLoading = false;
                      });
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: SelectAMPM()));
                    },
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 30,
                        ),
                        Image.asset(
                          'assets/images/ari_book_leading_icon.png',
                          width: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "예약하기",
                          style: TextStyle(
                            color: Color(0xff2772AC),
                            letterSpacing: 0.9,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                color: Color(0xffecf3ff),
              ),
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  400,
              margin: const EdgeInsets.symmetric(horizontal: 48.0),
              width: windowWidth - 96,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 25.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _Button(
                          title: '스터디룸',
                          image: 'assets/images/ari_study_room_icon.png',
                          ontap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    duration: const Duration(milliseconds: 100),
                                    child: Studyroom()));
                          },
                        ),
                        _Button(
                          title: '예약확인',
                          image: 'assets/images/ari_book_leading_icon.png',
                          ontap: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await _reservationByUserProvider
                                .getReservationByUser();
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: CheckReservation()));
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 24.5),
                    Divider(
                      thickness: 1.5,
                      color: Color(0xff80BCFA),
                    ),
                    SizedBox(height: 14.5),
                    BookCard(
                      isLoadingType: (bool isLoading) {
                        setState(() {
                          _isLoading = isLoading;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: _isLoading ? MediaQuery.of(context).size.width : 0,
            height: _isLoading ? MediaQuery.of(context).size.height : 0,
            color: Colors.grey.withOpacity(0.4),
            child: Center(
              child: CustomCircularProgress(
                size: 40,
              ),
            ),
          ),
          Container(
            width: _noProgressLoading ? MediaQuery.of(context).size.width : 0,
            height: _noProgressLoading ? MediaQuery.of(context).size.height : 0,
            color: Colors.grey.withOpacity(0.0),
          )
        ],
      ),
    );
  }
}

class _Button extends StatefulWidget {
  final String title;
  final String image;
  Function()? ontap;
  _Button({required this.title, required this.image, this.ontap, Key? key})
      : super(key: key);

  @override
  State<_Button> createState() => _ButtonState();
}

class _ButtonState extends State<_Button> {
  bool isPressed = false;
  CustomPainter a = MyPainter(containerRadius: 10, containerWidth: 108);
  CustomPainter b = MyPainters();

  @override
  Widget build(BuildContext context) {
    Color titleColor = isPressed ? PRIMARY_COLOR_DEEP : PRIMARY_COLOR_DEEP;
    return Container(
      width: MediaQuery.of(context).size.width / 3.7,
      height: MediaQuery.of(context).size.width / 3.7,
      decoration: decoWithShadow(10.0),
      child: Material(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        child: CustomPaint(
          painter: isPressed ? a : b,
          child: InkWell(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            onTapDown: (TapDownDetails tmp) {
              setState(() {
                isPressed = !isPressed;
              });
            },
            onTapUp: (TapUpDetails tmp) {
              setState(() {
                isPressed = !isPressed;
              });
            },
            onTapCancel: () {
              setState(() {
                isPressed = false;
              });
            },
            onTap: widget.ontap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  widget.image,
                  width: 31,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.title,
                  style:
                      TextStyle(color: titleColor, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  double degToRad(double degree) {
    return degree * (pi / 180);
  }

  double containerRadius;
  double containerWidth;
  MyPainter({required this.containerRadius, required this.containerWidth});
  @override
  void paint(Canvas canvas, Size size) {
    //bubble body
    final path = Path()
      ..addArc(
          Rect.fromCircle(
              center: Offset(containerRadius, containerRadius),
              radius: containerRadius),
          degToRad(180),
          degToRad(90))
      ..lineTo(98, 0)
      ..addArc(
          Rect.fromCircle(
              center: Offset(containerWidth - containerRadius, containerRadius),
              radius: containerRadius),
          degToRad(270),
          degToRad(90))
      ..lineTo(containerWidth, containerRadius * 2)
      ..quadraticBezierTo(
          containerWidth, 5, containerWidth - containerRadius * 2, 5)
      ..lineTo(10, 5)
      ..quadraticBezierTo(1, 5, 0, containerRadius * 2)
      ..lineTo(0, 10);

    // paint setting
    var paint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(5))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class MyPainters extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.transparent;

    Offset p1 = Offset(0.0, 0.0);
    Offset p2 = Offset(size.width, size.height);
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
