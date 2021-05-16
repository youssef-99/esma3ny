import 'package:flutter/foundation.dart';

class Experience {
  final id;
  final nameEn;
  final nameAr;
  final titleEn;
  final titleAr;
  final from;
  final to;
  final city;
  final countryId;

  Experience({
    this.id,
    @required this.nameEn,
    @required this.nameAr,
    @required this.titleEn,
    @required this.titleAr,
    @required this.from,
    @required this.to,
    @required this.city,
    @required this.countryId,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
        id: json['id'],
        nameEn: json['name_en'],
        nameAr: json['name_ar'],
        titleEn: json['title_en'],
        titleAr: json['title_ar'],
        from: json['from'],
        to: json['to'],
        city: json['city'],
        countryId: json['country_id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name_en': nameEn,
      'name_ar': nameAr,
      'title_en': titleEn,
      'title_ar': titleAr,
      'from': from,
      'to': to,
      'country_id': countryId,
      'city': city,
    };
  }
}
