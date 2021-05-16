import 'package:flutter/foundation.dart';

class Language {
  final id;
  final nameEn;
  final nameAr;

  Language({
    @required this.id,
    @required this.nameEn,
    @required this.nameAr,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'],
      nameEn: json['name_en'],
      nameAr: json['name_ar'],
    );
  }
}
