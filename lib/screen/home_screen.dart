import 'package:ari_gong_gan/const/user_info.dart';
import 'package:ari_gong_gan/http/ari_server.dart';
import 'package:ari_gong_gan/provider/reservation_all_provider.dart';
import 'package:ari_gong_gan/provider/reservation_by_user_provider.dart';
import 'package:ari_gong_gan/screen/argeement_page.dart';
import 'package:ari_gong_gan/screen/check_reservation.dart';
import 'package:ari_gong_gan/screen/my_page.dart';
import 'package:ari_gong_gan/screen/reservation_complete.dart';
import 'package:ari_gong_gan/screen/select_am_pm.dart';
import 'package:ari_gong_gan/widget/custom_appbar.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import "dart:math" show pi;

import 'package:page_transition/page_transition.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

import '../const/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AriUser userInfo = GetIt.I<AriUser>();
  Color bookBorderColor = Colors.white;
  double bookBorderWidth = 0.0;
  bool isPressed = false;
  late RevervationAllProvider _revervationAllProvider;
  late ReservationByUserProvider _reservationByUserProvider;
  @override
  Widget build(BuildContext context) {
    _revervationAllProvider =
        Provider.of<RevervationAllProvider>(context, listen: false);
    _reservationByUserProvider =
        Provider.of<ReservationByUserProvider>(context, listen: false);
    double windowHeight = MediaQuery.of(context).size.height;
    double windowWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: customAppbar(context, true),
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
            children: [
              SizedBox(
                height: 53,
              ),
              Container(
                  margin: const EdgeInsets.only(left: 35),
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
                        TextSpan(
                            text: DateFormat('MMM. dd. yyyy')
                                .format(DateTime.now()),
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )),
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
                    // onTapDown: (TapDownDetails tmp) {
                    //   setState(() {
                    //     bookBorderColor = Colors.transparent;
                    //     bookBorderWidth = 2.0;
                    //   });
                    // },
                    // onTapCancel: () {
                    //   setState(() {
                    //     bookBorderColor = Colors.white;
                    //     bookBorderWidth = 0.0;
                    //   });
                    // },
                    // onTapUp: (TapUpDetails tmp) {
                    //   setState(() {
                    //     bookBorderColor = Colors.white;
                    //     bookBorderWidth = 0.0;
                    //   });
                    // },
                    onTap: () async {
                      await _revervationAllProvider.getReservationAll();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectAMPM()));
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
              height: MediaQuery.of(context).size.height - 420,
              margin: const EdgeInsets.symmetric(horizontal: 48.0),
              width: windowWidth - 96,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 25.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _Button(
                          title: '스터디룸',
                          image: 'assets/images/ari_book_leading_icon.png',
                          ontap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AgreementPage()));
                          },
                        ),
                        _Button(
                          title: '예약확인',
                          image: 'assets/images/ari_book_leading_icon.png',
                          ontap: () async {
                            await _reservationByUserProvider
                                .getReservationByUser();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CheckReservation()));
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
                    _BookCard(),
                  ],
                ),
              ),
            ),
          ),
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
      width: 108,
      height: 106,
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

class _BookCard extends StatefulWidget {
  const _BookCard({Key? key}) : super(key: key);

  @override
  State<_BookCard> createState() => __BookCardState();
}

class __BookCardState extends State<_BookCard> {
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
                    height: 250,
                    color: Colors.transparent,
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
