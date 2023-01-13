import 'dart:convert';

import 'package:ari_gong_gan/exception/custom_exception.dart';
import 'package:ari_gong_gan/model/reservation.dart';
import 'package:ari_gong_gan/model/reservation_by_user.dart';
import 'package:ari_gong_gan/model/reservation_all.dart';
import 'package:ari_gong_gan/model/today_reservation_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

late String _cookie;

class AriServer {
  String url = 'https://www.arigonggan.site:8000';
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
      return jsonDecode(tmp)["result"];
    } else {
      throw CustomException(400, "로그인 오류");
    }
  }

  Future<int> revervation() async {
    var headers = {'Content-Type': 'text/plain', 'Cookie': _cookie};

    var request = http.Request('POST', Uri.parse('$url/reservation'));
    request.body =
        '{"floor" : "${reservationInfo.floor}","name" : "${reservationInfo.name}","time" : "${reservationInfo.time}"}';
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      String tmp = await response.stream.bytesToString();
      var _list = jsonDecode(tmp)["message"];

      return response.statusCode;
    } catch (e) {
      return -1;
    }
  }

  Future<List<ReservationByUser>> reservationByUser() async {
    var headers = {'Cookie': _cookie};
    var request = http.Request('GET', Uri.parse('$url/user-reservation'));
    List<dynamic> _list = [];
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String tmp = await response.stream.bytesToString();
        _list = jsonDecode(tmp)["res"];
        return _list
            .map<ReservationByUser>((item) => ReservationByUser.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<TodayReservation>> todayReservation() async {
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
          .map<TodayReservation>((item) => TodayReservation.fromJson(item))
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

  Future<int> booked(
      {required String floor,
      required String name,
      required String time}) async {
    var headers = {'Content-Type': 'text/plain', 'Cookie': _cookie};

    var request = http.Request('POST', Uri.parse('$url/booked'));
    request.body = '{"floor" : "$floor" ,"name" : "$name", "time" : "$time"}';
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    print("결과!!");
    print(response.statusCode);
    String tmp = await response.stream.bytesToString();
    var _list = jsonDecode(tmp)["message"];

    return response.statusCode;
  }

  Future<int> delete(
      {required String id,
      required String floor,
      required String name,
      required String time}) async {
    var headers = {'Content-Type': 'text/plain', 'Cookie': _cookie};

    var request = http.Request('POST', Uri.parse('$url/delete'));
    request.body =
        '{"userId" : "$id","floor" : "$floor" ,"name" : "$name", "time" : "$time"}';

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    print('$id $floor $name $time');
    print(response.statusCode);
    String tmp = await response.stream.bytesToString();
    var _list = jsonDecode(tmp)["message"];

    return response.statusCode;
  }
}
