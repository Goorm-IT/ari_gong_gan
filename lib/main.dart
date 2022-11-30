import 'package:ari_gong_gan/controller/requirement_state_controller.dart';
import 'package:ari_gong_gan/http/ari_server.dart';
import 'package:ari_gong_gan/http/login_crawl.dart';
import 'package:ari_gong_gan/provider/reservation_all_provider.dart';
import 'package:ari_gong_gan/provider/reservation_by_user_provider.dart';
import 'package:ari_gong_gan/provider/today_reservation_provider.dart';
import 'package:ari_gong_gan/screen/argeement_page.dart';
import 'package:ari_gong_gan/screen/home_sreen/home_screen.dart';
import 'package:ari_gong_gan/screen/login_page.dart';
import 'package:ari_gong_gan/view/home_page.dart';
import 'package:ari_gong_gan/widget/login_data.dart';
import 'package:flutter/material.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isInitView = prefs.getInt('agreement');
  isLoginDataSaved() async {
    // return HomePage();
    var ctrl = new LoginData();
    var assurance = await ctrl.loadLoginData();
    String saved_id = assurance["user_id"] ?? "";
    String saved_pw = assurance["user_pw"] ?? "";

    DateTime tmp = await NTP.now();
    DateTime currentTime = tmp.toUtc().add(Duration(hours: 9));
    GetIt.I.registerSingleton<DateTime>(currentTime);

    try {
      var loginCrwal = LoginCrwal(id: saved_id, pw: saved_pw);
      final getuserInfo = await loginCrwal.userInfo();
      var ariServer = AriServer();
      String ariLogin = await ariServer.login(id: saved_id, pw: saved_pw);
      if (ariLogin == "SUCCESS") {
        return HomeScreen();
      } else {
        return isInitView == 0 ? LoginPage() : AgreementPage();
      }
    } catch (e) {
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
          create: (BuildContext context) => ReservationByUserProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => TodayReservationProvider(),
        ),
      ],
      child: MaterialApp(
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
