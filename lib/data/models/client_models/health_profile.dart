import 'package:flutter/foundation.dart';

class HealthProfileHelper {
  final List<MapEntry<String, String>> maritalStatus;
  final List<MapEntry<String, String>> education;
  final List<MapEntry<String, String>> degree;
  final List<MapEntry<String, String>> problems;
  final List<MapEntry<String, String>> services;

  HealthProfileHelper({
    @required this.maritalStatus,
    @required this.education,
    @required this.degree,
    @required this.problems,
    @required this.services,
  });

  factory HealthProfileHelper.fromJson(Map<String, dynamic> json) {
    final List<MapEntry<String, String>> maritalStatus = [];
    json['marital_status'].forEach(
        (String key, dynamic value) => maritalStatus.add(MapEntry(key, value)));

    final List<MapEntry<String, String>> education = [];
    json['education'].forEach(
        (String key, dynamic value) => education.add(MapEntry(key, value)));

    final List<MapEntry<String, String>> degree = [];
    json['degree'].forEach(
        (String key, dynamic value) => education.add(MapEntry(key, value)));

    final List<MapEntry<String, String>> problems = [];
    json['problems'].forEach(
        (String key, dynamic value) => education.add(MapEntry(key, value)));

    final List<MapEntry<String, String>> services = [];
    json['services'].forEach(
        (String key, dynamic value) => education.add(MapEntry(key, value)));

    return HealthProfileHelper(
      maritalStatus: maritalStatus,
      education: education,
      degree: degree,
      problems: problems,
      services: services,
    );
  }
}
