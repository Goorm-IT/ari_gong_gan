import 'package:ari_gong_gan/http/login_crawl.dart';
import 'package:ari_gong_gan/screen/login_page.dart';
import 'package:ari_gong_gan/screen/tmp.dart';
import 'package:ari_gong_gan/widget/login_data.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  isLoginDataSaved() async {
    var ctrl = new LoginData();
    var assurance = await ctrl.loadLoginData();
    String saved_id = assurance["user_id"] ?? "";
    String saved_pw = assurance["user_pw"] ?? "";
    try {
      var loginCrwal = LoginCrwal(id: saved_id, pw: saved_pw);
      final getuserInfo = await loginCrwal.userInfo();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Tmp()));
    } catch (e) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    isLoginDataSaved();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Loading..."),
      ),
    );
  }
}
