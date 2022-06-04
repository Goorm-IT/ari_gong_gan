// import 'package:ari_gong_gan/const/user_info.dart';
// import 'package:ari_gong_gan/screen/login_page.dart';
// import 'package:ari_gong_gan/widget/login_data.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import "dart:math" show pi;

// class Tmp extends StatefulWidget {
//   const Tmp({Key? key}) : super(key: key);

//   @override
//   State<Tmp> createState() => _TmpState();
// }

// class _TmpState extends State<Tmp> {
//   late AriUser userInfo;
//   @override
//   void initState() {
//     super.initState();
//     userInfo = GetIt.I<AriUser>();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height * 0.1;
//     return Scaffold(
//       body: Center(
//         child: Container(
//           height: height, //MediaQuery의 height*0.1값
//           margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(height * 0.25),
//                 bottomLeft: Radius.circular(height * 0.25),
//                 topRight: Radius.circular(height * 0.5),
//                 bottomRight: Radius.circular(height * 0.5)),
//             color: Colors.green,
//           ),
//           child: CustomPaint(
//             painter: MyPainter(),
//             child: Container(
//               margin: const EdgeInsets.all(8),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MyPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint() // Paint 클래스는 어떤 식으로 화면을 그릴지 정할 때 쓰임.
//       ..color = Colors.deepPurpleAccent // 색은 보라색
//       ..strokeCap = StrokeCap.round // 선의 끝은 둥글게 함.
//       ..strokeWidth = 4.0; // 선의 굵기는 4.0

//     Offset p1 = Offset(0.0, 0.0); // 선을 그리기 위한 좌표값을 만듬.
//     Offset p2 = Offset(size.width, size.height);
//     canvas.drawLine(p1, p2, paint); // 선을 그림.
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
