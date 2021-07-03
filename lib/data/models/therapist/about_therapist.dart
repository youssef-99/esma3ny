import 'package:esma3ny/data/models/public/locale_string.dart';
import 'package:flutter/foundation.dart';

class AboutTherapistModel {
  final LocaleString title;
  final String prefix;
  final LocaleString biography;
  final int jobId;
  final List<int> languageId;

  AboutTherapistModel({
    @required this.title,
    @required this.prefix,
    @required this.biography,
    @required this.jobId,
    @required this.languageId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title_en': title.stringEn,
      'title_ar': title.stringAr,
      'prefix': prefix,
      'biography_en': biography.stringEn,
      'biography_ar': biography.stringAr,
      'job_id': jobId,
      'languages': languageId,
    };
  }
}
