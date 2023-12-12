class ReviewByFloor {
  final int id;
  final String content;
  final String realTime;
  final String schoolId;

  ReviewByFloor({
    required this.id,
    required this.content,
    required this.realTime,
    required this.schoolId,
  });
  @override
  String toString() => '$id, $content,  $realTime, $schoolId, ';

  factory ReviewByFloor.fromJson(List<dynamic> json) {
    return ReviewByFloor(
      id: json[0] as int,
      content: json[1] as String,
      realTime: json[2] as String,
      schoolId: json[3] as String,
    );
  }
}
