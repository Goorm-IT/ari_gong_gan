import 'package:ari_gong_gan/http/ari_server.dart';
import 'package:ari_gong_gan/model/reservation_by_user.dart';
import 'package:ari_gong_gan/model/reservation_place.dart';
import 'package:ari_gong_gan/model/reservation_place_list.dart';
import 'package:ari_gong_gan/model/review_by_floor.dart';
import 'package:ari_gong_gan/provider/reservation_by_user_provider.dart';
import 'package:ari_gong_gan/provider/review_by_floor_provider.dart';
import 'package:ari_gong_gan/screen/write_review.dart';
import 'package:ari_gong_gan/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Studyroom extends StatefulWidget {
  const Studyroom({super.key});

  @override
  State<Studyroom> createState() => _StudyroomState();
}

class _StudyroomState extends State<Studyroom> {
  /// 기본 - 0, 아리관 -1 ,수봉관 -2, 수리관 - 3
  int selectedPlace = 0;
  String placeTitle = "스터디룸";
  double opacity = 1.0;
  PageController controller = PageController();
  List<ReservationByUser> _inititemList = [];
  Map reviewInfo = {};
  late ReviewByFloorProvider _reviewByFloorProvider;
  List<ReviewByFloor> infoList({required int index}) {
    List<ReviewByFloor> rstList = [];
    if (index == 1) {
      if (reviewInfo.containsKey('아리관 3층')) {
        rstList.addAll(reviewInfo['아리관 3층']);
      }
      if (reviewInfo.containsKey('아리관 4층')) {
        rstList.addAll(reviewInfo['아리관 4층']);
      }
    } else if (index == 2 && reviewInfo.containsKey('수봉관 7층')) {
      rstList.addAll(reviewInfo['수봉관 7층']);
    } else if (index == 3 && reviewInfo.containsKey('수리관 1층')) {
      rstList.addAll(reviewInfo['수리관 1층']);
    }

    return rstList;
  }

  changeTitle({required int index}) async {
    if (selectedPlace == index) return;
    setState(() {
      opacity = 0.0;
    });
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      if (index == 0) {
        placeTitle = '스터디룸';
      } else if (index == 1) {
        placeTitle = '아리관 리뷰';
      } else if (index == 2) {
        placeTitle = '수봉관 리뷰';
      } else if (index == 3) {
        placeTitle = '수리관 리뷰';
      }
      selectedPlace = index;

      print(placeTitle);
      opacity = 1.0;
    });
  }

  @override
  void initState() {
    super.initState();
    _inititemList = context.read<ReservationByUserProvider>().reservationByUser;
    reviewInfo = context.read<ReviewByFloorProvider>().reviewByFloor;
    print(reviewInfo);
  }

  @override
  Widget build(BuildContext context) {
    _reviewByFloorProvider =
        Provider.of<ReviewByFloorProvider>(context, listen: false);
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
                child: AnimatedOpacity(
                  opacity: opacity,
                  duration: Duration(milliseconds: 300),
                  child: Text(
                    placeTitle,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                  controller: controller,
                  onPageChanged: (index) {
                    changeTitle(index: index);
                  },
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return studyRoomMapWidget();
                    } else {
                      return Container(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(right: 10, top: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30.0),
                                              topRight: Radius.circular(30.0)),
                                        ),
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: 400,
                                            child: Column(children: [
                                              SizedBox(height: 20),
                                              Text(
                                                "최근 이용 내역",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 22),
                                              ),
                                              SizedBox(height: 20),
                                              Container(
                                                height: 320,
                                                child: SingleChildScrollView(
                                                    child: Column(
                                                  children: List.generate(
                                                      _inititemList.length,
                                                      (index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        WriteReview(
                                                                          info:
                                                                              _inititemList[index],
                                                                        ))).then(
                                                            (value) async {
                                                          if (value == true) {
                                                            await _reviewByFloorProvider
                                                                .getReviewByFloor(
                                                                    floor:
                                                                        '아리관 3층');
                                                            await _reviewByFloorProvider
                                                                .getReviewByFloor(
                                                                    floor:
                                                                        '아리관 4층');
                                                            await _reviewByFloorProvider
                                                                .getReviewByFloor(
                                                                    floor:
                                                                        '수봉관 7층');
                                                            await _reviewByFloorProvider
                                                                .getReviewByFloor(
                                                                    floor:
                                                                        '수리관 1층');
                                                          }
                                                        });
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            32,
                                                        height: 50,
                                                        margin: const EdgeInsets
                                                            .only(bottom: 20),
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 16),
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                0xff80bcfa),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(_inititemList[
                                                                          index]
                                                                      .floor),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(_inititemList[
                                                                          index]
                                                                      .name),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                ],
                                                              ),
                                                              Text(
                                                                '이용날짜 :  ${DateFormat('yyyy. MM. dd').format(DateTime.parse(_inititemList[index].realTime))} ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ]),
                                                      ),
                                                    );
                                                  }),
                                                )),
                                              )
                                            ]),
                                          );
                                        });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.control_point,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        "리뷰 추가하기",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (infoList(index: index).isEmpty)
                                Center(
                                  child: Text(
                                    "아직 리뷰가 없어요\n리뷰를 추가해주세요!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xff2099e9),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              if (infoList(index: index).isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      " 리뷰",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Column(
                                      children: List.generate(
                                          infoList(index: index).length,
                                          (index2) {
                                        return Container(
                                          height: 50,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              32,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: Row(
                                            children: [
                                              Text(
                                                  '  ${infoList(index: index)[index2].content}'),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              SizedBox(
                                height: 50,
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget studyRoomMapWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      changeTitle(index: 1);
                      controller.jumpToPage(1);
                    }),
                studyroomButton(
                    //수봉관
                    right: 119.2,
                    top: 16.5,
                    onTap: () {
                      changeTitle(index: 2);
                      controller.jumpToPage(2);
                    }),
                studyroomButton(
                    //수리관
                    right: 81,
                    top: 92,
                    onTap: () {
                      changeTitle(index: 3);
                      controller.jumpToPage(3);
                    }),
              ],
            ),
          ),
        ),
      ],
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
                              padding: const EdgeInsets.all(40),
                              height: 170,
                              width: 170,
                              color: Colors.grey.withOpacity(0.25),
                              child: Image.asset(
                                'assets/images/ari_logo.png',
                                width: 35,
                              ),
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
