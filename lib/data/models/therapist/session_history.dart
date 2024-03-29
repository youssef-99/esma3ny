import 'package:flutter/foundation.dart';

class SessionHistory {
  final int id;
  final String duration;
  final String startTime;
  final String endTime;
  final String type;
  final String status;
  final String lastChargeType;
  final Client client;

  SessionHistory(
    this.id,
    this.duration,
    this.startTime,
    this.endTime,
    this.type,
    this.status,
    this.lastChargeType,
    this.client,
  );

  factory SessionHistory.fromJson(Map<String, dynamic> json) {
    return SessionHistory(
      json['id'],
      json['duration'],
      json['start_time'],
      json['end_time'],
      json['type'],
      json['status'],
      json['last_charge_type'],
      Client.fromJson(json['patient']),
    );
  }
}

class Client {
  final int id;
  final String name;
  final String age;

  Client({@required this.id, @required this.name, @required this.age});

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(id: json['id'], name: json['name'], age: json['age']);
  }
}
