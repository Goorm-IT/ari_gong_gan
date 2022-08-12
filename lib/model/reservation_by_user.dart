class ReservationByUser {
  final String status;
  final String realTime;
  final String name;
  final String floor;
  final String time;

  ReservationByUser({
    required this.status,
    required this.realTime,
    required this.name,
    required this.floor,
    required this.time,
  });
  @override
  String toString() => '$status, $realTime,  $name, $floor, $time';

  factory ReservationByUser.fromJson(List<dynamic> json) {
    return ReservationByUser(
      status: json[0] as String,
      realTime: json[1] as String,
      name: json[2] as String,
      floor: json[3] as String,
      time: json[4] as String,
    );
  }
}
