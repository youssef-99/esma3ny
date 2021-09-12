import 'package:flutter/material.dart';

class Therapist {
  final int id;
  final String name;
  final String nameAr;
  final String email;
  final String password;
  final String confirmPassword;
  final String phone;
  final String gender;
  final String dateOfBirth;
  final int countryId;
  final deviceName;
  final String image;
  final String stripeId;
  final String age;

  Therapist({
    this.id,
    @required this.name,
    this.nameAr,
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

  Map<String, dynamic> toJsonUpdate() {
    return <String, dynamic>{
      'name_en': name,
      'name_ar': nameAr,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
      'phone': phone,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'country_id': countryId,
    };
  }
}
