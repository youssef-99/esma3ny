import 'package:esma3ny/data/models/public/country.dart';
import 'package:esma3ny/data/models/public/profileImage.dart';
import 'package:flutter/foundation.dart';

class LoginResponse {
  final String name;
  final String email;
  final ProfileImage profileImage;
  final Country country;

  LoginResponse({
    @required this.name,
    @required this.email,
    @required this.profileImage,
    @required this.country,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      name: json['name'] == null ? json['name_en'] : json['name'],
      email: json['email'],
      profileImage: ProfileImage.fromjson(json['profile_image']),
      country: Country.fromJson(json['country']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profile_image': profileImage.toJson(),
    };
  }
}
