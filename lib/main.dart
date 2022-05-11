import 'package:ari_gong_gan/screen/home_screen.dart';
import 'package:ari_gong_gan/screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

const color = const Color(0xfff9e769);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.allowReassignment = true;
  runApp(
    MaterialApp(
      theme: ThemeData(fontFamily: 'NotoSans'),
      title: '아리공간',
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/images/title.png'),
        nextScreen: HomeScreen(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: color,
        duration: 3000,
      ),
    ),
  );
}
