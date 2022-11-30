import 'package:ari_gong_gan/http/ari_server.dart';

import 'package:ari_gong_gan/model/today_reservation_list.dart';
import 'package:flutter/material.dart';

class TodayReservationProvider extends ChangeNotifier {
  AriServer ariServer = AriServer();
  List<TodayReservation> _todayReservation = [];
  List<TodayReservation> get todayReservation => _todayReservation;

  getTodayReservation() async {
    List<TodayReservation> _list = await ariServer.todayReservation();
    _todayReservation = _list;
    notifyListeners();
  }
}
