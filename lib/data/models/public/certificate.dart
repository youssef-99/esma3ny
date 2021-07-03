import 'package:esma3ny/data/models/public/locale_string.dart';
import 'package:flutter/material.dart';

class Certificate {
  final id;
  final LocaleString organization;
  final LocaleString name;
  final from;
  final to;
  final licensingOrganization;
  final licenseNumber;

  Certificate({
    this.id,
    @required this.organization,
    @required this.from,
    @required this.to,
    @required this.licenseNumber,
    @required this.licensingOrganization,
    @required this.name,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: ['id'],
      organization: LocaleString(
        stringEn: json['organization_en'],
        stringAr: json['organization_ar'],
      ),
      from: json['from'],
      to: json['to'],
      licenseNumber: json['license_number'],
      licensingOrganization: json['licensing_organization'],
      name: LocaleString(
        stringAr: json['name_ar'],
        stringEn: json['name_en'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organization_en': organization.stringEn,
      'organization_ar': organization.stringAr,
      'from': from,
      'to': to,
      'name_en': name.stringEn,
      'name_ar': name.stringAr,
      'license_number': licenseNumber,
      'licensing_organization': licensingOrganization,
    };
  }
}
