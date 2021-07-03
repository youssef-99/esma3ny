import 'package:esma3ny/data/models/public/locale_string.dart';
import 'package:flutter/foundation.dart';

class Specialization {
  final id;
  final LocaleString name;

  Specialization({
    @required this.id,
    @required this.name,
  });

  factory Specialization.fromJson(Map<String, dynamic> json) {
    return Specialization(
      id: json['id'],
      name: LocaleString(
        stringEn: json['name_en'],
        stringAr: json['name_ar'],
      ),
    );
  }
}
