import 'package:esma3ny/data/models/public/profileImage.dart';
import 'package:flutter/foundation.dart';

class LoginResponse {
  final String name;
  final String email;
  final ProfileImage profileImage;

  LoginResponse({
    @required this.name,
    @required this.email,
    @required this.profileImage,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      name: json['name'] == null ? json['name_en'] : json['name'],
      email: json['email'],
      profileImage: ProfileImage.fromjson(json['profile_image']),
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
