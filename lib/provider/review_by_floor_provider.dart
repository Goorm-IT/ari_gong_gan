import 'package:ari_gong_gan/http/ari_server.dart';
import 'package:ari_gong_gan/model/reservation_all.dart';
import 'package:ari_gong_gan/model/review_by_floor.dart';
import 'package:flutter/material.dart';

class ReviewByFloorProvider extends ChangeNotifier {
  AriServer ariServer = AriServer();
  Map<String, List<ReviewByFloor>> _reviewByFloor = {};
  Map<String, List<ReviewByFloor>> get reviewByFloor => _reviewByFloor;

  getReviewByFloor({required String floor}) async {
    List<ReviewByFloor> list = await ariServer.getReview(floor: floor);
    _reviewByFloor[floor] = list;
    notifyListeners();
  }
}
