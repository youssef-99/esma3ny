import 'package:flutter/foundation.dart';

class PreviousSession {
  final id;
  final bookedAt;
  final day;

  PreviousSession({
    @required this.id,
    @required this.bookedAt,
    @required this.day,
  });

  factory PreviousSession.fromJson(Map<String, dynamic> json, day) {
    return PreviousSession(
      id: json['id'],
      bookedAt: json['booked_at'],
      day: day,
    );
  }
}
