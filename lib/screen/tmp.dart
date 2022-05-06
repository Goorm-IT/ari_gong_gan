import 'package:ari_gong_gan/const/user_info.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Tmp extends StatefulWidget {
  const Tmp({Key? key}) : super(key: key);

  @override
  State<Tmp> createState() => _TmpState();
}

class _TmpState extends State<Tmp> {
  late AriUser userInfo;
  @override
  void initState() {
    super.initState();
    userInfo = GetIt.I<AriUser>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(userInfo.name),
      ),
    );
  }
}
