import 'package:esma3ny/data/models/public/profileImage.dart';
import 'package:flutter/foundation.dart';

class TimeSlot {
  final id;
  final startTime;
  final endTime;
  final duration;
  final ReserverClientData client;

  TimeSlot({
    @required this.id,
    @required this.startTime,
    @required this.endTime,
    @required this.duration,
    this.client,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      duration: json['duration'],
      client: json['patient'] == null
          ? null
          : ReserverClientData.fromJson(json['patient']),
    );
  }
}

class ReserverClientData {
  final String name;
  final ProfileImage image;

  ReserverClientData({
    @required this.name,
    @required this.image,
  });

  factory ReserverClientData.fromJson(Map<String, dynamic> json) {
    return ReserverClientData(
        name: json['name'], image: ProfileImage.fromjson(json['image']));
  }
}
