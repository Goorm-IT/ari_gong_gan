import 'package:ari_gong_gan/const/colors.dart';
import 'package:ari_gong_gan/screen/my_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

PreferredSizeWidget customAppbar(BuildContext context, bool menuVisible) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(58),
    child: AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      title: Image.asset(
        'assets/images/ari_logo.png',
        width: 35,
      ),
      actions: <Widget>[
        Transform.translate(
            offset: Offset(-10, 0),
            child: menuVisible
                ? IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade, child: MyPage()));
                    },
                    icon: const Icon(
                      Icons.menu,
                      size: 35,
                      color: PRIMARY_COLOR_DEEP,
                    ))
                : Container()),
      ],
    ),
  );
}
