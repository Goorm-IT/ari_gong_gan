import 'package:ari_gong_gan/const/colors.dart';
import 'package:ari_gong_gan/widget/custom_appbar.dart';
import 'package:ari_gong_gan/widget/custom_dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AgreementPageInMyPage extends StatefulWidget {
  const AgreementPageInMyPage({super.key});

  @override
  State<AgreementPageInMyPage> createState() => _AgreementPageInMyPageState();
}

class _AgreementPageInMyPageState extends State<AgreementPageInMyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context, false, true),
      body: Container(
        color: Colors.white,
        child: RawScrollbar(
          thumbVisibility: true,
          thickness: 10,
          thumbColor: PRIMARY_COLOR_DEEP,
          radius: Radius.circular(20),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                    future: loadTextAsset('assets/texts/agreement.txt'),
                    builder: (context, snapshot) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            " [서비스 이용 약관]",
                            style: TextStyle(
                                color: PRIMARY_COLOR_DEEP,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          custom_dotted_line(divide: 2, margin: 0),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            snapshot.data.toString(),
                            style: TextStyle(
                                color: PRIMARY_COLOR_DEEP, fontSize: 12),
                          ),
                        ],
                      );
                    },
                  ),
                  FutureBuilder(
                    future:
                        loadTextAsset('assets/texts/personal_information.txt'),
                    builder: (context, snapshot) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            " [개인정보 취급 방침]",
                            style: TextStyle(
                                color: PRIMARY_COLOR_DEEP,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          custom_dotted_line(divide: 2, margin: 0),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            snapshot.data.toString(),
                            style: TextStyle(
                                color: PRIMARY_COLOR_DEEP, fontSize: 12),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> loadTextAsset(String path) async {
    return await rootBundle.loadString(path);
  }
}
