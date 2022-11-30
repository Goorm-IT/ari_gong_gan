import 'package:ari_gong_gan/http/ari_server.dart';
import 'package:ari_gong_gan/model/reservation_all.dart';
import 'package:flutter/material.dart';

class RevervationAllProvider extends ChangeNotifier {
  AriServer ariServer = AriServer();
  List<ReservationAll> _revervationAll = [];
  List<ReservationAll> get revervationAll => _revervationAll;

  getReservationAll() async {
    List<ReservationAll> _list = await ariServer.revervationAll();
    _revervationAll = _list;
    notifyListeners();
  }
}
