import 'package:ari_gong_gan/const/colors.dart';
import 'package:ari_gong_gan/const/user_info.dart';
import 'package:ari_gong_gan/http/ari_server.dart';
import 'package:ari_gong_gan/model/today_reservation_list.dart';
import 'package:ari_gong_gan/screen/mypage_showdialog/reservation_delete_confirm.dart';
import 'package:ari_gong_gan/widget/custom_showdialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ReservationDelete extends StatefulWidget {
  List<TodayReservation> list;
  ReservationDelete({Key? key, required this.list}) : super(key: key);
  @override
  _ReservationDeleteState createState() => _ReservationDeleteState();
}

class _ReservationDeleteState extends State<ReservationDelete> {
  bool checked = false;
  final PageController _pageController = PageController(initialPage: 0);
  int deletePage = 0;
  AriUser userInfo = GetIt.I<AriUser>();
  bool _isLoadingInpopup = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(top: 10, bottom: 5),
      buttonPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18))),
      title: Container(),
      content: Container(
          height: 75.0,
          child: Column(
            children: [
              Container(
                height: 50,
                width: 300,
                child: PageView.builder(
                  itemCount: widget.list.length,
                  controller: _pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      deletePage = index;
                    });
                  },
                  itemBuilder: ((BuildContext context, int index) {
                    return Container(
                      height: 50,
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${widget.list[index].floor}  ${widget.list[index].name}',
                            style: TextStyle(
                              color: Color(0xff4888E0),
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            '${widget.list[index].time.substring(0, 5)} - ${int.parse(widget.list[index].time.substring(0, 2)) + 1}:00',
                            style: TextStyle(
                              color: Color(0xff4888E0),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.list.length,
                  effect: ColorTransitionEffect(
                    dotWidth: 5,
                    dotHeight: 5,
                    activeDotColor: PRIMARY_COLOR_DEEP,
                    dotColor: Color(0xff80bcfa),
                  ),
                  onDotClicked: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 250),
                      curve: Curves.easeIn,
                    );
                  })
            ],
          )),
      actions: [
        Container(
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
                            "종료",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              !_isLoadingInpopup
                  ? Flexible(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(18.0)),
                        child: Material(
                          color: Color(0xffF9E769),
                          child: InkWell(
                            splashColor: Color.fromARGB(223, 255, 251, 15),
                            onTap: () async {
                              AriServer ariServer = AriServer();
                              setState(() {
                                _isLoadingInpopup = true;
                              });
                              try {
                                int rst = await ariServer.delete(
                                  id: userInfo.studentId,
                                  floor: widget.list[deletePage].floor,
                                  name: widget.list[deletePage].name,
                                  time: widget.list[deletePage].time,
                                );
                                setState(() {
                                  _isLoadingInpopup = false;
                                });
                                Navigator.pop(context);
                                if (rst != 200) {
                                  showDialog(
                                      context: context,
                                      builder: ((context) {
                                        return ReservationDeleteConfirm();
                                      }));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: ((context) {
                                        return ReservationDeleteConfirm();
                                      }));
                                }
                              } catch (e) {
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: ((context) {
                                      return ReservationDeleteConfirm();
                                    }));
                              }
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
                                  "예약취소",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Flexible(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(18.0)),
                        child: Material(
                          color: Color(0xffF9E769),
                          child: InkWell(
                            splashColor: Color.fromARGB(223, 255, 251, 15),
                            onTap: () {},
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(18.0),
                                ),
                              ),
                              child: Container(
                                child: Text(
                                  "예약취소",
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
        )
      ],
    );
  }
}
