import 'package:flutter/material.dart';

class ProfileImage {
  final small;
  final large;

  ProfileImage({@required this.small, @required this.large});

  factory ProfileImage.fromjson(Map<String, dynamic> json) {
    return ProfileImage(
      small: 'https://esma3ny.org${json['small']}',
      large: 'https://esma3ny.org${json['large']}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'small': small,
      'large': large,
    };
  }
}
