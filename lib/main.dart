import 'dart:io';

import 'package:ari_gong_gan/controller/ble_location_state_controller.dart';
import 'package:ari_gong_gan/controller/requirement_state_controller.dart';
import 'package:ari_gong_gan/http/ari_server.dart';
import 'package:ari_gong_gan/http/login_crawl.dart';
import 'package:ari_gong_gan/provider/reservation_all_provider.dart';
import 'package:ari_gong_gan/provider/reservation_by_user_provider.dart';
import 'package:ari_gong_gan/provider/review_by_floor_provider.dart';
import 'package:ari_gong_gan/provider/today_reservation_provider.dart';
import 'package:ari_gong_gan/screen/argeement_page.dart';
import 'package:ari_gong_gan/screen/home_sreen/home_screen.dart';
import 'package:ari_gong_gan/screen/login_page.dart';
import 'package:ari_gong_gan/widget/login_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:ntp/ntp.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color color = Color(0xfff9e769);
int? isInitView;
void main() async {
  Get.put(RequirementStateController());
  Get.put(BLELoctionStateController());
  WidgetsFlutterBinding.ensureInitialized();
  ByteData data = await PlatformAssetBundle()
      .load('assets/certificate/arigonggan.site.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());
  GetIt.I.allowReassignment = true;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isInitView = prefs.getInt('agreement');

  Future<int> tmp2() async {
    print("1");
    DateTime tmp = await NTP.now().timeout(const Duration(seconds: 3),
        onTimeout: () async {
      print("시간제한1");
      return await NTP.now();
    });
    print("2");
    DateTime currentTime = tmp.toUtc().add(Duration(hours: 9));
    print("3");
    GetIt.I.registerSingleton<DateTime>(currentTime);
    print("4");

    var ctrl = new LoginData();
    var assurance = await ctrl.loadLoginData();
    String saved_id = assurance["user_id"] ?? "";
    String saved_pw = assurance["user_pw"] ?? "";
    print("5");

    try {
      var loginCrwal = LoginCrwal(id: saved_id, pw: saved_pw);
      final getuserInfo = await loginCrwal.userInfo();
      print("6");
      var ariServer = AriServer();
      String ariLogin = await ariServer.login(id: saved_id, pw: saved_pw);
      print("7");

      if (ariLogin == "SUCCESS") {
        return 1;
      } else {
        return -1;
      }
    } catch (e) {
      return -1;
    }
  }

  isLoginDataSaved() async {
    int rst = await tmp2().timeout(const Duration(seconds: 10), onTimeout: () {
      print("시간제한2");
      return -1;
    });
    if (rst == 1) {
      return HomeScreen();
    } else {
      return isInitView == 0 ? LoginPage() : AgreementPage();
    }
  }

  GetIt.I.allowReassignment = true;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => RevervationAllProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ReviewByFloorProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ReservationByUserProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => TodayReservationProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'NotoSans',
          bottomSheetTheme: BottomSheetThemeData(),
        ),
        title: '아리공간',
        home: AnimatedSplashScreen.withScreenFunction(
          splash: Image.asset('assets/images/ari_logo.png'),
          splashIconSize: 100,
          screenFunction: isLoginDataSaved,
          duration: 500,
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
          backgroundColor: color,
          // duration: 3000,
        ),
      ),
    ),
  );
}
