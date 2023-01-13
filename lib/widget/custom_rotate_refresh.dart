import 'package:ari_gong_gan/controller/ble_location_state_controller.dart';
import 'package:ari_gong_gan/widget/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomRotateRefresh extends StatefulWidget {
  Widget widget;

  CustomRotateRefresh({required this.widget, super.key});
  @override
  _CustomRotateRefreshState createState() => _CustomRotateRefreshState();
}

class _CustomRotateRefreshState extends State<CustomRotateRefresh>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _bleLoctionStateController = Get.find<BLELoctionStateController>();
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _controller.forward();
        _bleLoctionStateController.setLocationState();
        Future.delayed(Duration(milliseconds: 300)).then((value) {
          _controller.reset();
        });
      },
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
        child: widget.widget,
      ),
    );
  }
}
