import 'package:flutter/material.dart';

class Therapist {
  final int id;
  @required
  final String name;
  @required
  final String email;
  @required
  final String password;
  @required
  final String confirmPassword;
  @required
  final String phone;
  @required
  final String gender;
  @required
  final String dateOfBirth;
  @required
  final String countryId;
  final deviceName;
  final String image;
  final String stripeId;
  final String age;

  Therapist({
    this.id,
    @required this.name,
    @required this.email,
    this.password,
    this.confirmPassword,
    @required this.phone,
    @required this.gender,
    @required this.dateOfBirth,
    @required this.countryId,
    this.image,
    this.age,
    this.stripeId,
    this.deviceName,
  });

  factory Therapist.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Therapist(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
      countryId: json['country_id'],
      image: json['profile_image'],
      age: json['age'],
      stripeId: json['stripe_id'],
    );
  }

  Map<String, dynamic> toJsonSignup() {
    return <String, dynamic>{
      'name_en': name,
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
}
