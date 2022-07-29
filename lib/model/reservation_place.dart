import 'package:ari_gong_gan/model/reservation_time.dart';

class ReservationPlace {
  String place;
  List<ReservationTime> time;
  bool isPossible;
  bool isPressed;

  ReservationPlace({
    required this.place,
    required this.time,
    required this.isPossible,
    required this.isPressed,
  });
  @override
  String toString() => '$place, $time,  $isPossible, $isPressed';
}
