import 'package:esma3ny/data/models/public/time_slot.dart';
import 'package:flutter/material.dart';

class TherapistTimeSlot {
  final Map<DateTime, List<TimeSlot>> timeSlots;

  TherapistTimeSlot({@required this.timeSlots});

  factory TherapistTimeSlot.fromJson(Map<String, dynamic> json) {
    Map<DateTime, List<TimeSlot>> timeSlots = {};

    json.forEach((day, value) {
      List<TimeSlot> dayTimeSlots = [];
      value['data']
          .forEach((timeSlot) => dayTimeSlots.add(TimeSlot.fromJson(timeSlot)));

      timeSlots.addAll({DateTime.parse(day): dayTimeSlots});
    });

    return TherapistTimeSlot(
      timeSlots: timeSlots,
    );
  }
}
