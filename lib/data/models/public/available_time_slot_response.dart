import 'package:esma3ny/data/models/public/time_slot.dart';
import 'package:flutter/foundation.dart';

class AvailableTimeSlotResponse {
  final date;
  final count;
  final List<TimeSlot> timeSlots;

  AvailableTimeSlotResponse({
    @required this.date,
    @required this.count,
    @required this.timeSlots,
  });

  factory AvailableTimeSlotResponse.fromJson(
      String day, Map<String, dynamic> json) {
    return AvailableTimeSlotResponse(
      date: day,
      count: json['count'],
      timeSlots:
          json['data'].forEach((timeSlot) => TimeSlot.fromJson(timeSlot)),
    );
  }
}
