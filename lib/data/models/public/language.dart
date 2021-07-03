import 'package:esma3ny/data/models/public/locale_string.dart';
import 'package:flutter/foundation.dart';

class Language {
  final id;
  final LocaleString name;

  Language({
    @required this.id,
    @required this.name,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'],
      name: LocaleString(
        stringEn: json['name_en'],
        stringAr: json['name_ar'],
      ),
    );
  }
}
