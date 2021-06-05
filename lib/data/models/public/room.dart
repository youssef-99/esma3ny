import 'package:flutter/foundation.dart';

class Room {
  final int id;
  final String type;
  final String uuid;
  final String password;
  final String token;

  Room({
    @required this.id,
    @required this.type,
    @required this.uuid,
    @required this.password,
    @required this.token,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      password: json['password'],
      token: json['token'],
      type: json['type'],
      uuid: json['uuid'],
    );
  }
}
