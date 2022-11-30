class TodayReservation {
  final String resStatus;
  final String seatStatus;
  final String floor;
  final String name;
  final String time;

  TodayReservation({
    required this.resStatus,
    required this.seatStatus,
    required this.floor,
    required this.name,
    required this.time,
  });
  @override
  String toString() => '$resStatus, $seatStatus,  $floor, $name, $time';

  factory TodayReservation.fromJson(List<dynamic> json) {
    return TodayReservation(
      resStatus: json[0] as String,
      seatStatus: json[1] as String,
      floor: json[2] as String,
      name: json[3] as String,
      time: json[4].substring(4, 6) +
          ':' +
          json[4].substring(7, 9) +
          ':' +
          json[4].substring(10, 12),
    );
  }
}
