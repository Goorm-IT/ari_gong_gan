import 'package:ari_gong_gan/const/colors.dart';
import 'package:ari_gong_gan/const/user_info.dart';
import 'package:ari_gong_gan/widget/login_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'login_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Color textColor = PRIMARY_COLOR_DEEP;
  @override
  Widget build(BuildContext context) {
    AriUser userInfo = GetIt.I<AriUser>();
    double windowHeight = MediaQuery.of(context).size.height;
    double windowWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _myPageAppbar(context),
      body: Stack(children: [
        Container(
          height: windowHeight,
          width: windowWidth,
          color: Color(0xff6ea0e6),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 28.0,
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 35.0),
                child: ClipOval(
                  child: Container(
                      color: Colors.white,
                      width: 60,
                      height: 60,
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        'assets/images/ari_book_leading_icon.png',
                        width: 10,
                        height: 10,
                      )),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userInfo.name,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    userInfo.studentId,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ]),
        Positioned(
          bottom: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 69.0),
            height: 500,
            child: Column(
              children: [
                _Item(
                  title: '이용수칙',
                  onPress: () {
                    return null;
                  },
                ),
                SizedBox(
                  height: 30.0,
                ),
                _Item(
                  title: '대여방법',
                  onPress: () {
                    return null;
                  },
                ),
                SizedBox(
                  height: 30.0,
                ),
                _Item(
                  title: '예약취소',
                  onPress: () {
                    return null;
                  },
                ),
                SizedBox(
                  height: 30.0,
                ),
                _Item(
                  title: '로그아웃',
                  onPress: () async {
                    var ctrl = new LoginData();
                    await ctrl.removeLoginData();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipPath(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              color: Color(0xffd1e9ff),
            ),
            clipper: CustomClipPath(),
          ),
        ),
        SizedBox(
          height: 22,
        ),
      ]),
    );
  }
}

PreferredSizeWidget _myPageAppbar(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(58),
    child: AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      title: Text(
        "마이페이지",
        style: TextStyle(
            color: Color(0xff2772AC),
            fontSize: 17.0,
            fontWeight: FontWeight.w600),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back,
          size: 30,
          color: PRIMARY_COLOR_DEEP,
        ),
      ),
      // leading: GestureDetector(
      //   onTap: () {
      //     Navigator.pop(context);
      //   },
      //   child: Icon(
      //     Icons.arrow_back,
      //     color: PRIMARY_COLOR_DEEP,
      //     size: 30.0,
      //   ),
      // ),
    ),
  );
}

class _Item extends StatefulWidget {
  String title;
  Function() onPress;

  _Item({required this.title, required this.onPress, Key? key})
      : super(key: key);

  @override
  State<_Item> createState() => __ItemState();
}

class __ItemState extends State<_Item> {
  Color textColor = PRIMARY_COLOR_DEEP;
  @override
  Widget build(BuildContext context) {
    double windowHeight = MediaQuery.of(context).size.height;
    double windowWidth = MediaQuery.of(context).size.width;
    return Material(
      borderRadius: BorderRadius.all(
        Radius.circular(30),
      ),
      child: InkWell(
        borderRadius: BorderRadius.all(
          Radius.circular(28),
        ),
        onTap: widget.onPress,
        child: Ink(
          width: windowWidth - 139,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff6ea0e6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
