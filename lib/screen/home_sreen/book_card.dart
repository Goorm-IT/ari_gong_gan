import 'package:ari_gong_gan/const/user_info.dart';
import 'package:ari_gong_gan/provider/today_reservation_provider.dart';
import 'package:ari_gong_gan/screen/home_sreen/open_book_card.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class BookCard extends StatefulWidget {
  const BookCard({Key? key}) : super(key: key);
  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> with WidgetsBindingObserver {
  AriUser userInfo = GetIt.I<AriUser>();
  late TodayReservationProvider _todayReservationProvider;
  @override
  Widget build(BuildContext context) {
    _todayReservationProvider =
        Provider.of<TodayReservationProvider>(context, listen: false);
    double windowHeight = MediaQuery.of(context).size.height;
    double windowWidth = MediaQuery.of(context).size.width;
    return Container(
      width: windowWidth - 146,
      height: 50,
      decoration: decoWithShadow(15.0),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () async {
            await _todayReservationProvider.getTodayReservation();
            showModalBottomSheet<void>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                ),
                context: context,
                builder: (BuildContext context) {
                  return OpenBookCard();
                });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "예약카드",
                  style: TextStyle(
                      color: Color(0xff2772AC), fontWeight: FontWeight.w600),
                ),
                Transform.translate(
                    offset: Offset(-7, 0),
                    child: Container(
                        width: 15, height: 50, color: Color(0xff2099e9)))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget infoItem({required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.only(left: 50),
      child: Text.rich(
        TextSpan(
          text: "$title     ",
          style: textStyle(),
          children: [
            TextSpan(
              text: content,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle textStyle() {
    return TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xff2772AC));
  }

  Widget customIconButton(
      {required String tooltip,
      required Function()? onPressed,
      required Icon icon,
      required Color color}) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 40,
        child: IconButton(
            padding: const EdgeInsets.all(0),
            iconSize: 25,
            splashRadius: 20,
            icon: icon,
            tooltip: tooltip,
            onPressed: onPressed,
            color: color),
      ),
    );
  }
}

BoxDecoration decoWithShadow(double ridius) {
  return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(ridius)),
      boxShadow: [
        BoxShadow(
          blurRadius: 4.0,
          offset: Offset(0.5, 1.9),
          color: Color(0xffbdc3c7),
        )
      ]);
}
