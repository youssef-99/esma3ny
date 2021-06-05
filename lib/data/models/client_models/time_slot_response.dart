import 'package:esma3ny/core/constants.dart';
import 'package:esma3ny/data/models/enums/lastChargeType.dart';
import 'package:esma3ny/data/models/enums/sessionStatus.dart';
import 'package:esma3ny/data/models/public/profileImage.dart';
import 'package:esma3ny/data/models/public/room.dart';
import 'package:flutter/foundation.dart';

class TimeSlotResponse {
  final id;
  final sessionId;
  final duration;
  final startTime;
  final endTime;
  final SessionStatus status;
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
  final Room room;

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
    @required this.room,
  });

  factory TimeSlotResponse.fromJson(Map<String, dynamic> json) {
    SessionStatus sessionStatus;
    switch (json['status']) {
      case AVAILABLE:
        sessionStatus = SessionStatus.Available;
        break;
      case NOT_STARTED:
        sessionStatus = SessionStatus.NotStarted;
        break;
      case STARTED:
        sessionStatus = SessionStatus.Started;
        break;
      case FINIDHED:
        sessionStatus = SessionStatus.Finished;
        break;
      case CANCELLED:
        sessionStatus = SessionStatus.Cancelled;
        break;
    }

    return TimeSlotResponse(
      id: json['id'],
      duration: json['duration'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      status: sessionStatus,
      type: json['type'],
      bookedAt: json['booked_at'],
      sessionId: json['session']['id'],
      day: json['session']['day'],
      doctorId: json['session']['doctor']['id'],
      doctorNameEn: json['session']['doctor']['name_en'],
      doctorNameAr: json['session']['doctor']['name_ar'],
      doctorProfileImage:
          ProfileImage.fromjson(json['session']['doctor']['profile_image']),
      amount: json['charges'].length == 0 ? [] : json['charges'][0]['amount'],
      currency:
          json['charges'].length == 0 ? [] : json['charges'][0]['currency'],
      paymentStatus:
          json['charges'].length == 0 ? [] : json['charges'][0]['status'],
      room: Room.fromJson(json['room']),
    );
  }
}
