import 'package:flutter/material.dart';

class Certificate {
  final id;
  final organizationEn;
  final organizationAr;
  final nameEn;
  final nameAr;
  final from;
  final to;
  final licensingOrganization;
  final licenseNumber;

  Certificate({
    this.id,
    @required this.organizationEn,
    @required this.organizationAr,
    @required this.from,
    @required this.to,
    @required this.licenseNumber,
    @required this.licensingOrganization,
    @required this.nameAr,
    @required this.nameEn,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: ['id'],
      organizationEn: json['organization_en'],
      organizationAr: json['organization_ar'],
      from: json['from'],
      to: json['to'],
      licenseNumber: json['license_number'],
      licensingOrganization: json['licensing_organization'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organization_en': organizationEn,
      'organization_ar': organizationAr,
      'from': from,
      'to': to,
      'name_en': nameEn,
      'name_ar': nameAr,
      'license_number': licenseNumber,
      'licensing_organization': licensingOrganization,
    };
  }
}
