import 'package:flutter/foundation.dart';

class TimeSlot {
  final id;
  final startTime;
  final endTime;
  final text;

  TimeSlot({
    @required this.id,
    @required this.startTime,
    @required this.endTime,
    @required this.text,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      text: json['text'],
    );
  }
}
