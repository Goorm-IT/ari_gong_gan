class Reservation {
  String floor;
  String name;
  String time;
  String userNum;

  Reservation({
    required this.floor,
    required this.name,
    required this.time,
    required this.userNum,
  });
  @override
  String toString() =>
      'floor : $floor, name : $name, time : $time, userNum : $userNum';
}

Reservation reservationInfo =
    Reservation(floor: "", name: "", time: "", userNum: "");
