import 'package:flutter/foundation.dart';

class HealthProfileJson {
  final String forMe;
  final String name;
  final String gender;
  final String dateOfBirth;
  final String relation;
  final String refer;
  final int nationalityId;
  final String maritalStatus;
  final int children;
  final Education education;
  final Map<String, String> services;
  final List<String> problems;
  final String problemStartedAt;
  final String hasFamilyDiagnosed;
  final familyProblem;
  final String note;

  HealthProfileJson({
    @required this.forMe,
    @required this.name,
    @required this.gender,
    @required this.dateOfBirth,
    @required this.relation,
    @required this.refer,
    @required this.nationalityId,
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

  tojson() {
    return {
      'for_you': forMe,
      'name': name,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'relation_to_client': relation,
      'referrer': refer,
      'nationality_id': nationalityId,
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

class Education {
  final String type;
  final String degree;

  Education({
    @required this.type,
    @required this.degree,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(type: json['type'], degree: json['degree']);
  }

  Map<String, String> toJson() {
    return {'type': type, 'degree': degree};
  }
}
