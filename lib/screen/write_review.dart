import 'package:ari_gong_gan/const/colors.dart';
import 'package:ari_gong_gan/http/ari_server.dart';
import 'package:ari_gong_gan/model/reservation_by_user.dart';
import 'package:ari_gong_gan/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WriteReview extends StatefulWidget {
  final ReservationByUser info;
  const WriteReview({super.key, required this.info});

  @override
  State<WriteReview> createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context, false, true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 16, top: 16),
            child: Text(
              '${widget.info.floor} ${widget.info.name}',
              style: TextStyle(fontSize: 22),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16),
            child: Text(
                '이용날짜 :  ${DateFormat('yyyy. MM. dd').format(DateTime.parse(widget.info.realTime))}'),
          ),
          SizedBox(height: 30),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width - 32,
            child: TextField(
              onChanged: (_) {
                setState(() {});
              },
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                hintText: "다른 학우들이 참고할 수 있도록 리뷰를 작성해주세요!",
                hintStyle: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: GestureDetector(
        onTap: controller.text == ''
            ? null
            : () async {
                AriServer ariServer = AriServer();
                await ariServer.review(
                    floor: widget.info.floor,
                    name: widget.info.name,
                    time: widget.info.time,
                    content: controller.text);
                Navigator.pop(context, true);
              },
        child: Container(
            height: 50,
            color: controller.text == '' ? Colors.grey : PRIMARY_COLOR_DEEP,
            child: Center(
              child: Text(
                "등록하기",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            )),
      ),
    );
  }
}
