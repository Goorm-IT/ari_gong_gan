import 'package:ari_gong_gan/const/user_info.dart';
import 'package:ari_gong_gan/http/login_crawl.dart';
import 'package:ari_gong_gan/screen/tmp.dart';
import 'package:ari_gong_gan/widget/login_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  String _id = "";
  String _pw = "";
  AriUser userInfo = AriUser('', '');
  bool status = false;

  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Flexible(
                        child: SizedBox(
                          height: 95,
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          'assets/images/ari_logo.png',
                          height: 80,
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          height: 53,
                        ),
                      ),
                      _LoginTextField(
                        controller: (text) {
                          setState(() {
                            _id = text;
                          });
                        },
                        obscureText: false,
                        hintText: "아이디",
                        image: 'ari_login_id',
                      ),
                      SizedBox(
                        height: 17,
                      ),
                      _LoginTextField(
                        controller: (text) {
                          setState(() {
                            _pw = text;
                          });
                        },
                        obscureText: true,
                        hintText: "비밀번호",
                        image: 'ari_login_pw',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 30.0),
                              child: FadeTransition(
                                opacity: _animationController,
                                child: Text(
                                  "로그인 정보를 확인해주세요",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 10.0),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "자동로그인",
                            style: TextStyle(color: Color(0xff2098EB)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          FlutterSwitch(
                            activeColor: Color(0xff4888E0),
                            inactiveColor: Colors.grey,
                            width: 50.0,
                            height: 25.0,
                            valueFontSize: 25.0,
                            toggleSize: 19.0,
                            value: status,
                            borderRadius: 30.0,
                            padding: 4.0,
                            onToggle: (val) {
                              setState(() {
                                status = val;
                              });
                            },
                          ),
                        ],
                      ),
                      Flexible(
                        child: SizedBox(
                          height: 30,
                        ),
                      ),
                      _LoginButton(
                        id: _id,
                        pw: _pw,
                        loginInfoSave: status,
                        sendMessage: (signal) {
                          if (signal) {
                            if (_animationController.status ==
                                AnimationStatus.completed) {
                              _animationController.reverse();
                              Future.delayed(const Duration(milliseconds: 200),
                                  () {
                                _animationController.forward();
                              });
                            } else {
                              _animationController.forward();
                            }
                          }
                        },
                      ),
                      Flexible(
                        child: SizedBox(
                          height: 22,
                        ),
                      ),
                      const Text.rich(
                        TextSpan(
                            text: '안양대학교 포털사이트 ',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xff80BCFA),
                              fontSize: 10.0,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '로그인과 동일합니다',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ]),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipPath(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      color: Color(0xff7FBCFA),
                    ),
                    clipper: CustomClipPath(),
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
              ],
            ),
          )),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 1.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(size.width / 2, size.height / 2, 0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

typedef LoginController = void Function(String);

class _LoginTextField extends StatefulWidget {
  String hintText;
  String image;
  bool obscureText;
  LoginController controller;

  _LoginTextField(
      {required this.controller,
      required this.hintText,
      required this.image,
      required this.obscureText,
      Key? key})
      : super(key: key);

  @override
  State<_LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<_LoginTextField> {
  final myController = TextEditingController();
  @override
  void initState() {
    super.initState();
    myController.addListener(_printLatestValue);
  }

  void _printLatestValue() {
    widget.controller(myController.text);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        obscureText: widget.obscureText,
        controller: myController,
        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
        decoration: loginTextFieldStyle(widget.hintText, widget.image),
      ),
    );
  }
}

InputDecoration loginTextFieldStyle(hintText, image) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(color: Color(0xff80BCFA)),
    prefixIcon: Container(
      margin: const EdgeInsets.only(left: 30, right: 10),
      child: Container(
          child: Image.asset(
        'assets/images/${image}.png',
        width: 15,
      )),
    ),
    labelStyle: const TextStyle(color: Color(0xff2772AC)),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      borderSide: BorderSide(width: 1, color: Color(0xff2772AC)),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      borderSide: BorderSide(width: 1, color: Color(0xff2772AC)),
    ),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
    ),
  );
}

typedef LoginFailedMessage = void Function(bool);

class _LoginButton extends StatelessWidget {
  AriUser userInfo = AriUser('', '');
  String id, pw;
  bool loginInfoSave;
  LoginFailedMessage sendMessage;
  _LoginButton(
      {required this.id,
      required this.pw,
      required this.loginInfoSave,
      required this.sendMessage,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () async {
          var loginCrwal = LoginCrwal(id: id, pw: pw);
          var ctrl = new LoginData();
          print(loginInfoSave);
          try {
            final getuserInfo = await loginCrwal.userInfo();
            if (loginInfoSave) {
              await ctrl.saveLoginData(id, pw);
            } else {
              await ctrl.removeLoginData();
            }
            userInfo = GetIt.I<AriUser>();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Tmp(),
              ),
            );
          } catch (e) {
            sendMessage(true);
            print("로그인 실패");
          }
        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: _LoginButtonInnerStyle(),
      ),
    );
  }
}

class _LoginButtonInnerStyle extends StatelessWidget {
  const _LoginButtonInnerStyle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment(-0.2, -1.0),
              end: Alignment(0.7, 2.0),
              colors: <Color>[Color(0xff7FBCFA), Color(0xff4E8EE3)]),
          borderRadius: BorderRadius.circular(50)),
      child: Container(
        width: 200,
        height: 65,
        alignment: Alignment.center,
        child: const Text(
          'LOGIN',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
