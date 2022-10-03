import 'package:ari_gong_gan/const/colors.dart';
import 'package:ari_gong_gan/const/user_info.dart';
import 'package:ari_gong_gan/screen/terms_of_use.dart';
import 'package:ari_gong_gan/view/home_page.dart';
import 'package:ari_gong_gan/widget/custom_showdialog.dart';
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
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top -
                130,
            decoration: BoxDecoration(
              color: Color(0xffd1e9ff),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      userInfo.name,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      userInfo.studentId,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Positioned(
          top: 180,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 50.0),
            height: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _Item(
                  title: '공지사항',
                  onPress: () {
                    return null;
                  },
                  isChecked: true,
                ),
                SizedBox(
                  height: 15.0,
                ),
                _Item(
                  title: '이용수칙',
                  onPress: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return TermsOfUse();
                    })));
                    return null;
                  },
                  isChecked: true,
                ),
                SizedBox(
                  height: 15.0,
                ),
                _Item(
                  title: '문의사항',
                  onPress: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return HomePage();
                    })));
                    return null;
                  },
                  isChecked: true,
                ),
                SizedBox(
                  height: 15.0,
                ),
                _Item(
                  title: '이용약관',
                  onPress: () {
                    return null;
                  },
                  isChecked: true,
                ),
                SizedBox(
                  height: 15.0,
                ),
                _Item(
                  title: '예약취소',
                  onPress: () {
                    return null;
                  },
                  isChecked: false,
                ),
                SizedBox(
                  height: 15.0,
                ),
                _Item(
                  title: '로그아웃',
                  onPress: () {
                    customShowDiaLog(
                      context: context,
                      title: diaLogTitle(),
                      content: diaLogContent(),
                      action: [diaLogAction()],
                      isBackButton: true,
                    );
                  },
                  isChecked: false,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 22,
        ),
      ]),
    );
  }

  Widget diaLogTitle() {
    return Container(
      child: Center(
        child: Text(
          "로그 아웃",
          style: TextStyle(
              color: PRIMARY_COLOR_DEEP,
              fontSize: 18,
              fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget diaLogContent() {
    return Container(
        height: 50.0,
        child: Column(
          children: [
            Text(
              "로그아웃 하시겠습니까?",
              style: TextStyle(
                color: PRIMARY_COLOR_DEEP,
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ));
  }

  Widget diaLogAction() {
    return Container(
      height: 53,
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(18.0)),
              child: Material(
                color: Color(0xffBCBCBC),
                child: InkWell(
                  splashColor: Colors.white,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(18.0),
                      ),
                    ),
                    child: Container(
                      child: Text(
                        "취소",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(18.0)),
              child: Material(
                color: Color(0xffF9E769),
                child: InkWell(
                  splashColor: Color.fromARGB(223, 255, 251, 15),
                  onTap: () {
                    Navigator.pop(context);
                    customShowDiaLog(
                        context: context,
                        title: diaLog2Title(),
                        content: diaLog2Content(),
                        action: [diaLog2Action()],
                        isBackButton: false);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(18.0),
                      ),
                    ),
                    child: Container(
                      child: Text(
                        "확인",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget diaLog2Title() {
    return Container(
      child: Center(
        child: Text(
          "로그 아웃",
          style: TextStyle(
              color: PRIMARY_COLOR_DEEP,
              fontSize: 18,
              fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget diaLog2Content() {
    return Container(
        height: 50.0,
        child: Column(
          children: [
            Text(
              "로그아웃 완료되었습니다.",
              style: TextStyle(
                color: PRIMARY_COLOR_DEEP,
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ));
  }

  Widget diaLog2Action() {
    return Container(
      height: 53,
      child: Row(
        children: [
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18.0),
                bottomRight: Radius.circular(18.0),
              ),
              child: Material(
                color: Color(0xffF9E769),
                child: InkWell(
                  onTap: () async {
                    var ctrl = new LoginData();
                    await ctrl.removeLoginData();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(18.0),
                        bottomLeft: Radius.circular(18.0),
                      ),
                    ),
                    child: Container(
                      child: Text(
                        "확인",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
  bool isChecked;

  _Item(
      {required this.title,
      required this.onPress,
      required this.isChecked,
      Key? key})
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

    return Container(
      width: windowWidth - 100,
      height: 70,
      child: ElevatedButton(
        onPressed: widget.onPress,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey,
          backgroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(33),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 35),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff4988e1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                widget.isChecked
                    ? Container(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xff4888E0),
                        ),
                        margin: const EdgeInsets.only(right: 30),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
