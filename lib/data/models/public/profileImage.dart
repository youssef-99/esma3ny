import 'package:flutter/material.dart';

class ProfileImage {
  final String small;
  final String large;

  ProfileImage({@required this.small, @required this.large});

  factory ProfileImage.fromjson(Map<String, dynamic> json) {
    String small;
    String large;
    small = json['small'].toString().substring(0, 4) != 'http'
        ? 'https://esma3ny.org${json['small']}'
        : json['small'];

    large = json['large'].toString().substring(0, 4) != 'http'
        ? 'https://esma3ny.org${json['large']}'
        : json['large'];
    return ProfileImage(
      small: small,
      large: large,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'small': small,
      'large': large,
    };
  }
}
