import 'package:ari_gong_gan/model/reservation.dart';
import 'package:ari_gong_gan/model/reservation_time.dart';
import 'package:ari_gong_gan/model/reservation_time_list.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:get/route_manager.dart';

typedef IsSelected = void Function(bool);

class CustomRadioCircleButton extends StatefulWidget {
  IsSelected isSelected;

  bool isPressed;
  String title;
  String isBooked;
  double size;
  Color pressedColor;
  Color shadowColor;
  AnimationController? animationController;
  Function()? onTap;
  CustomRadioCircleButton(
      {required this.isSelected,
      required this.isPressed,
      required this.title,
      required this.isBooked,
      required this.size,
      required this.pressedColor,
      required this.shadowColor,
      this.onTap,
      Key? key})
      : super(key: key);

  @override
  State<CustomRadioCircleButton> createState() =>
      CustomRadioCircleButtonState();
}

class CustomRadioCircleButtonState extends State<CustomRadioCircleButton>
    with SingleTickerProviderStateMixin {
  late Color textColor;
  late Color buttonColor;
  late Color shadowColor;

  @override
  void initState() {
    super.initState();
    textColor = widget.pressedColor;
    buttonColor = widget.pressedColor;
    shadowColor = widget.shadowColor;
  }

  @override
  Widget build(BuildContext context) {
    textColor = widget.isPressed ? Colors.white : widget.pressedColor;
    buttonColor = !widget.isPressed ? Colors.white : widget.pressedColor;
    shadowColor = !widget.isPressed
        ? widget.shadowColor
        : Color.fromARGB(223, 56, 56, 56);
    return widget.isBooked == 'activate'
        ? GestureDetector(
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap!();
              }

              widget.isSelected(!widget.isPressed);

              setState(() {
                for (ReservationTime list in tmpAM) {
                  list.isPressed = false;
                }
                for (ReservationTime list in tmpPM) {
                  list.isPressed = false;
                }
              });
            },
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: buttonColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4.0,
                    offset: Offset(0.5, 1.9),
                    color: shadowColor,
                    inset: widget.isPressed,
                  )
                ],
              ),
              child: Center(
                child: Text(
                  widget.title,
                  style:
                      TextStyle(fontWeight: FontWeight.w600, color: textColor),
                ),
              ),
            ),
          )
        : Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffFFF4B4),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4.0,
                  offset: Offset(0.5, 1.9),
                  color: shadowColor,
                )
              ],
            ),
            child: Center(
              child: Text(
                widget.title,
                style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
              ),
            ),
          );
  }
}

// color: Color.fromARGB(223, 59, 59, 59),