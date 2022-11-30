class ReservationAll {
  final String name;
  final String floor;
  final String time;
  final String isBooked;

  ReservationAll({
    required this.name,
    required this.floor,
    required this.time,
    required this.isBooked,
  });
  @override
  String toString() => '$name, $floor,  $time, $isBooked';

  factory ReservationAll.fromJson(List<dynamic> json) {
    return ReservationAll(
      name: json[0] as String,
      floor: json[1] as String,
      time: json[2].substring(4, 6) +
          ':' +
          json[2].substring(7, 9) +
          ':' +
          json[2].substring(10, 12),
      isBooked: json[3] as String,
    );
  }
}
