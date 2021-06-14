import 'package:flutter/foundation.dart';

class AboutTherapistModel {
  final String titleEn;
  final String titleAr;
  final String prefix;
  final String biographyEn;
  final String biographyAr;
  final int jobId;
  final List<int> languageId;

  AboutTherapistModel({
    @required this.titleEn,
    @required this.titleAr,
    @required this.prefix,
    @required this.biographyEn,
    @required this.biographyAr,
    @required this.jobId,
    @required this.languageId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title_en': titleEn,
      'title_ar': titleAr,
      'prefix': prefix,
      'biography_en': biographyEn,
      'biography_ar': biographyAr,
      'job_id': jobId,
      'anguages': languageId,
    };
  }
}
