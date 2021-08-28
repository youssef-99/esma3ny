import 'package:flutter/foundation.dart';

class ClientHealthProfile {
  final String forMe;
  final String name;
  final String dateOfBirth;
  final String gender;
  final String relation;
  final String refer;
  final String maritalStatus;
  final Educations education;
  final children;
  final List services;
  final List<dynamic> problems;
  final familyProblem;
  final String problemStartedAt;
  final String hasFamilyDiagnosed;
  final String nationality;
  final String note;

  ClientHealthProfile({
    @required this.forMe,
    @required this.name,
    @required this.gender,
    @required this.dateOfBirth,
    @required this.relation,
    @required this.refer,
    @required this.nationality,
    @required this.maritalStatus,
    @required this.children,
    @required this.education,
    @required this.services,
    @required this.problems,
    @required this.problemStartedAt,
    @required this.hasFamilyDiagnosed,
    @required this.familyProblem,
    @required this.note,
  });

  factory ClientHealthProfile.fromJson(Map<String, dynamic> json) {
    return ClientHealthProfile(
      forMe: json['for_you'],
      name: json['name'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
      relation: json['relation_to_client'],
      refer: json['referrer'],
      nationality:
          json['nationality'] == null ? '' : json['nationality']['name'],
      maritalStatus: json['marital_status'],
      children: json['childrens'],
      education: Educations.fromJson(json['education']),
      services: json['services'],
      problems: json['problems'],
      problemStartedAt: json['problems_started_at'],
      hasFamilyDiagnosed: json['has_family_diagnosed'],
      familyProblem: json['family_problems'],
      note: json['notes'],
    );
  }

  tojson() {
    return {
      'for_you': forMe,
      'name': name,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'relation_to_client': relation,
      'referrer': refer,
      'nationality_id': nationality,
      'marital_status': maritalStatus,
      'childrens': children,
      'education': education.toJson(),
      'services': services,
      'problems': problems,
      'problems_started_at': problemStartedAt,
      'has_family_diagnosed': hasFamilyDiagnosed,
      'family_problems': {
        'problems': {'1': 'true', '2': 'true', '3': 'false'},
        'notes': familyProblem['notes']
      },
      'notes': note,
    };
  }
}

class Educations {
  final String type;
  final String degree;

  Educations({
    @required this.type,
    @required this.degree,
  });

  factory Educations.fromJson(Map<String, dynamic> json) {
    return Educations(type: json['type'], degree: json['degree']);
  }

  Map<String, String> toJson() {
    return {'type': type, 'degree': degree};
  }
}
