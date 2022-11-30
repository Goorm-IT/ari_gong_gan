import 'package:flutter/material.dart';

class BottomToUpFade extends StatefulWidget {
  final Widget insideWidget;
  final double height;
  final int delayTime;
  final Alignment initAlignment;
  final Alignment changeAlignment;

  BottomToUpFade(
      {required this.insideWidget,
      required this.height,
      required this.delayTime,
      required this.initAlignment,
      required this.changeAlignment,
      super.key});

  @override
  State<BottomToUpFade> createState() => _BottomToUpFadeState();
}

class _BottomToUpFadeState extends State<BottomToUpFade> {
  double _opacitiy = 0.0;
  late Alignment _position;

  @override
  void initState() {
    super.initState();
    _position = widget.initAlignment;
    Future.delayed(Duration(milliseconds: widget.delayTime))
        .then((value) => setState(() {
              _opacitiy = 1.0;
              _position = widget.changeAlignment;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: widget.height,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 400),
        opacity: _opacitiy,
        child: AnimatedAlign(
            duration: Duration(milliseconds: 150),
            alignment: _position,
            child: widget.insideWidget),
      ),
    );
  }
}
