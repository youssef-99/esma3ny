import 'package:flutter/foundation.dart';

class Specialization {
  final id;
  final nameEn;
  final nameAr;

  Specialization({
    @required this.id,
    @required this.nameEn,
    @required this.nameAr,
  });

  factory Specialization.fromJson(Map<String, dynamic> json) {
    return Specialization(
      id: json['id'],
      nameEn: json['name_en'],
      nameAr: json['name_ar'],
    );
  }
}
