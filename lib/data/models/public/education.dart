import 'package:esma3ny/data/models/public/locale_string.dart';
import 'package:flutter/material.dart';

class Education {
  final id;
  final LocaleString school;
  final LocaleString degree;
  final from;
  final to;

  Education({
    this.id,
    @required this.degree,
    @required this.from,
    @required this.school,
    @required this.to,
  });

  factory Education.formJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'],
      degree: LocaleString(
        stringAr: json['degree_ar'],
        stringEn: json['degree_en'],
      ),
      from: json['from'],
      school: LocaleString(
        stringAr: json['school_ar'],
        stringEn: json['school_en'],
      ),
      to: json['to'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'school_en': school.stringEn,
      'school_ar': school.stringAr,
      'degree_en': degree.stringEn,
      'degree_ar': degree.stringAr,
      'from': from,
      'to': to,
    };
  }
}
