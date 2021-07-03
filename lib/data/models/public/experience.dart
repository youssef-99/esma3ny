import 'package:esma3ny/data/models/public/locale_string.dart';
import 'package:flutter/foundation.dart';

class Experience {
  final id;
  final LocaleString name;
  final LocaleString title;
  final from;
  final to;
  final city;
  final countryId;

  Experience({
    this.id,
    @required this.name,
    @required this.title,
    @required this.from,
    @required this.to,
    @required this.city,
    @required this.countryId,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
        id: json['id'],
        name: LocaleString(
          stringEn: json['name_en'],
          stringAr: json['name_ar'],
        ),
        title: LocaleString(
          stringEn: json['title_en'],
          stringAr: json['title_en'],
        ),
        from: json['from'],
        to: json['to'],
        city: json['city'],
        countryId: json['country_id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name_en': name.stringEn,
      'name_ar': name.stringAr,
      'title_en': title.stringEn,
      'title_ar': title.stringAr,
      'from': from,
      'to': to,
      'country_id': countryId,
      'city': city,
    };
  }
}
