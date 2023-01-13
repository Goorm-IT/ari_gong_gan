import 'package:flutter/material.dart';

Widget customIconButton(
    {required String tooltip,
    required Function()? onPressed,
    required Icon icon,
    required Color color}) {
  return Material(
    color: Colors.transparent,
    child: Container(
      width: 40,
      child: IconButton(
          padding: const EdgeInsets.all(0),
          iconSize: 25,
          splashRadius: 20,
          icon: icon,
          tooltip: tooltip,
          onPressed: onPressed,
          color: color),
    ),
  );
}
