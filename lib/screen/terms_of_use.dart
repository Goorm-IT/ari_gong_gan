import 'package:ari_gong_gan/const/terms_of_use_text.dart';
import 'package:ari_gong_gan/widget/custom_appbar.dart';
import 'package:ari_gong_gan/widget/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class TermsOfUse extends StatefulWidget {
  const TermsOfUse({Key? key}) : super(key: key);

  @override
  State<TermsOfUse> createState() => _TermsOfUseState();
}

class _TermsOfUseState extends State<TermsOfUse> {
  @override
  Widget build(BuildContext context) {
    double windowHeight = MediaQuery.of(context).size.height;
    double windowWidth = MediaQuery.of(context).size.width;
    DateTime realTime = GetIt.I<DateTime>();
    return Scaffold(
      appBar: customAppbar(context, false, true),
      body: SafeArea(
        child: Stack(children: [
          Container(
            height: windowHeight,
            width: windowWidth,
            color: Color(0xff2099e9),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  130,
              decoration: BoxDecoration(
                color: Color(0xffd1e9ff),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _termsOfUseButtons(
                    height: 350,
                    width: (MediaQuery.of(context).size.width - 60) / 2 - 20,
                    color: Color(0xff80BCFA),
                    imagePath1: 'ari_3rd_floor',
                    imagePath2: 'ari',
                    title: '아리관 3, 4층',
                    content: ariTermsOfUse(),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width - 60) / 2 - 20,
                    height: 350,
                    child: Column(children: [
                      _termsOfUseButtons(
                        height: 210,
                        width:
                            (MediaQuery.of(context).size.width - 60) / 2 - 20,
                        color: Color(0xff4888E0),
                        imagePath1: 'suri_1st_floor',
                        imagePath2: 'suri',
                        title: '수리관 1층',
                        content: suriTermsOfUse(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _termsOfUseButtons(
                        height: 130,
                        width:
                            (MediaQuery.of(context).size.width - 60) / 2 - 20,
                        color: Color(0xff2772AC),
                        imagePath1: 'subong_7th_floor',
                        imagePath2: 'subong',
                        title: '수봉관 7층',
                        content: subongTermsOfUse(),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 40, left: 33),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "이용수칙",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  DateFormat('MMM. dd. yyyy').format(realTime),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _termsOfUseButtons(
      {required double height,
      required double width,
      required Color color,
      required String title,
      required String imagePath1,
      required String imagePath2,
      required Widget content}) {
    return Material(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        splashColor: Colors.white.withOpacity(0.5),
        onTap: () {
          _termsOfUseDialog(
            content: content,
            context: context,
            title: title,
            imagePath: imagePath1,
            color: color,
          );
        },
        child: Container(
          width: width,
          height: height,
          child: Stack(
            children: [
              Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 13,
                    child: Image.asset(
                      'assets/images/$imagePath1.png',
                    ),
                  ),
                  Text(' $title',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ],
              )),
              Positioned(
                bottom: 10,
                right: 10,
                child: ClipOval(
                  child: Container(
                    width: 28,
                    padding: const EdgeInsets.all(6.5),
                    color: Colors.white,
                    child: Image.asset(
                      'assets/images/$imagePath2.png',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _termsOfUseDialog({
    required BuildContext context,
    required String title,
    required Widget content,
    required String imagePath,
    required Color color,
  }) {
    return customshowDialog(
        useSafeArea: true,
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return CustomDialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 33),
              child: Container(
                  width: double.infinity,
                  height: 460,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  padding: const EdgeInsets.fromLTRB(27, 20, 16, 20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 35,
                          width: 135,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                offset: Offset(0.5, 1.9),
                                color: Color(0xffbdc3c7),
                              )
                            ],
                            color: color,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 13,
                                  child: Image.asset(
                                    'assets/images/$imagePath.png',
                                  ),
                                ),
                                Text(
                                  ' $title',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 34,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: content,
                        ),
                      )
                    ],
                  )));
        });
  }
}
