import 'package:flutter/material.dart';

class Country {
  final int id;
  final String name;
  final String code;

  Country({
    @required this.id,
    @required this.name,
    @required this.code,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Country(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
    };
  }
}
