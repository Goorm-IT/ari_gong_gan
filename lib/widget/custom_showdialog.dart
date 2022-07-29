import 'package:ari_gong_gan/const/colors.dart';
import 'package:ari_gong_gan/screen/home_screen.dart';
import 'package:flutter/material.dart';

Future customShowDiaLog({
  required BuildContext context,
  required Widget title,
  required Widget content,
  required List<Widget> action,
  required bool isBackButton,
}) {
  return showDialog(
      useSafeArea: false,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => isBackButton,
          child: AlertDialog(
            contentPadding: const EdgeInsets.only(top: 10, bottom: 5),
            buttonPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(18))),
            title: title,
            content: content,
            actions: action,
          ),
        );
      });
}
