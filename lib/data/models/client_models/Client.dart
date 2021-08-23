import 'package:esma3ny/data/models/public/profileImage.dart';
import 'package:flutter/foundation.dart';

class ClientModel {
  final int id;
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String phone;
  final String gender;
  final String dateOfBirth;
  final countryId;
  final deviceName;
  final String stripeId;
  final String age;
  final ProfileImage profilImage;
  final String profileCompeleted;
  final String hasSessionFree;
  final String realTimeZone;

  ClientModel({
    this.id,
    @required this.name,
    @required this.email,
    this.password,
    this.confirmPassword,
    @required this.phone,
    @required this.gender,
    @required this.dateOfBirth,
    @required this.countryId,
    this.age,
    this.stripeId,
    this.deviceName,
    this.profilImage,
    this.profileCompeleted,
    this.hasSessionFree,
    this.realTimeZone,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return ClientModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
      countryId: json['country_id'],
      profilImage: ProfileImage.fromjson(json['profile_image']),
      age: json['age'],
      stripeId: json['stripe_id'],
      profileCompeleted: json['profile_completed'],
      hasSessionFree: json['has_free_session'],
      realTimeZone: json['real_timezone'],
    );
  }

  Map<String, dynamic> toJsonSignup() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
      'phone': phone,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'country_id': countryId,
      'device_name': deviceName,
      'terms_and_condition': true,
    };
  }

  Map<String, dynamic> toJsonEdit() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'password': password,
      'password_confirmation': confirmPassword,
      'date_of_birth': dateOfBirth,
      'country_id': countryId,
      'device_name': deviceName,
    };
  }
}
