import 'package:flutter/material.dart';

class ReservationDeleteFail extends StatefulWidget {
  const ReservationDeleteFail({super.key});

  @override
  State<ReservationDeleteFail> createState() => _ReservationDeleteFailState();
}

class _ReservationDeleteFailState extends State<ReservationDeleteFail> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(top: 10, bottom: 5),
      buttonPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18))),
      title: Container(
        height: 20.0,
        child: Center(
          child: Text(
            "예약취소 실패",
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
            "잠시후 다시 시도해주세요.",
            style: TextStyle(
                color: Color(0xff4888E0),
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
      actions: [emptyListAction()],
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
}
