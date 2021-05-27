import 'package:esma3ny/data/models/public/profileImage.dart';
import 'package:flutter/foundation.dart';

class TimeSlotResponse {
  final id;
  final sessionId;
  final duration;
  final startTime;
  final endTime;
  final status;
  final type;
  final bookedAt;
  final paymentStatus;
  final day;
  final doctorId;
  final doctorNameEn;
  final doctorNameAr;
  final ProfileImage doctorProfileImage;
  final amount;
  final currency;
  final roomId;

  TimeSlotResponse({
    @required this.id,
    @required this.sessionId,
    @required this.duration,
    @required this.startTime,
    @required this.endTime,
    @required this.status,
    @required this.type,
    @required this.bookedAt,
    @required this.paymentStatus,
    @required this.day,
    @required this.doctorId,
    @required this.doctorNameEn,
    @required this.doctorNameAr,
    @required this.doctorProfileImage,
    @required this.amount,
    @required this.currency,
    @required this.roomId,
  });

  factory TimeSlotResponse.fromJson(Map<String, dynamic> json) {
    return TimeSlotResponse(
      id: json['id'],
      duration: json['duration'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      status: json['status'],
      type: json['type'],
      bookedAt: json['booked_at'],
      sessionId: json['session']['id'],
      day: json['session']['day'],
      doctorId: json['session']['doctor']['doctor_id'],
      doctorNameEn: json['session']['doctor']['name_en'],
      doctorNameAr: json['session']['doctor']['name_ar'],
      doctorProfileImage:
          ProfileImage.fromjson(json['session']['doctor']['profile_image']),
      amount: json['charges'].length == 0 ? [] : json['charges'][0]['amount'],
      currency:
          json['charges'].length == 0 ? [] : json['charges'][0]['currency'],
      paymentStatus:
          json['charges'].length == 0 ? [] : json['charges'][0]['status'],
      roomId: json['room'],
    );
  }
}
