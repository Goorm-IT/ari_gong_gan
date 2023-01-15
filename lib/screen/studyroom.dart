import 'package:ari_gong_gan/model/reservation_place.dart';
import 'package:ari_gong_gan/model/reservation_place_list.dart';
import 'package:ari_gong_gan/widget/custom_appbar.dart';
import 'package:flutter/material.dart';

class Studyroom extends StatefulWidget {
  const Studyroom({super.key});

  @override
  State<Studyroom> createState() => _StudyroomState();
}

class _StudyroomState extends State<Studyroom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context, true, true),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xffe3eef9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 110,
              decoration: BoxDecoration(
                  color: Color(0xff2099e9),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
              child: Center(
                  child: Text(
                "스터디룸",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w600),
              )),
            ),
            SizedBox(
              height: 62,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 68),
              child: Text(
                "Anyang Uni.\nMAP",
                style: TextStyle(
                    color: Color(0xff2772AC),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                width: 300,
                height: 300,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/study_room.png',
                    ),
                    studyroomButton(
                        //아름다운 리더관
                        right: 203.5,
                        top: 227,
                        onTap: () {
                          showDialog(
                              useSafeArea: false,
                              context: context,
                              builder: (context) {
                                return studyroomDialog(
                                    title: "아리관 3층",
                                    floorList: ari_3rd_floor + ari_4th_floor);
                              });
                        }),
                    studyroomButton(
                        //수봉관
                        right: 119.2,
                        top: 16.5,
                        onTap: () {
                          showDialog(
                              useSafeArea: false,
                              context: context,
                              builder: (context) {
                                return studyroomDialog(
                                    title: "수봉관 7층",
                                    floorList: subong_7th_floor);
                              });
                        }),
                    studyroomButton(
                        //수리관
                        right: 81,
                        top: 92,
                        onTap: () {
                          showDialog(
                              useSafeArea: false,
                              context: context,
                              builder: (context) {
                                return studyroomDialog(
                                    title: "수리관 1층", floorList: suri_1st_floor);
                              });
                        }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget studyroomDialog({
    required String title,
    required List<ReservationPlace> floorList,
  }) {
    final PageController _pageController = PageController(initialPage: 0);
    String _title = title;
    String _room = floorList[0].place;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
      return AlertDialog(
        scrollable: true,
        titlePadding: const EdgeInsets.only(top: 22),
        contentPadding: const EdgeInsets.only(bottom: 20, top: 12),
        buttonPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(9))),
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 22,
                height: 22,
              ),
              Text(
                _title,
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff4888E0),
                    fontWeight: FontWeight.w600),
              ),
              ClipOval(
                child: Container(
                  color: Color(0xff4988e1),
                  width: 18,
                  height: 18,
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      iconSize: 14,
                      padding: const EdgeInsets.all(0),
                      splashRadius: 18.0,
                      splashColor: Color(0xffD1E9FF),
                      icon: Icon(
                        Icons.close_sharp,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        content: Container(
          height: 220,
          width: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0, -20),
                child: IconButton(
                  iconSize: 30,
                  onPressed: () {
                    _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  },
                  padding: const EdgeInsets.all(0),
                  splashRadius: 20.0,
                  icon: Icon(
                    Icons.chevron_left,
                    color: Color(0xff4888E0),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    child: PageView.builder(
                      itemCount: floorList.length,
                      controller: _pageController,
                      onPageChanged: (change) {
                        setModalState(() {
                          _room = floorList[change].place;
                        });
                        if (floorList[change].place == 'Self 1') {
                          setModalState(() {
                            _title = "아리관 4층";
                          });
                        }

                        if (floorList[change].place == 'Self 6') {
                          setModalState(() {
                            _title = "아리관 3층";
                          });
                        }
                      },
                      itemBuilder: ((BuildContext context, int index) {
                        return Column(
                          children: [
                            Container(
                              height: 170,
                              width: 170,
                              color: Colors.grey,
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  Text(
                    _room,
                    style: TextStyle(
                        color: Color(0xff2772AC),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Transform.translate(
                offset: Offset(0, -20),
                child: IconButton(
                  iconSize: 30,
                  onPressed: () {
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  },
                  padding: const EdgeInsets.all(0),
                  splashRadius: 20.0,
                  icon: Icon(
                    Icons.chevron_right,
                    color: Color(0xff4888E0),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget studyroomButton(
      {required double right,
      required double top,
      required Function()? onTap}) {
    return Positioned(
      right: right,
      top: top,
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: 58,
              height: 58,
            ),
          ),
        ),
      ),
    );
  }
}
