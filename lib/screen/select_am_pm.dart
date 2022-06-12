import 'package:ari_gong_gan/widget/custom_appbar.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:intl/intl.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class SelectAMPM extends StatefulWidget {
  const SelectAMPM({Key? key}) : super(key: key);

  @override
  State<SelectAMPM> createState() => _SelectAMPMState();
}

class _SelectAMPMState extends State<SelectAMPM> {
  bool _isPressedAM = false;
  bool _isPressedPM = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xff2099e9),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 33.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 45,
                  ),
                  Text.rich(
                    TextSpan(
                      text: '시간',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                          text: '을 선택해주세요\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                        TextSpan(
                          text: DateFormat('MMM. dd. yyyy')
                              .format(DateTime.now()),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      _AMOrPM(
                        isSelected: (bool isSelected) {
                          setState(
                            () {
                              _isPressedAM = isSelected;
                              if (_isPressedPM == true) {
                                _isPressedPM = false;
                              }
                            },
                          );
                        },
                        isPressed: _isPressedAM,
                        title: "오전",
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      _AMOrPM(
                        isSelected: (bool isSelected) {
                          setState(
                            () {
                              _isPressedPM = isSelected;
                              if (_isPressedAM == true) {
                                _isPressedAM = false;
                              }
                            },
                          );
                        },
                        isPressed: _isPressedPM,
                        title: "오후",
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              height: 300,
              width: MediaQuery.of(context).size.width,
              transform: Matrix4.translationValues(
                  0, _isPressedAM || _isPressedPM ? 0 : 400, 0),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Center(
                    child: Text(
                  _isPressedAM ? "오전" : "오후",
                  style: TextStyle(fontSize: 30.0),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

typedef IsSelected = void Function(bool);

class _AMOrPM extends StatefulWidget {
  IsSelected isSelected;
  bool isPressed;
  String title;
  _AMOrPM(
      {required this.isSelected,
      required this.isPressed,
      required this.title,
      Key? key})
      : super(key: key);

  @override
  State<_AMOrPM> createState() => _AMOrPMState();
}

class _AMOrPMState extends State<_AMOrPM> {
  Color textColor = Color(0xff2772ac);
  Color buttonColor = Color(0xff2772ac);

  @override
  Widget build(BuildContext context) {
    textColor = widget.isPressed ? Colors.white : Color(0xff2772ac);
    buttonColor = !widget.isPressed ? Colors.white : Color(0xff2772ac);
    return GestureDetector(
      onTap: () {
        widget.isSelected(!widget.isPressed);
        // showModalBottomSheet<void>(
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.only(
        //           topLeft: Radius.circular(30.0),
        //           topRight: Radius.circular(30.0)),
        //     ),
        //     context: context,
        //     builder: (BuildContext context) {
        //       return Container(
        //         height: 250,
        //         color: Colors.transparent,
        //       );
        //     });
      },
      child: Container(
        width: 105.0,
        height: 105.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: buttonColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              offset: Offset(0.5, 1.9),
              color: Color.fromARGB(223, 59, 59, 59),
              inset: widget.isPressed,
            )
          ],
        ),
        child: Center(
          child: Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
          ),
        ),
      ),
    );
  }
}
