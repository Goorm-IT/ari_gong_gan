import 'package:ari_gong_gan/const/colors.dart';
import 'package:flutter/material.dart';

class ReservationDeleteConfirm extends StatefulWidget {
  const ReservationDeleteConfirm({super.key});

  @override
  State<ReservationDeleteConfirm> createState() =>
      _ReservationDeleteConfirmState();
}

class _ReservationDeleteConfirmState extends State<ReservationDeleteConfirm> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(top: 10, bottom: 5),
      buttonPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18))),
      title: deleteDiaLog2Title(),
      content: deleteDiaLog2Content(),
      actions: [deleteDiaLog2Action()],
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

  Widget deleteDiaLog2Title() {
    return Container();
  }

  Widget deleteDiaLog2Content() {
    return Container(
        height: 75.0,
        width: 300,
        child: Column(
          children: [
            Text(
              "예약 취소",
              style: TextStyle(
                  color: PRIMARY_COLOR_DEEP,
                  fontSize: 15,
                  fontWeight: FontWeight.w800),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "예약이 취소되었습니다",
              style: TextStyle(
                fontSize: 13,
                color: PRIMARY_COLOR_DEEP,
              ),
            ),
          ],
        ));
  }

  Widget deleteDiaLog2Action() {
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
}
