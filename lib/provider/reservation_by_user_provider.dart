import 'package:ari_gong_gan/http/ari_server.dart';
import 'package:ari_gong_gan/model/reservation_by_user.dart';
import 'package:flutter/material.dart';

class ReservationByUserProvider extends ChangeNotifier {
  AriServer ariServer = AriServer();
  List<ReservationByUser> _reservationByUser = [];
  List<ReservationByUser> get reservationByUser => _reservationByUser;

  getReservationByUser() async {
    List<ReservationByUser> _list = await ariServer.reservationByUser();
    _reservationByUser = _list;
    notifyListeners();
  }
}
