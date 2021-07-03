import 'package:esma3ny/data/models/public/locale_string.dart';
import 'package:esma3ny/data/models/public/profileImage.dart';
import 'package:flutter/foundation.dart';

class Doctor {
  final int id;
  final LocaleString name;
  final LocaleString title;
  final ProfileImage profileImage;

  Doctor({
    @required this.id,
    @required this.name,
    @required this.title,
    @required this.profileImage,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: LocaleString(
        stringEn: json['name_en'],
        stringAr: json['name_ar'],
      ),
      title: LocaleString(
        stringEn: json['title_en'],
        stringAr: json['title_ar'],
      ),
      profileImage: ProfileImage.fromjson(
        json['profile_image'],
      ),
    );
  }
}

class SessionHistoryModel {
  final int id;
  final String duration;
  final String startTime;
  final String endTime;
  final String status;
  final String type;
  final String sessionId;
  final String day;
  final Doctor doctor;

  SessionHistoryModel({
    @required this.id,
    @required this.duration,
    @required this.startTime,
    @required this.endTime,
    @required this.status,
    @required this.type,
    @required this.sessionId,
    @required this.day,
    @required this.doctor,
  });

  factory SessionHistoryModel.fromJson(Map<String, dynamic> json) {
    return SessionHistoryModel(
      id: json['id'],
      duration: json['duration'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      status: json['status'],
      type: json['type'],
      sessionId: json['sessionId'],
      day: json['session']['day'],
      doctor: Doctor.fromJson(
        json['session']['doctor'],
      ),
    );
  }
}
