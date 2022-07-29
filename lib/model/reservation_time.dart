class ReservationTime {
  String time;
  bool isPossible;
  bool isPressed;

  ReservationTime({
    required this.time,
    required this.isPossible,
    required this.isPressed,
  });
  @override
  String toString() => '$time, $isPossible, $isPressed';
}
