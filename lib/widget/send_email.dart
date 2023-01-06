import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter/material.dart';

void _sendEmail() async {
  final Email email = Email(
    subject: '[아리공간 문의]',
    recipients: ['onionfamily.official@gmail.com'],
    cc: [],
    bcc: [],
    attachmentPaths: [],
    isHTML: false,
  );

  try {
    await FlutterEmailSender.send(email);
  } catch (error) {
    String title =
        "기본 메일 앱을 사용할 수 없기 때문에 앱에서 바로 문의를 전송하기 어려운 상황입니다.\n\n아래 이메일로 연락주시면 친절하게 답변해드릴게요 :)\n\nonionfamily.official@gmail.com";
    String message = "";
    // _showErrorAlert(title: title, message: message);
    print(title);
  }
}
