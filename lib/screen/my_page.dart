import 'dart:io';
import 'package:ari_gong_gan/const/colors.dart';
import 'package:ari_gong_gan/const/user_info.dart';
import 'package:ari_gong_gan/http/ari_server.dart';
import 'package:ari_gong_gan/model/today_reservation_list.dart';
import 'package:ari_gong_gan/provider/today_reservation_provider.dart';
import 'package:ari_gong_gan/screen/agreement_page_in_my_page.dart';
import 'package:ari_gong_gan/screen/mypage_showdialog/reservation_delete.dart';
import 'package:ari_gong_gan/screen/terms_of_use.dart';
import 'package:ari_gong_gan/widget/custom_gradient_progress.dart';
import 'package:ari_gong_gan/widget/custom_showdialog.dart';
import 'package:ari_gong_gan/widget/login_data.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get_it/get_it.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'login_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Color textColor = PRIMARY_COLOR_DEEP;
  List<TodayReservation> _list = [];
  final PageController _pageController = PageController(initialPage: 0);
  int deletePage = 0;
  bool _isLoading = false;
  bool _isLoadingInpopup = false;
  late TodayReservationProvider _todayReservationProvider;
  AriUser userInfo = GetIt.I<AriUser>();
  String osVersion = "";
  String machine = "";
  String emailBody = "";
  String ariVersion = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _todayReservationProvider =
        Provider.of<TodayReservationProvider>(context, listen: false);
    double windowHeight = MediaQuery.of(context).size.height;
    double windowWidth = MediaQuery.of(context).size.width;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    getDeviceAppInfo() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appName = packageInfo.appName;
      String version = packageInfo.version;
      setState(() {
        ariVersion = '$appName $version';
      });
      if (Platform.isAndroid) {
        AndroidDeviceInfo info = await deviceInfo.androidInfo;

        var release = info.version.release;
        var sdkInt = info.version.sdkInt;
        var manufacturer = info.manufacturer;
        var model = info.model;
        setState(() {
          osVersion = 'Android $release (SDK $sdkInt)';
          machine = '$manufacturer $model';
        });
      } else if (Platform.isIOS) {
        IosDeviceInfo info = await deviceInfo.iosInfo;
        var systemName = info.systemName;
        var version = info.systemVersion;
        var name = info.name;
        var model = info.model;
        setState(() {
          osVersion = '$systemName $version';
          machine = '$name $model';
        });
      }
      setState(() {
        emailBody = "";
        emailBody += "==============\n";
        emailBody += "아래 내용을 함께 보내주시면 큰 도움이 됩니다:)\n\n";
        emailBody += "학번 : ${userInfo.studentId}\n";
        emailBody += "아리공간 버전 : $ariVersion\n";
        emailBody += "OS 버전 : $osVersion\n";
        emailBody += "기기 : $machine\n";
        emailBody += "==============\n";
      });
    }

    void _sendEmail() async {
      final Email email = Email(
        body: emailBody,
        subject: '[아리공간 문의]',
        recipients: ['gjrehf@gmail.com'],
        cc: [],
        bcc: [],
        attachmentPaths: [],
        isHTML: false,
      );

      try {
        await FlutterEmailSender.send(email);
      } catch (error) {
        String title =
            "기본 메일 앱을 사용할 수 없기 때문에 앱에서 바로 문의를 전송하기 어려운 상황입니다.\n\n아래 메일로 문의 부탁드려요! \n\ngjrehf@gmail.com";
        String message = "";
        customShowDiaLog(
          context: context,
          title: Container(
            child: Text("죄송합니다"),
          ),
          content: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 350,
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14),
                ),
                Text("\n"),
                Text(
                  emailBody,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          action: [emptyListAction()],
          isBackButton: true,
        );
      }
    }

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
            height: MediaQuery.of(context).size.height - 180,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25.0,
                  ),
                  _Item(
                    title: '이용수칙',
                    onPress: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: TermsOfUse()));
                    },
                    isChecked: true,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  _Item(
                    title: '문의하기',
                    onPress: () async {
                      await getDeviceAppInfo();
                      _sendEmail();
                    },
                    isChecked: true,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  _Item(
                    title: '이용약관',
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgreementPageInMyPage()));
                    },
                    isChecked: true,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  _Item(
                    title: '예약취소',
                    onPress: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await _todayReservationProvider.getTodayReservation();
                      setState(() {
                        _isLoading = false;
                      });
                      setState(() {
                        _list = context
                            .read<TodayReservationProvider>()
                            .todayReservation
                            .where((TodayReservation element) {
                          return ((element.resStatus == "deactivation" ||
                                  element.resStatus == "prebooked") &&
                              element.seatStatus != "disable");
                        }).toList();
                        _list.sort((a, b) => a.time.compareTo(b.time));
                      });
                      _list.isEmpty
                          ? customShowDiaLog(
                              context: context,
                              title: Container(
                                height: 20.0,
                                child: Center(
                                  child: Text(
                                    "취소 가능한 내역이 없어요",
                                    style: TextStyle(
                                        color: Color(0xff4888E0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              content: Container(
                                height: 45.0,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "메인 페이지에서 예약하기를 눌러보세요!",
                                    style: TextStyle(
                                        color: Color(0xff4888E0),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              action: [emptyListAction()],
                              isBackButton: true,
                            )
                          : showDialog(
                              context: context,
                              builder: ((context) {
                                return ReservationDelete(list: _list);
                              }));
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
                        title: logoutDiaLogTitle(),
                        content: logoutDiaLogContent(),
                        action: [logoutDiaLogAction()],
                        isBackButton: true,
                      );
                    },
                    isChecked: false,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 22,
        ),
        Container(
          width: _isLoading ? MediaQuery.of(context).size.width : 0,
          height: _isLoading ? MediaQuery.of(context).size.height : 0,
          color: Colors.grey.withOpacity(0.4),
          child: Center(
              child: CustomCircularProgress(
            size: 40,
          )),
        ),
      ]),
    );
  }

  Widget emptyListAction() {
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
                    Navigator.pop(context);
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

  Widget logoutDiaLogTitle() {
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

  Widget logoutDiaLogContent() {
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

  Widget logoutDiaLogAction() {
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
                        title: logoutDiaLog2Title(),
                        content: logoutDiaLog2Content(),
                        action: [logoutDiaLog2Action()],
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

  Widget logoutDiaLog2Title() {
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

  Widget logoutDiaLog2Content() {
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

  Widget logoutDiaLog2Action() {
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
                        PageTransition(
                            type: PageTransitionType.fade, child: LoginPage()),
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
                      color: PRIMARY_COLOR_DEEP,
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
