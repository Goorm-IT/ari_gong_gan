import 'package:ari_gong_gan/const/user_info.dart';
import 'package:ari_gong_gan/screen/home_sreen/home_screen.dart';
import 'package:ari_gong_gan/widget/custom_appbar.dart';
import 'package:ari_gong_gan/widget/custom_dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:page_transition/page_transition.dart';
import "dart:math" show pi;
import '../model/reservation.dart';

class ReservationComplete extends StatefulWidget {
  String time;
  String floor;
  String name;
  ReservationComplete(
      {required this.time, required this.floor, required this.name, Key? key})
      : super(key: key);

  @override
  State<ReservationComplete> createState() => _ReservationCompleteState();
}

class _ReservationCompleteState extends State<ReservationComplete> {
  @override
  Widget build(BuildContext context) {
    AriUser userInfo = GetIt.I<AriUser>();
    DateTime realTime = GetIt.I<DateTime>();
    double windowHeight = MediaQuery.of(context).size.height;
    double windowWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(type: PageTransitionType.fade, child: HomeScreen()),
            (route) => false);

        return false;
      },
      child: Scaffold(
        appBar: customAppbar(context, false, false),
        body: Stack(
          children: [
            Container(
              height: windowHeight,
              width: windowWidth,
              color: Color(0xff80BCFA),
            ),
            Container(
              height: 150,
              width: windowWidth,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10.0,
                    offset: Offset(0.5, 1.9),
                    color: Colors.black.withOpacity(0.3),
                  )
                ],
                color: Color(0xffD1E9FF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 23),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ClipOval(
                          child: Container(
                            color: Color(0xff4988e1),
                            width: 20,
                            height: 20,
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                iconSize: 16,
                                padding: const EdgeInsets.all(0),
                                splashRadius: 20.0,
                                splashColor: Color(0xffD1E9FF),
                                icon: Icon(
                                  Icons.close_sharp,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          child: HomeScreen()),
                                      (route) => false);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Container(
                            color: Color(0xff4988e1),
                            width: 29,
                            height: 29,
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                iconSize: 22,
                                padding: const EdgeInsets.all(0),
                                splashRadius: 20.0,
                                splashColor: Color(0xffD1E9FF),
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "  좌석 지정이 완료되었습니다",
                          style: TextStyle(
                            color: Color(0xff4988e1),
                            fontSize: 19,
                            fontFamily: "Noto_Sans_KR",
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 200,
              right: 50,
              left: 50,
              child: Container(
                //           height: 390,
                //           width: windowWidth,
                child: Stack(
                  children: [
                    Center(
                      child: CustomPaint(
                        painter: MyPainter(
                          containerRadius: 50,
                          containerWidth: 291,
                          containerHeight: windowWidth,
                          point: 218,
                          pointRadius: 10,
                        ),
                        child: Container(
                          width: 390,
                          height: windowWidth,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 1,
                      child: Center(
                        child: ClipPath(
                          clipper: _CustomPath(
                            radius: 50,
                            point: 260,
                            pointRadius: 10,
                          ),
                          child: Container(
                            width: 390,
                            height: windowWidth,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 45),
                                  _reservationCompleteInfo("이름", userInfo.name),
                                  _reservationCompleteInfo(
                                      "학번", userInfo.studentId),
                                  _reservationCompleteInfo(
                                    "날짜",
                                    DateFormat('yyyy. MM. dd').format(realTime),
                                  ),
                                  _reservationCompleteInfo("시간",
                                      '${widget.time.substring(0, 5)} - ${int.parse(widget.time.substring(0, 2)) + 1}:00'),
                                  _reservationCompleteInfo(
                                      "장소", '${widget.floor} ${widget.name}'),
                                  SizedBox(height: 30),
                                  custom_dotted_line(margin: 15.0, divide: 4),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        "예약하신 시간과 장소에서\n홈화면 > 예약카드의 예약인증을 해주시길 바랍니다. \n예약 미인증 시 패널티가 부과됩니다.",
                                        style: TextStyle(
                                          color: Color(0xff4888E0),
                                          fontSize: 10,
                                          letterSpacing: 1.1,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime> getRealTime() async {
    DateTime currentTime = await NTP.now();
    return currentTime.toUtc().add(Duration(hours: 9));
  }

  Widget _reservationCompleteInfo(String title, String body) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
                text: '   $title     ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xff4888E0),
                  fontSize: 14.0,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: body,
                    style: TextStyle(
                      color: Color(0xff80BCFA),
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ]),
          ),
          Divider(
            height: 5,
            thickness: 1,
            color: Color(0xff4888E0),
          ),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}

class _CustomPath extends CustomClipper<Path> {
  final double radius;
  final double point;
  final double pointRadius;

  _CustomPath(
      {required this.radius, required this.point, required this.pointRadius});
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, radius);
    path.lineTo(0, point);
    path.arcToPoint(Offset(0, point + pointRadius * 2),
        clockwise: true, radius: Radius.circular(pointRadius));
    path.lineTo(0, size.height - radius);
    path.arcToPoint(Offset(radius, size.height),
        clockwise: false, radius: Radius.circular(radius));
    path.lineTo(size.width - radius, size.height);

    path.arcToPoint(Offset(size.width, size.height - radius),
        clockwise: false, radius: Radius.circular(radius));
    path.lineTo(size.width, point + pointRadius * 2);
    path.arcToPoint(Offset(size.width, point),
        clockwise: true, radius: Radius.circular(pointRadius));
    path.lineTo(size.width, radius);

    path.arcToPoint(Offset(size.width - radius, 0),
        clockwise: false, radius: Radius.circular(radius));
    path.lineTo(radius, 0);

    path.arcToPoint(Offset(0, radius),
        clockwise: false, radius: Radius.circular(radius));

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
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
  double containerHeight;
  double point;
  double pointRadius;
  MyPainter({
    required this.containerRadius,
    required this.containerWidth,
    required this.containerHeight,
    required this.point,
    required this.pointRadius,
  });
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
      ..lineTo(containerWidth - containerRadius, 0)
      ..addArc(
          Rect.fromCircle(
              center: Offset(containerWidth - containerRadius, containerRadius),
              radius: containerRadius),
          degToRad(270),
          degToRad(90))
      ..lineTo(containerWidth, point - pointRadius + containerRadius)
      ..addArc(
          Rect.fromCircle(
              center: Offset(containerWidth, point + containerRadius),
              radius: pointRadius),
          degToRad(270),
          degToRad(-180)) //중간에 동그라미
      ..lineTo(containerWidth, containerHeight - containerRadius)
      ..addArc(
          Rect.fromCircle(
              center: Offset(containerWidth - containerRadius,
                  containerHeight - containerRadius),
              radius: containerRadius),
          degToRad(0),
          degToRad(90))
      ..lineTo(containerRadius, containerHeight)
      ..addArc(
          Rect.fromCircle(
              center:
                  Offset(containerRadius, containerHeight - containerRadius),
              radius: containerRadius),
          degToRad(90),
          degToRad(90))
      ..lineTo(0, point + pointRadius + containerRadius) // ddurl
      ..addArc(
          Rect.fromCircle(
              center: Offset(0, point + containerRadius), radius: pointRadius),
          degToRad(90),
          degToRad(-180))
      ..lineTo(0, containerRadius);

    // paint setting
    var paint = Paint()
      ..strokeWidth = 10
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(10))
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
