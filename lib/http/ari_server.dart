import 'dart:convert';

import 'package:ari_gong_gan/model/reservation.dart';
import 'package:ari_gong_gan/model/reservation_by_user.dart';
import 'package:ari_gong_gan/model/resevation_all.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

late String _cookie;

class AriServer {
  String url = 'http://54.183.139.95:8000';
  Future<String> login({required String id, required String pw}) async {
    var headers = {
      'Content-Type': 'text/plain',
    };
    var request = http.Request('POST', Uri.parse('$url/logIn'));

    request.body = '{"userId" : "$id","password" : "$pw"}';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String _tmpCookie = response.headers['set-cookie'] ?? '';
    var idx = _tmpCookie.indexOf(';');
    _cookie = (idx == -1) ? _tmpCookie : _tmpCookie.substring(0, idx);
    if (response.statusCode == 200) {
      String tmp = await response.stream.bytesToString();

      return jsonDecode(tmp)["message"];
    } else {
      return "Login Fail";
    }
  }

  Future<int> revervation() async {
    var headers = {'Content-Type': 'text/plain', 'Cookie': _cookie};
    print(reservationInfo);
    var request = http.Request('POST', Uri.parse('$url/reservation'));
    request.body =
        '{"floor" : "${reservationInfo.floor}","name" : "${reservationInfo.name}","time" : "${reservationInfo.time}","userNum" : "01012341234"}';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    return response.statusCode;
  }

  Future<List<ReservationByUser>> reservationByUser() async {
    var headers = {'Cookie': _cookie};
    var request = http.Request('GET', Uri.parse('$url/reservationList'));
    List<dynamic> _list = [];
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print(response.statusCode);
    if (response.statusCode == 200) {
      String tmp = await response.stream.bytesToString();
      _list = jsonDecode(tmp)["res"];
      return _list
          .map<ReservationByUser>((item) => ReservationByUser.fromJson(item))
          .toList();
    } else {
      return [];
    }
  }

  Future<List<ReservationAll>> revervationAll() async {
    var headers = {'Cookie': _cookie};
    var request = http.Request('GET', Uri.parse('$url/all'));
    List<dynamic> _list = [];
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String tmp = await response.stream.bytesToString();
      _list = jsonDecode(tmp)["res"];
      return _list
          .map<ReservationAll>((item) => ReservationAll.fromJson(item))
          .toList();
    } else {
      return [];
    }
  }
}