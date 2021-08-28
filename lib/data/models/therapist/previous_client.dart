import 'package:esma3ny/data/models/public/profileImage.dart';
import 'package:flutter/foundation.dart';

class PreviousClient {
  final id;
  final name;
  final phone;
  final dateOfBirth;
  final age;
  final ProfileImage profileImage;

  PreviousClient({
    @required this.id,
    @required this.name,
    @required this.phone,
    @required this.dateOfBirth,
    @required this.age,
    @required this.profileImage,
  });

  factory PreviousClient.fromJson(Map<String, dynamic> json) {
    return PreviousClient(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      dateOfBirth: json['dateOfBirth'],
      age: json['age'],
      profileImage: ProfileImage.fromjson(json['profile_image']),
    );
  }
}
