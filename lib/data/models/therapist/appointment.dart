import 'package:esma3ny/core/constants.dart';
import 'package:esma3ny/data/models/enums/sessionStatus.dart';
import 'package:esma3ny/data/models/public/profileImage.dart';
import 'package:esma3ny/data/models/public/room.dart';
import 'package:flutter/foundation.dart';

class Appointment {
  final int id;
  final String duration;
  final String clientId;
  final String startTime;
  final String endTime;
  final SessionStatus status;
  final String type;
  final String lastChargeType;
  final Room room;
  final Client client;

  Appointment({
    @required this.type,
    @required this.id,
    @required this.duration,
    @required this.clientId,
    @required this.startTime,
    @required this.endTime,
    @required this.status,
    @required this.lastChargeType,
    @required this.room,
    @required this.client,
  });
  factory Appointment.fromJson(Map<String, dynamic> json) {
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

    return Appointment(
      id: json['id'],
      duration: json['duration'],
      clientId: json['patient_id'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      status: sessionStatus,
      lastChargeType: json['last_charge_type'],
      room: json['room'] == null ? null : Room.fromJson(json['room']),
      client: Client.fromJson(json['patient']),
      type: json['type'],
    );
  }
}

class Client {
  final id;
  final name;
  final dateOfBirth;
  final age;
  final ProfileImage image;

  Client({
    @required this.id,
    @required this.name,
    @required this.dateOfBirth,
    @required this.age,
    @required this.image,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'],
      dateOfBirth: json['date_of_birth'],
      age: ['age'],
      image: ProfileImage.fromjson(json['profile_image']),
    );
  }
}
