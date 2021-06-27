import 'package:flutter/material.dart';

class NewTimeSlot {
  final String startDay;
  final String startTime;
  final String endDay;
  final String duration;

  NewTimeSlot({
    @required this.startDay,
    @required this.startTime,
    @required this.endDay,
    @required this.duration,
  });

  Map<String, String> toJson() {
    return {
      'start_day': startDay,
      'duration': duration,
      'start_time': startTime,
      'end_day': endDay,
    };
  }
}
