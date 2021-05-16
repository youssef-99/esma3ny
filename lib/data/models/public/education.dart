import 'package:flutter/material.dart';

class Education {
  final id;
  final schoolEn;
  final schoolAr;
  final degreeEn;
  final degreeAr;
  final from;
  final to;

  Education({
    this.id,
    @required this.degreeAr,
    @required this.degreeEn,
    @required this.from,
    @required this.schoolAr,
    @required this.schoolEn,
    @required this.to,
  });

  factory Education.formJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'],
      degreeAr: json['degree_er'],
      degreeEn: json['degree_en'],
      from: json['from'],
      schoolAr: json['school_ar'],
      schoolEn: json['school_en'],
      to: json['to'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'school_en': schoolEn,
      'school_ar': schoolAr,
      'degree_en': degreeEn,
      'degree_ar': degreeAr,
      'from': from,
      'to': to,
    };
  }
}
