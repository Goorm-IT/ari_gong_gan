import 'package:ari_gong_gan/const/colors.dart';
import 'package:ari_gong_gan/screen/my_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

PreferredSizeWidget customAppbar(
    BuildContext context, bool menuVisible, bool backButtonVisible) {
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
      leading: backButtonVisible
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 28,
                color: PRIMARY_COLOR_DEEP,
              ))
          : Container(),
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
                      Icons.person,
                      size: 37,
                      color: PRIMARY_COLOR_DEEP,
                    ))
                : Container()),
      ],
    ),
  );
}
