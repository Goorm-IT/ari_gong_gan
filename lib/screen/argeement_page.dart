import 'package:ari_gong_gan/screen/login_page.dart';
import 'package:ari_gong_gan/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ari_gong_gan/const/colors.dart';

class AgreementPage extends StatefulWidget {
  const AgreementPage({Key? key}) : super(key: key);

  @override
  State<AgreementPage> createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  bool _totalRadioSelected = false;
  bool _fisrtRadioSelected = false;
  bool _secondRadioSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context, false, false),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: PRIMARY_COLOR_DEEP,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 53,
              ),
              Text.rich(
                TextSpan(
                  text: "아리공간",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                  children: [
                    TextSpan(
                        text: ' 서비스 이용을 위해 \n약관 내용에 동의해주세요.',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              SizedBox(
                height: 43,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _Rodio(
                    isSelected: (bool selected) {
                      setState(() {
                        _totalRadioSelected = selected;
                        if (_totalRadioSelected) {
                          _fisrtRadioSelected = true;
                          _secondRadioSelected = true;
                        } else {
                          _fisrtRadioSelected = false;
                          _secondRadioSelected = false;
                        }
                      });
                    },
                    radioButton: _totalRadioSelected,
                  ),
                  Transform.translate(
                    offset: Offset(0, -1),
                    child: Text(
                      "   전체동의",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Divider(
                thickness: 2,
                color: Colors.white,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  _Rodio(
                    isSelected: (bool selected) {
                      setState(() {
                        _fisrtRadioSelected = selected;
                        if (_fisrtRadioSelected && _secondRadioSelected) {
                          _totalRadioSelected = true;
                        } else {
                          _totalRadioSelected = false;
                        }
                      });
                    },
                    radioButton: _fisrtRadioSelected,
                  ),
                  _text(
                    title: '   필수) 서비스 이용약관',
                  ),
                  Flexible(
                      child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                  )),
                  Builder(builder: (context) {
                    return _openButton(onPressed: () {
                      customBottomSheet(context, 'agreement');
                    });
                  }),
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  _Rodio(
                    isSelected: (bool selected) {
                      setState(() {
                        _secondRadioSelected = selected;
                        if (_fisrtRadioSelected && _secondRadioSelected) {
                          _totalRadioSelected = true;
                        } else {
                          _totalRadioSelected = false;
                        }
                      });
                    },
                    radioButton: _secondRadioSelected,
                  ),
                  _text(
                    title: '   필수) 개인정보 취급방침',
                  ),
                  Flexible(
                      child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                  )),
                  Builder(builder: (context) {
                    return _openButton(onPressed: () {
                      customBottomSheet(context, 'personal_information');
                    });
                  }),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Divider(
                thickness: 2,
                color: Colors.white,
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Container(
                  width: 145,
                  height: 38,
                  child: ElevatedButton(
                    onPressed: _totalRadioSelected
                        ? () {
                            _controlTutorial();

                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: LoginPage()));
                          }
                        : null,
                    child: Text(
                      "확인",
                      style: TextStyle(
                          color: PRIMARY_COLOR_DEEP,
                          fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: Colors.grey,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _controlTutorial() async {
    int isInitView = 0;
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('agreement', isInitView);
  }

  Widget _text({required String title}) {
    return Transform.translate(
      offset: Offset(0, -1),
      child: Text(
        title,
        style: _textStyle(),
      ),
    );
  }

  Widget _openButton({required Function()? onPressed}) {
    return Container(
      width: 30,
      height: 30,
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          iconSize: 30,
          onPressed: onPressed,
          padding: const EdgeInsets.all(0),
          splashRadius: 20.0,
          icon: Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  customBottomSheet(BuildContext context, String file) {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.0), topLeft: Radius.circular(15.0)),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 66,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30),
                height: MediaQuery.of(context).size.height * 0.15,
                child: Column(
                  children: [
                    Flexible(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        right: 30,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ClipOval(
                          child: Container(
                            color: PRIMARY_COLOR_DEEP,
                            height: 20,
                            width: 20,
                            child: IconButton(
                              iconSize: 15,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              padding: const EdgeInsets.all(0),
                              splashRadius: 10.0,
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 40,
                        width: 150,
                        decoration: BoxDecoration(
                          color: PRIMARY_COLOR_DEEP,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            file == 'agreement' ? "서비스 이용약관" : "개인정보 취급방침",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.55,
                child: RawScrollbar(
                  thumbVisibility: true,
                  thickness: 10,
                  thumbColor: PRIMARY_COLOR_DEEP,
                  radius: Radius.circular(20),
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: FutureBuilder(
                          future: loadTextAsset('assets/texts/$file.txt'),
                          builder: (context, snapshot) {
                            return SingleChildScrollView(
                              child: Text(
                                snapshot.data.toString(),
                                style: TextStyle(color: PRIMARY_COLOR_DEEP),
                              ),
                            );
                          })),
                ),
              ),
            ],
          );
        });
  }

  Future<String> loadTextAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  TextStyle _textStyle() {
    return TextStyle(
        fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500);
  }
}

typedef RadioSelected = void Function(bool);

class _Rodio extends StatefulWidget {
  RadioSelected isSelected;
  bool radioButton;
  _Rodio({required this.isSelected, required this.radioButton, Key? key})
      : super(key: key);

  @override
  State<_Rodio> createState() => __RodioState();
}

class __RodioState extends State<_Rodio> {
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.isSelected(!widget.radioButton);
          });
        },
        child: Container(
          height: 20,
          width: 20,
          color: Colors.white,
          child: Stack(
            children: [
              Center(
                child: ClipOval(
                  child: Container(
                    color: widget.radioButton ? Color(0xff80BCFA) : Colors.grey,
                    height: 11,
                    width: 11,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
