import 'package:ari_gong_gan/const/user_info.dart';
import 'package:ari_gong_gan/exception/custom_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:html/parser.dart' show parse;

class LoginCrwal {
  String _cookie = '';
  String id, pw;
  LoginCrwal({required this.id, required this.pw});

  Future<http.StreamedResponse> _getResponse(String method, String url,
      [Map<String, String> headers = const {},
      Map<String, String> body = const {}]) {
    http.Request request = http.Request(method, Uri.parse(url));
    request.headers.addAll(headers);
    request.bodyFields = body;
    return request.send();
  }

  Future<void> _login() async {
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final body = {'userDTO.userId': id, 'userDTO.password': pw};
    const url = 'http://cyber.anyang.ac.kr/MUser.do?cmd=loginUser';
    final response = await _getResponse('POST', url, headers, body);
    String rawCookie = response.headers['set-cookie'] ?? '';

    if (response.headers['pragma'] != null) {
      throw new CustomException(300, 'Login Failed');
    } else {
      int index = rawCookie.indexOf(';');
      this._cookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      // print('cookie1: ${this._cookie} ');
    }
  }

  Future<Map<String, String>> userInfo() async {
    await _login();
    final url = 'http://cyber.anyang.ac.kr/MMain.do?cmd=viewIndexPage';
    final response = await _getResponse('GET', url, {'cookie': _cookie});
    final document = parse(await response.stream.bytesToString());

    var loginBtn = document.getElementById('login_popup');
    var element = document.querySelector('.login_info > ul > li:last-child');

    if (loginBtn != null) {
      throw new CustomException(300, 'UserLoadFail');
    }

    String userData = element!.text;
    List<String> data = userData.split(' ');
    Map<String, String> user = {
      'name': data[0],
      'studentId': data[1].substring(1, data[1].length - 1)
    };

    GetIt.I.registerSingleton<AriUser>(
      AriUser(user["name"]!, user["studentId"]!),
    );
    return user;
  }
}
